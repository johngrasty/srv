#server {
#	listen 80;
#        server_name .churchplantuk.com;
#        return 301 $scheme://www.churchplantuk.com$uri;
#}

server {
    listen 80;
        server_name new.churchplantuk.com;
	error_log  /var/log/nginx/new-churchplantuk-error.log;
        access_log /var/log/nginx/new-churchplantuk-access.log;
	root /home/francis_web/public/new.churchplantuk.com/public;

	# Global restrictions configuration file.
	# Designed to be included in any server {} block.</p>
	location = /favicon.ico {
		log_not_found off;
		access_log off;
	}

	location = /robots.txt {
		allow all;
		log_not_found off;
		access_log off;
	}

	# Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
	# Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
	location ~ /\. {
		deny all;
	}

	# Deny access to any files with a .php extension in the uploads directory
	# Works in sub-directory installs and also in multisite network
	# Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
	location ~* /(?:uploads|files)/.*\.php$ {
		deny all;
	}


################# Wordpress config

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
		try_files $uri /index.php =404; 
#		try_files $uri =404;
		include fastcgi_params;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_pass backend;

		fastcgi_cache_bypass $skip_cache;
               fastcgi_no_cache $skip_cache;

		fastcgi_cache WORDPRESS;
		fastcgi_cache_valid  60m;
	}

	location ~ /purge(/.*) {
	    fastcgi_cache_purge WORDPRESS "$scheme$request_method$host$1";
	}	

	location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
		expires max;
	}


	location ^~ /images {
            try_files $uri @s3;
        }

#    location ^~ /wp-content {
#            try_files $uri @s3;
#        }

#    location @s3 {
#            rewrite ^ $scheme://dbgi6clnbgca3.cloudfront.net$request_uri permanent;
#        }
}
