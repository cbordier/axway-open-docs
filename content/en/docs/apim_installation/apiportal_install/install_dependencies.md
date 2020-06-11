{
"title": "Install Apache HTTP server and PHP",
  "linkTitle": "Install Apache HTTP server and PHP",
  "weight": "2",
  "date": "2019-08-09",
  "description": "The API Portal installation script does not install specific dependencies (such as Apache HTTP server and PHP) that are required by API Portal, so you must install these dependencies yourself before you install API Portal."
}

## Install dependencies from RedHat Software Collections (RHSCL)

On a Red Hat Enterprise Linux (RHEL7) installation, the default PHP version available in the official repository is 5.4. However, API Portal only supports PHP 7.1+. To install PHP 7.1+, you can use RedHat Software Collections (RHSCL).

### Enable RedHat Software Collections

Before installing Apache HTTP server and PHP you must first enable RHSCL:

```bash
sudo subscription-manager repos --enable rhel-server-rhscl-7-rpms
sudo yum clean all
```

### Install Apache HTTP Server

1. Install Apache from RHSCL:

   ```bash
   sudo yum install httpd24-httpd httpd24-httpd-tools httpd24-mod_ssl
   ```

2. Make Apache available in any bash session by default:

   ```bash
   echo "source scl_source enable httpd24" | sudo tee -a /etc/profile.d/scl-httpd24.sh
   source /etc/profile.d/scl-httpd24.sh
   sudo ln -s $(which httpd) /usr/bin/httpd
   ```

3. Verify Apache is now available:

   ```bash
   httpd -v
   ```

4. Enable and start Apache service:

   ```bash
   sudo systemctl enable httpd24-httpd
   sudo systemctl start httpd24-httpd
   ```

5. Verify that Apache service is active and running:

   ```bash
   systemctl status httpd24-httpd
   ```

### Install PHP

You must install the latest PHP version provided by the RHSCL.

1. Install all required PHP packages:

   ```bash
   sudo yum install rh-php73 rh-php73-php rh-php73-php-cli rh-php73-php-common rh-php73-php-gd rh-php73-php-json rh-php73-php-intl rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-pdo rh-php73-php-xml rh-php73-php-zip
   ```
2. Enable PHP in bash:

   ```bash
   echo "source scl_source enable rh-php73" | sudo tee -a /etc/profile.d/scl-rh-php73.sh
   source /etc/profile.d/scl-rh-php73.sh
   sudo ln -s $(which php) /usr/bin/php
   ```
3. Verify that PHP is available:

   ```bash
   php -v
   ```
4. Verify that `php7_module` is enabled in Apache:

    ```bash
    httpd -M | grep php7
    ```

5. Restart Apache and verify it is running:

    ```bash
    sudo systemctl restart httpd24-httpd
    systemctl status httpd24-httpd
    ```

### Upgrade PHP

If you already have PHP 5.4 or earlier and API Portal 7.7 or earlier installed, you cannot uninstall the old PHP version due to a dependency in API Portal. Perform the steps in [Install PHP](#install-php) and leave the old PHP version installed. If there is already a symbolic link to the old PHP version, update it with the new location of PHP (for example, using `ln -sf` instead of `ln -s`).

## CentOS - Install dependencies from community repository EPEL with Remi

CentOS also does not offer the latest PHP version in the default repositories. To install the latest PHP, we recommend using the Extra Packages for Enterprise Linux (EPEL) repository.

1. Install and enable EPEL with Remi:

    ```bash
    sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    sudo yum install yum-utils

    sudo yum-config-manager --enable remi-php74
    ```
2. Install Apache HTTP Server and its SSL module:

    ```bash
    sudo yum install httpd mod_ssl
    ```
3. Enable and start the Apache service:

    ```bash
    sudo systemctl enable httpd
    sudo systemctl start httpd
    ```
4. Verify that Apache service is active and running:

   ```bash
   systemctl status httpd
   ```

5. Install PHP:

    ```bash
    sudo yum install php php-cli php-common php-gd php-json php-intl php-mbstring php-mysqlnd php-pdo php-xml php-zip
    ```

6. Verify that PHP was installed:

    ```bash
    php -v
    ```

    If the command fails, restart the bash session.
7. Verify that `php7_module` of Apache is enabled:

    ```bash
    httpd -M | grep php7
    ```
8. Restart Apache and verify that it is working:

    ```bash
    sudo systemctl restart httpd
    systemctl status httpd
    ```
