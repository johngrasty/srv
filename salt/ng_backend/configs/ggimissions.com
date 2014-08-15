#     Managed by Salt - 2014-07-21 - 1:01 PM

server {
	listen 			80;
    server_name 	.ggimissions.com;
	return 			301 $scheme://www.ggimissions.com$uri;
}

server {
	listen 			80;
	server_name 	.globalgospel.info;
	return 			301 $scheme://www.ggimissions.com$uri;
}

server {
    listen 			80;
    listen 			443 default ssl;

	ssl_certificate /opt/local/etc/nginx/ssl/ggimissions.crt;
	ssl_certificate_key /opt/local/etc/nginx/ssl/ggimissions.key;
	keepalive_timeout    70;



	server_name 	www.ggimissions.com;

	access_log  	/var/log/nginx/ggimissions-access.log le_json;
	error_log   	/var/log/nginx/ggimissions-error.log warn;

	root /data/www/ggimissions.com;
	index index.php;

	set $skip_cache 0;

	# POST requests and urls with a query string should always go to PHP
	if ($request_method = POST) {
		set $skip_cache 1;
	}
	if ($query_string != "") {
		set $skip_cache 1;
	}

	# Don't cache uris containing the following segments
	if ($request_uri ~* "(/wp-admin/|/xmlrpc.php|/wp-(app|cron|login|register|mail).php|wp-.*.php|/feed/|index.php|wp-comments-popup.php|wp-links-opml.php|wp-locations.php|sitemap(_index)?.xml|[a-z0-9_-]+-sitemap([0-9]+)?.xml)") {
		set $skip_cache 1;
	}

	# Don't use the cache for logged in users or recent commenters
	if ($http_cookie ~* "comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_no_cache|wordpress_logged_in") {
		set $skip_cache 1;
	}

	location / {
		try_files $uri $uri/ /index.php?$args;
	}

	location ~ .php$ {
		try_files $uri /index.php;
		include fastcgi_params;
		fastcgi_pass backend;

	#	fastcgi_cache_bypass $skip_cache;
	#	fastcgi_no_cache $skip_cache;

	#	fastcgi_cache WORDPRESS;
	#	fastcgi_cache_valid  60m;
	}

#		location ~ /purge(/.*) {
#	    fastcgi_cache_purge WORDPRESS "$scheme$request_method$host$1";
#		}

	location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
		access_log off;	log_not_found off; expires max;
	}

	location = /robots.txt { access_log off; log_not_found off; }
	location ~ /\. { deny  all; access_log off; log_not_found off; }
}
