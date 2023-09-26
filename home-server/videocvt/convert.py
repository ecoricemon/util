# ref: https://developers.google.com/media/vp9/settings/vod/

import os
import math
import subprocess
from multiprocessing import Pool
from datetime import datetime

def log(level: str, msg: str):
    print(" ".join([
        "[" + str(datetime.now()) + "]",
        "[" + level + "]",
        msg
    ]))

# Returns input option like -i src.mp4
def get_input_option(file_path: str) -> list[str]:
    return ["-i", file_path]

# Returns codec option like -c:v libvpx-vp9 -c:a libopus
def get_codec_option() -> list[str]:
    return ["-c:v", "libvpx-vp9", "-c:a", "libopus"]

# Returns resolution option like -vf scale=1920x1080
def get_resolution_option(frame_height: int) -> [str]:
    if frame_height <= 240:
        res = "320x240"
    elif frame_height <= 360:
        res = "640x360"
    elif frame_height <= 480:
        res = "640x480"
    elif frame_height <= 720:
        res = "1280x720"
    elif frame_height <= 1080:
        res = "1920x1080"
    elif frame_height <= 1440:
        res = "2560x1440"
    else:
        res = "3840x2160"
    return ["-vf", "scale=" + res]

# Returns bitrate option like -b:v 1800k -minrate 900 -maxrate 2610
def get_bitrate_option(frame_height: int, frame_rate: int) -> list[str]:
    if frame_height <= 240:
        rate = "-b:v 150k -minrate 75k -maxrate 218k"
    elif frame_height <= 360:
        rate = "-b:v 276k -minrate 138k -maxrate 400k"
    elif frame_height <= 480:
        rate = "-b:v 750k -minrate 375k -maxrate 1088k"
    elif frame_height <= 720:
        if frame_rate <= 30:
            rate = "-b:v 1024k -minrate 512k -maxrate 1485k"
        else:
            rate = "-b:v 1800k -minrate 900k -maxrate 2610k"
    elif frame_height <= 1080:
        if frame_rate <= 30:
            rate = "-b:v 1800k -minrate 900k -maxrate 2610k"
        else:
            rate = "-b:v 3000k -minrate 1500k -maxrate 4350k"
    elif frame_height <= 1440:
        if frame_rate <= 30:
            rate = "-b:v 6000k -minrate 3000k -maxrate 8700k"
        else:
            rate = "-b:v 9000k -minrate 4500k -maxrate 13050k"
    else:
        if frame_rate <= 30:
            rate = "-b:v 12000k -minrate 6000k -maxrate 17400k"
        else:
            rate = "-b:v 18000k -minrate 9000k -maxrate 26100k"
    return rate.split(" ")

# Returns multi-pass encoding and encoding speed option like -pass 1 -speed 4
def get_multipass_option(frame_height: int, _pass: int) -> list[str]:
    if _pass == 1:
        speed = "4"
    else:
        speed = "1" if frame_height <= 480 else "2"
    return ["-pass", str(_pass), "-speed", speed]

# Returns qualtity option like -quality good -crf 31
def get_quality_option(frame_height: int) -> list[str]:
    if frame_height <= 240:
        cq = "37"
    elif frame_height <= 360:
        cq = "36"
    elif frame_height <= 480:
        cq = "33"
    elif frame_height <= 720:
        cq = "32"
    elif frame_height <= 1080:
        cq = "31"
    elif frame_height <= 1440:
        cq = "24"
    else:
        cq = "15"
    return ["-quality", "good", "-crf", cq]

# Returns keyframe spacing option like -g 240
def get_keyframe_option() -> list[str]:
    return ["-g", "240"]

