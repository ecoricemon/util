## Envoy

1. Make cert by using enveloped cert.ext  
1. Copy cert.key and cert.crt to envoy/certs/
1. Follow auto-kube's content, but use enveloped files instead
> Please check files out carefully  
1. Run docker compose  
- at proxy dir  
```sh
docker compose up -d
```

## Nextcloud  

1. Run docker compose  
- at cloud dir  
```sh
docker compose up -d
```

1. Append it to the envoy proxy  
- at proxy dir  
```sh
./gen.sh
name: anything you want (I'm gonna use 'temp' here)
port: 12080
path: anything you want (I'm gonna use 'temp' here)
```

1. Add prefix_rewrite rule on the proxy site  
- proxy's envoy/lds/cur.yaml & envoy/lds/hosts/??-host.yaml  
```yaml
- match:
    prefix: /temp
  route:
    cluster: temp
    prefix_rewrite: "/" # I think nextcloud can't handle additional path, so remove it here
```

1. Add white list and overwrite rule on the cloud site  
- cloud's nextcloud/config/config.php  
```php
'trusted_domains' =>
 array (
   0 => '000.000.000.000',          // Proxy IP
   1 => 'my-id.router-ddns.com',    // Proxy domain name
 ),
 'trusted_proxies' => ['000.000.000.000'],  // Proxy IP
 'overwritewebroot' => '/temp',            // The path you put when you were running proxy's gen.sh
                                            // This will be included when redirected, so proxy can pass it to the cloud
 'overwriteprotocol' => 'https',            // Proxy is using https, right?
```

