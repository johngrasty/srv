#     Managed by Salt - 2014-07-21 - 1:01 PM


# redirect http to https.
server {
  listen 80;
  server_name owncloud.ggimissions.com;
  return 301 https://$server_name$request_uri;  # enforce https
}

# owncloud (ssl/tls)
server {
  listen 443 ssl;
  ssl_certificate /usr/local/etc/nginx/keys/ggi_bundle_2014.crt;
  ssl_certificate_key /usr/local/etc/nginx/keys/ggi-2014.key;
  keepalive_timeout    70;

  ssl_prefer_server_ciphers on;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;


  server_name owncloud.ggimissions.com;
  error_log  /var/log/nginx/owncloud-error.log;
  access_log /var/log/nginx/owncloud-access.log;
  root /usr/home/don_web/public/owncloud.ggimissions.com/owncloud;
  index index.php;
  client_max_body_size 1000M; # set maximum upload size
  fastcgi_buffers 64 4K;
  gzip off;

        rewrite ^/caldav(.*)$ /remote.php/caldav$1 redirect;
        rewrite ^/carddav(.*)$ /remote.php/carddav$1 redirect;
        rewrite ^/webdav(.*)$ /remote.php/webdav$1 redirect;

        index index.php;
        error_page 403 = /core/templates/403.php;
        error_page 404 = /core/templates/404.php;

        location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
        }

        location = /favicon.ico {
             access_log off;
             log_not_found off;
        }


        location ~ ^/(data|config|\.ht|db_structure\.xml|README) {
                deny all;
        }

        location / {
                # The following 2 rules are only needed with webfinger
                rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
                rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

                rewrite ^/.well-known/carddav /remote.php/carddav/ redirect;
                rewrite ^/.well-known/caldav /remote.php/caldav/ redirect;

                rewrite ^(/core/doc/[^\/]+/)$ $1/index.html;

                try_files $uri $uri/ index.php;
        }


        location ~ ^(.+?\.php)(/.*)?$ {
                try_files $1 = 404;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                #fastcgi_param SCRIPT_FILENAME $document_root$1;
                fastcgi_param PATH_INFO $2;
                fastcgi_param HTTPS on;
                fastcgi_pass 10.0.0.10:9000;
                fastcgi_param MOD_X_ACCEL_REDIRECT_ENABLED on;

                # Or use unix-socket with 'fastcgi_pass unix:/var/run/php5-fpm.sock;'
        }

        #location ~ ^/usr/home/don_web/public/owncloud.ggimissions.com/oc6rc3/data {
        #       internal;
        #       root /;
        #}

       location ^~ /data {
                internal;
                # Set 'alias' if not using the default 'datadirectory'
                alias /usr/home/don_web/public/owncloud.ggimissions.com/data;
       }

     location ~ ^/tmp/oc-noclean/.+$ {
               internal;
               root /;
        }

        # Optional: set long EXPIRES header on static assets
        location ~* ^.+\.(jpg|jpeg|gif|bmp|ico|png|css|js|swf)$ {
                expires 30d;
                # Optional: Don't log access to assets
        }
}