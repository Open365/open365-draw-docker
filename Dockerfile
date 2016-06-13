FROM    docker-registry.eyeosbcn.com/open365-base-with-dependencies

RUN     set -x ; \
        export DEBIAN_FRONTEND=noninteractive ; \
        apt-get update && apt-get install --no-install-recommends -y unzip curl gimp=2.8.14-1ubuntu2 && \
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
