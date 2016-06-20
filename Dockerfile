FROM    docker-registry.eyeosbcn.com/open365-base-with-dependencies

COPY    patches /opt/patches
RUN     set -x ; \
        export DEBIAN_FRONTEND=noninteractive ; \
        apt-add-repository -y ppa:otto-kesselgulasch/gimp-edge && \
        apt-get update && \
        apt-get install --no-install-recommends -y build-essential intltool autoconf pkg-config unzip curl \
        libgegl-0.3.0 libgexiv2-2 \
        libbabl-dev libgegl-dev libjson-glib-dev libatk1.0-dev libgtk2.0-dev libgtk2.0-bin libgexiv2-dev \
        libtiff5-dev libzzip-dev libbz2-dev liblcms2-dev libpython-dev python-gtk2-dev xsltproc && \
        \
        curl --location --remote-name https://download.gimp.org/mirror/pub/gimp/v2.9/gimp-2.9.2.tar.bz2 && \
        tar xvf gimp-2.9.2.tar.bz2 && rm gimp-2.9.2.tar.bz2 && cd gimp-2.9.2 && \
        patch -p1 < /opt/patches/remove-old-GEGL-multiline-prop.patch && \
        patch -p1 < /opt/patches/mark-version-as-stable.patch && \
        cp data/images/gimp-devel-logo.png data/images/gimp-logo.png && \
        ./configure --prefix=/opt/gimp && make -j4 && make install && \
        cd .. && rm -rf gimp-2.9.2 && \
        apt-get -y autoremove \
            autoconf \
            build-essential \
            curl \
            g++ \
            gcc \
            intltool \
            libatk1.0-dev \
            libbabl-dev \
            libbz2-dev \
            libgegl-dev \
            libgexiv2-dev \
            libgtk2.0-dev \
            libjson-glib-dev \
            liblcms2-dev \
            libpython-dev \
            libtiff5-dev \
            libzzip-dev \
            netcat \
            netcat-openbsd \
            netcat-traditional \
            ngrep \
            pkg-config \
            python-gtk2-dev \
            strace \
            wget \
            xsltproc \
            && \
        apt-get clean && \
        rm -rf \
            /var/lib/apt/lists/* \
            /usr/share/man/* \
            /usr/share/doc/* \
            /tmp/* \
        && \
        mkdir -p /usr/lib/open365
        

COPY    scripts/* /usr/bin/
COPY    gimp-default-settings /etc/skel/.gimp-2.8

COPY    gimp-themes /opt/gimp/share/gimp/2.0/themes
# Install theme
COPY    Breeze-dark-gtk /usr/share/themes/Breeze-dark-gtk
COPY    gtkrc /usr/share/gtk-2.0/gtkrc
COPY    run.debug.sh /root/run.debug.sh
COPY    migrations.d /usr/lib/open365/migrations.d
