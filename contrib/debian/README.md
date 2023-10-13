
Debian
====================
This directory contains files used to package fuertecoind/fuertecoin-qt
for Debian-based Linux systems. If you compile fuertecoind/fuertecoin-qt yourself, there are some useful files here.

## fuertecoin: URI support ##


fuertecoin-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install fuertecoin-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your fuertecoin-qt binary to `/usr/bin`
and the `../../share/pixmaps/fuertecoin128.png` to `/usr/share/pixmaps`

fuertecoin-qt.protocol (KDE)

