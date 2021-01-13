###############################################################
# Laravel Nginx configuration file autogenerated by Conductor #
# https://github.com/allebb/conductor                         #
###############################################################


# Enable this configuration block if you wish to configure SSL and force
# all HTTP traffic to the HTTPS configuraion.
##server {
##       listen         80;
##       server_name    @@DOMAIN@@;
##       return         301 https://$server_name$request_uri;
##}

# If you wish to redirect HTTPS traffic too, such as from a www. address to a tld, you can use this:
#server {
#        listen          443 ssl;
#        ssl_certificate /etc/letsencrypt/live/@@DOMAIN_FIRST@@/fullchain.pem;
#        ssl_certificate_key /etc/letsencrypt/live/@@DOMAIN_FIRST@@/privkey.pem;
#        ssl_trusted_certificate /etc/letsencrypt/live/@@DOMAIN_FIRST@@/chain.pem;
#        include /etc/nginx/snippets/ssl-params.conf;
#        server_name   www.{yourdomain};
#        return        301 https://{yourdomain}$request_uri;
#}

server {

    # Comment this line if you wish to are switching to HTTPS
    listen          80;
    
    # Uncomment to enable default LetsEncrypt Certificates.
    #listen          443 ssl;
    #ssl_certificate /etc/letsencrypt/live/@@DOMAIN_FIRST@@/fullchain.pem;
    #ssl_certificate_key /etc/letsencrypt/live/@@DOMAIN_FIRST@@/privkey.pem;
    #ssl_trusted_certificate /etc/letsencrypt/live/@@DOMAIN_FIRST@@/chain.pem;
    #include /etc/nginx/snippets/ssl-params.conf;

    server_name     @@DOMAIN@@;
    server_tokens   off;

    # Application path and index file settings.
    root            /var/conductor/applications/@@APPPATH@@;
    index           index.php;

    # Logging settings
    access_log      @@HLOGS@@access.log;
    error_log       @@HLOGS@@error.log;
    rewrite_log     on;

    # Additional per-application optimisations
    charset utf-8;
    client_max_body_size 32m;

    # Enable GZip by default for common files.
    include /etc/conductor/configs/common/gzip.conf;

    # Optional sensible defaults for image files etc.
    # location ~* \.(png|jpg|jpeg|gif|js|css|ico)$ {
    #    expires 30d;
    #    log_not_found off;
    # }

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Laravel framework specific configuration
    if (!-d $request_filename) {
        rewrite ^/(.+)/$ /$1 permanent;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    location ~* \.php$ {
        try_files $uri /index.php =404;
        # If your application requires PHP 7.4 instead, change the UNIX socket to: "unix:/var/run/php/php7.4-fpm.sock;" instead!
        fastcgi_pass                    unix:@@SOCKET@@;
        fastcgi_index                   index.php;
        fastcgi_split_path_info         ^(.+\.php)(.*)$;
        include                         @@FASTCGIPARAMS@@;
        fastcgi_param                   SCRIPT_FILENAME $document_root$fastcgi_script_name;
         # START APPLICTION ENV VARIABLES  
        fastcgi_param   APP_ENV         @@ENVIROMENT@@;
        # END APPLICTION ENV VARIABLES
    }

    location ~ /\.ht {
        deny all;
    }

}