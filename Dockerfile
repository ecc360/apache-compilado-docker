FROM centos:7

RUN yum -y update
RUN yum install wget make expat-devel gcc perl -y
RUN yum clean all -y

#códigos fuentes
WORKDIR /opt/apache
RUN wget https://downloads.apache.org/apr/apr-1.7.0.tar.gz
RUN wget https://downloads.apache.org/apr/apr-util-1.6.1.tar.gz
RUN wget https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.gz
RUN wget https://downloads.apache.org/httpd/httpd-2.4.48.tar.gz
RUN wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz


#Procedemos a descomprimir cada uno de las fuentes
RUN tar -xzvf apr-1.7.0.tar.gz
RUN tar -xzvf apr-util-1.6.1.tar.gz
RUN tar -xzvf pcre-8.45.tar.gz
RUN tar -zxvf openssl-1.1.1k.tar.gz
RUN tar -xzvf httpd-2.4.48.tar.gz

#Procedemos a Compilar
#apr
WORKDIR /opt/apache/apr-1.7.0
RUN cp configure libtoolT
RUN mkdir -p /etc/httpd-2.4.48/apr
RUN ./configure --prefix=/etc/httpd-2.4.48/apr
RUN make
RUN make install
#apr-util
WORKDIR /opt/apache/apr-util-1.6.1
RUN mkdir -p /etc/httpd-2.4.48/apr-util
RUN ./configure --prefix=/etc/httpd-2.4.48/apr-util --with-apr=/etc/httpd-2.4.48/apr
RUN make
RUN make install
#pcre
WORKDIR /opt/apache/pcre-8.45
RUN mkdir -p /etc/httpd-2.4.48/pcre
RUN ./configure --prefix=/etc/httpd-2.4.48/pcre --enable-so --disable-cpp 
RUN make
RUN make install
#openssl
WORKDIR /opt/apache/openssl-1.1.1k
RUN mkdir -p /etc/openssl
RUN ./config --prefix=/etc/openssl --openssldir=/etc/openssl
RUN make
RUN make install
RUN ln -s /etc/openssl/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1
RUN ln -s /etc/openssl/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
#apache
WORKDIR /opt/apache/httpd-2.4.48
RUN ./configure --prefix=/etc/httpd-2.4.48 \
    --with-apr=/etc/httpd-2.4.48/apr \
    --with-apr-util=/etc/httpd-2.4.48/apr-util \
    --with-pcre=/etc/httpd-2.4.48/pcre/bin/pcre-config \
    --enable-mods-shared=most \
    --enable-ssl \
    --with-ssl=/etc/openssl \
    --enable-ssl-staticlib-deps \
    --enable-mods-static=ssl
RUN make
RUN make install

#configurancion de apache
COPY httpd.conf /etc/httpd-2.4.48/conf/httpd.conf
COPY server.crt /etc/httpd-2.4.48/conf/server.crt
COPY server.key /etc/httpd-2.4.48/conf/server.key

CMD ["/etc/httpd-2.4.48/bin/apachectl", "-D", "FOREGROUND"]