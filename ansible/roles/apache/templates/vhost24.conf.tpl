php_value auto_prepend_file /vagrant/www/fixdocroot.php

<VirtualHost *:80>
    ServerName dev.vg
    ServerAlias *.vg
    UseCanonicalName Off

    VirtualDocumentRoot "/vagrant/www/%-2+/public_html"

    <Directory /vagrant/www>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>