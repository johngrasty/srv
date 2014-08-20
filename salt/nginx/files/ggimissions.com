#     Managed by Salt - 2014-07-21 - 1:01 PM


server {
	listen 80;
    server_name .ggimissions.com;
	return 301 $scheme://www.ggimissions.com$uri;
}

server {
    listen          80;
    server_name     .globalgospel.info;
    return          301 $scheme://www.ggimissions.com$uri;
}

server {
     listen 80;
     listen 443 ssl;
     ssl_certificate        /opt/local/etc/nginx/ssl/ggimissions.crt;
     ssl_certificate_key    /opt/local/etc/nginx/ssl/ggimissions.key;

     server_name www.ggimissions.com;

     access_log off;
     error_log /var/log/nginx/ggimissions-error.log warn;




       location / {
        proxy_set_header    Host $http_host;
        proxy_set_header    X-Forwarded-Host $host;
        proxy_set_header    X-Forwarded-Server $host;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://10.0.0.99:80/;
  }
 }