# Returns tiling option like -tile-columns 2 -threads 4
def get_tiling_option(frame_height: int) -> list[str]:
    # ncol = 0
    # if frame_height <= 240:
    #     ncol = 0
    # elif frame_height <= 480:
    #     ncol = 1
    # elif frame_height <= 1080:
    #     ncol = 2
    # else:
    #     ncol = 3
    # nth = int(math.pow(2, ncol + 1))
    # ncpu = os.cpu_count()
    # if ncpu * 2 <= nth:
    #     ncol = int(math.sqrt(ncpu))
    #     nth = int(math.pow(2, ncol + 1))
    # return ["-tile-columns", str(ncol), "-threads", str(nth)]
    return ["-tile-columns", "0", "-threads", "2"]

# Returns frame height of the video file
def get_frame_height(input_path: str) -> tuple[int, int]:
    cmd = ["ffprobe", "-v", "error", "-select_streams", "v:0", "-show_entries", "stream=height", "-of", "csv=s=x:p=0", input_path]
    res = subprocess.run(cmd, stdout = subprocess.PIPE, text = True)
    if res.returncode != 0:
        return (res.returncode, 0)
    height = int(res.stdout)
    return (res.returncode, height)

# Returns frame rate of the video file
def get_frame_rate(input_path: str) -> tuple[int, float]:
    cmd = ["ffprobe", "-v", "error", "-select_streams", "v", "-of", "default=noprint_wrappers=1:nokey=1", "-show_entries", "stream=r_frame_rate", input_path] 
    res = subprocess.run(cmd, stdout = subprocess.PIPE, text = True)
    if res.returncode != 0:
        return (res.returncode, 0.0)
    f = res.stdout.split("/")
    return (res.returncode, int(f[0]) / int(f[1]))

# Returns ffmpeg command to convert from something to webm
def get_convert_command(input_path: str,  output_path: str, frame_height: int, frame_rate: int, _pass: int) -> list[str]:
    cmd = ["ffmpeg"]
    cmd.extend(get_input_option(input_path))
    cmd.extend(get_codec_option())
    cmd.extend(get_resolution_option(frame_height))
    cmd.extend(get_bitrate_option(frame_height, frame_rate))
    cmd.extend(get_multipass_option(frame_height, _pass))
    cmd.extend(get_quality_option(frame_height))
    cmd.extend(get_keyframe_option())
    cmd.extend(get_tiling_option(frame_height))
    cmd.extend(["-loglevel", "quiet"]) # Quiet
    cmd.append("-y") # Overwrite
    cmd.append(output_path)
    return cmd

# Gather source & destination paths
def gather_path(src_root: str, dest_root: str) -> tuple[list[str], list[str]]:
    inputs = []
    outputs = []
    for src_path, dirs, files in os.walk(src_root):
        if len(files) == 0:
            continue
        dest_path = dest_root + src_path[len(src_root):]
        os.makedirs(dest_path, 0o777, True)
        for file in files:
            if len(file) == 0 or file[0] == '.':
                continue
            ext = os.path.splitext(file)[1]
            if ext.lower() == ".webm":
                continue
            inputs.append(src_path + "/" + file)
            outputs.append(dest_path + "/" + file[:-len(ext)] + ".webm")
    return (inputs, outputs)

# Converting job
def convert(input: str, output: str) -> int:
    ret1, height = get_frame_height(input)
    ret2, rate = get_frame_rate(input)
    if ret1 != 0 or ret2 != 0:
        log("info", "Not a video file, skip")
        return 0
    for _pass in [1, 2]:
        cmd = get_convert_command(input, output, height, math.ceil(rate), _pass)
        log("info", "[Command]: " + " ".join(cmd))
        ret = subprocess.run(cmd, stdout = subprocess.PIPE, text = True)
        if ret != 0:
            log("error", "Failed. " + input)
            return ret
    log("info", "Done")
    return 0

if __name__ == "__main__":
    inputs, outputs = gather_path("src", "dest")
    n = len(inputs)
    args = [(inputs[i], outputs[i]) for i in range(n)]
    nproc = int(os.cpu_count() / 2)
    with Pool(nproc) as pool:
        ret = pool.starmap(convert, args)
        if ret != 0:
            log("error", "Inhereted fail")
            exit(ret)
