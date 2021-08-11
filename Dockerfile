FROM centos:7

RUN yum -y update
RUN yum install wget -y
RUN yum install make -y
RUN yum -y install expat-devel
RUN yum install gcc -y

#códigos fuentes
WORKDIR /opt/apache
RUN wget https://downloads.apache.org/apr/apr-1.7.0.tar.gz
RUN wget https://downloads.apache.org/apr/apr-util-1.6.1.tar.gz
RUN wget https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.gz
RUN wget https://downloads.apache.org/httpd/httpd-2.4.48.tar.gz
#RUN wget http://www.modssl.org/source/mod_ssl-2.8.31-1.3.41.tar.gz
RUN wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz
RUN wget https://www.cpan.org/src/5.0/perl-5.28.0.tar.gz

#Procedemos a descomprimir cada uno de las fuentes
RUN tar -xzvf apr-1.7.0.tar.gz
RUN tar -xzvf apr-util-1.6.1.tar.gz
RUN tar -xzvf pcre-8.45.tar.gz
RUN tar -zxvf openssl-1.1.1k.tar.gz
RUN tar -zxvf perl-5.28.0.tar.gz
RUN tar -xzvf httpd-2.4.48.tar.gz
#RUN tar -xzvf mod_ssl-2.8.31-1.3.41.tar.gz

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
WORKDIR /opt/apache/perl-5.28.0
RUN mkdir -p /etc/httpd-2.4.48/localperl
RUN ./Configure -des -Dprefix=/etc/httpd-2.4.48/localperl && make && make install && /opt/apache/openssl-1.1.1k/config --prefix=/etc/httpd-2.4.48/openssl --openssldir=/etc/httpd-2.4.48/openssl no-ssl2 && make && make install
#apache
WORKDIR /opt/apache/httpd-2.4.48
RUN ./configure --prefix=/etc/httpd-2.4.48 --with-apr=/etc/httpd-2.4.48/apr --with-apr-util=/etc/httpd-2.4.48/apr-util --with-pcre=/etc/httpd-2.4.48/pcre/bin/pcre-config --enable-mods-shared=most --enable-ssl --with-ssl=/etc/httpd-2.4.48/openssl
RUN make
RUN make install

