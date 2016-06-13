#!/usr/bin/env bash

# Add macro to libreoffice
# This macro is executed "on document title change" and sends through
# the bus the current file path

GIMP_SKEL_FOLDER="/etc/skel/.gimp-2.8"
USER_CONFIG_FOLDER="/home/user/.config"
GIMP_USER_CONFIG_FOLDER="/home/user/.gimp-2.8"

if [ ! -f "$USER_CONFIG_FOLDER"/open365_gimp_migrated_13_Jun_2016 ]
then
    touch "$USER_CONFIG_FOLDER"/open365_gimp_migrated_13_Jun_2016
    rm -rf  "$GIMP_USER_CONFIG_FOLDER"
    cp -r "$GIMP_SKEL_FOLDER" "$GIMP_USER_CONFIG_FOLDER"
    chown -R user "$GIMP_USER_CONFIG_FOLDER"
else
    echo "Gimp default settings already set!"
fi
