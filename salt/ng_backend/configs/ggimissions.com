#     Managed by Salt - 2014-07-21 - 1:01 PM


server {
    listen 			80;

	keepalive_timeout    70;

	server_name 	www.ggimissions.com;

	access_log  	/var/log/nginx/ggimissions-access.log le_json;
	error_log   	/var/log/nginx/ggimissions-error.log warn;

	root /data/www/ggimissions.com;
	index index.php;

	set $skip_cache 0;

	location / {
		try_files $uri $uri/ /index.php?$args;
	}

	location ~ .php$ {
		try_files $uri /index.php;
		include fastcgi_params;
		fastcgi_pass php_backend;

	}

	location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
		access_log off;	log_not_found off; expires max;
	}

	location = /robots.txt { access_log off; log_not_found off; }
	location ~ /\. { deny  all; access_log off; log_not_found off; }
}
