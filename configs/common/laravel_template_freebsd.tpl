###############################################################
# Laravel Nginx configuration file autogenerated by Conductor #
# https://github.com/bobsta63/conductor                       #
###############################################################

server {

    listen          80;

    #listen          443;
    #ssl on;
    #ssl_certificate /var/conductor/certificates/@@APPNAME@@/www.yourdomain.com.bundle.crt;
    #ssl_certificate_key /var/conductor/certificates/@@APPNAME@@/www.yourdomain.com.key;
    ##ssl_client_certificate /var/conductor/certificates/AlphaSSL_Root.pem;
    ##ssl_protocols  SSLv3 TLSv1 TLSv1.2;
    ##ssl_ciphers AES:HIGH:!ADH:!MD5;
    ##ssl_prefer_server_ciphers   on;

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

    # Protect against Conductor Application configuration file(s).
    include /etc/conductor/configs/common/protect.conf;

    # Set some sensible defaults for image files etc.
    location ~* \.(png|jpg|jpeg|gif|js|css|ico)$ {
        expires 30d;
        log_not_found off;
    }

    location / {
        fastcgi_param   APP_ENV     @@ENVIROMENT@@;
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Laravel framework specific configuration
    include /etc/conductor/configs/common/laravel4_freebsd.tpl;
    
}