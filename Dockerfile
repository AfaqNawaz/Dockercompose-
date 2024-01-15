# Use Alpine Linux as the base image
FROM alpine:latest
RUN apk update && \
    apk upgrade
# Install necessary dependencies
RUN apk add apache2 apache2-utils php php-apache2 php-mysqli php-curl php-json php-gd php-dom php-xml php-mbstring php-tokenizer php-xmlwriter php-session curl
# Set up Apache and enable necessary modules
RUN mkdir -p /run/apache2 && \
    sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php/' /etc/apache2/httpd.conf && \
    sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/LoadModule negotiation_module/s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/LoadModule deflate_module/s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/LoadModule headers_module/s/^#//g' /etc/apache2/httpd.conf && \
    sed -i '/LoadModule expires_module/s/^#//g' /etc/apache2/httpd.conf && \
    echo "ServerName localhost" >> /etc/apache2/httpd.conf

# Create a directory for WordPress
#RUN mkdir -p /var/www/localhost/htdocs

# Download and install WordPress
RUN curl -o /tmp/wordpress.tar.gz -SL https://wordpress.org/latest.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/localhost/htdocs --strip-components=1 && \
    rm /tmp/wordpress.tar.gz && \
    chown -R apache:apache /var/www/localhost

# Expose port 80 for Apache
EXPOSE 90

# Start Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND"]