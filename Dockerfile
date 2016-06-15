FROM    docker-registry.eyeosbcn.com/open365-base-with-dependencies

COPY    patches /opt/patches
RUN     set -x ; \
        export DEBIAN_FRONTEND=noninteractive ; \
        apt-add-repository -y ppa:otto-kesselgulasch/gimp-edge && \
        apt-get update && \
        apt-get install --no-install-recommends -y build-essential intltool autoconf pkg-config unzip curl \
        libbabl-dev libgegl-dev libjson-glib-dev libatk1.0-dev libgtk2.0-dev libgtk2.0-bin libgexiv2-dev \
        libtiff5-dev libzzip-dev libbz2-dev liblcms2-dev libpython-dev python-gtk2-dev xsltproc && \
        \
        curl --location --remote-name https://download.gimp.org/mirror/pub/gimp/v2.9/gimp-2.9.2.tar.bz2 && \
        tar xvf gimp-2.9.2.tar.bz2 && rm gimp-2.9.2.tar.bz2 && cd gimp-2.9.2 && \
        patch -p1 < /opt/patches/remove-old-GEGL-multiline-prop.patch && \
        patch -p1 < /opt/patches/mark-version-as-stable.patch && \
        cp data/images/gimp-devel-logo.png data/images/gimp-logo.png && \
        ./configure --prefix=/opt/gimp && make -j4 && make install && \
        apt-get clean && \
        apt-get -y autoremove \
            curl \
            g++ \
            gcc \
            netcat \
            netcat-openbsd \
            netcat-traditional \
            ngrep \
            strace \
            wget \
            && \
            apt-get clean && \
            rm -rf /car/lib/apt/lists/* \
            && \
        mkdir -p /usr/lib/open365
        

COPY    scripts/* /usr/bin/
COPY    gimp-default-settings /etc/skel/.gimp-2.8

# Install theme
COPY    Breeze-gtk.zip /root/
RUN     mkdir -p /usr/share/themes && cd /usr/share/themes && unzip /root/Breeze-gtk.zip && mv theme/Breeze-gtk ./ && rm -rf theme
COPY    gtk3Settings.ini /etc/gtk-3.0/settings.ini
COPY    run.debug.sh /root/run.debug.sh
COPY    migrations.d /usr/lib/open365/migrations.d
