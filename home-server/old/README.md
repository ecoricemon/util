# Home server  

Structure  
Reverse proxy -- Git server  
              -- Cloud storage  

Utilities: Video converting script  

## proxy  

Reverse proxy server  

### How to set certificates
1. Make cert by using enveloped cert.ext.  
1. Copy cert.key and cert.crt to envoy/certs/
1. Follow auto-kube's content, but use enveloped files instead.
1. Run docker compose.  

## git  

Git server  

### How to login as 'root' user
1. See 'volume/config/initial_root_password'.  
1. Put that password in the login screen.  
1. Please don't forget to change your password.  

## cloud  

Cloud storage server  

Nothing to comment now.  

## Utilities  

### videocvt  

Video converting script  

This converts videos into WebM.  
It uses ffmpeg and chooses VP9 and Opus as video and audio codesc respectively.
All configurations are pre-defined in the script and referring to 
[Recommended Settings for VOD](https://developers.google.com/media/vp9/settings/vod/)


#### How to use it  

You need to prepare folder structure like:  
somewhere/ 
|_ src/  
|_ convert.py  

Then put your video files into 'src/' directory and run convert.py  
It reads 'src/' and trys to convert video files within it recursively.  
And it generates folders and files converted in the same structure.  

### pack.sh  

This substitutes some secret contents into other strings.  
And then it generates 'targets.tar' to share it with people.  
Finally, it recovers the secrets.

#### How to use it  
```sh
./pack.sh keys subs
```

#### keys  

Definition of secret contents  
See an example below.  
```sh
my.server.domain
id
password
```

#### subs  

Definition of substitutions
See an example below.  
```sh
xxx.yyy.zzz
guess-me
guess-me2
```


