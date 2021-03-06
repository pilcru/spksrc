SPK_NAME = debian-chroot-powerpcspe
SPK_VERS = 8.4
SPK_REV = 7
SPK_ICON = src/debian.png
DSM_UI_DIR = app

DEPENDS  =
WHEELS = pyextdirect==0.3.1 flask Werkzeug Jinja2 itsdangerous
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = Diaoul
DESCRIPTION = Debian is a free operating system \(OS\) that comes with over 29000 packages, precompiled software bundled up in a nice format for easy installation on your DiskStation. Debian Chroot allows you to benefit from the Debian OS inside your DiskStation, alongside DSM. This package is intended for advanced users only.
DESCRIPTION_FRE = Debian est un système d\\\'exploitation \\\(SE\\\) qui rend disponible plus de 29000 paquets, logiciels précompilés et empaquetés dans un joli format pour rendre son installation facile sur votre DiskStation. Debian Chroot vous permet de bénéficier du SE Debian au sein de votre DiskStation, aux cotés de DSM. Ce paquet est destiné aux utilisateurs avancés uniquement.
RELOAD_UI = yes
DISPLAY_NAME = Debian Chroot for PowerPC-SPE
CHANGELOG = "1. Use debian ports for powerpcspe archs."

HOMEPAGE = http://www.debian.org
LICENSE  = https://www.debian.org/legal/licenses
HELPURL  = https://github.com/SynoCommunity/spksrc/wiki/Debian-Chroot

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = debian-chroot-powerpcspe_extra_install

DEBIAN_ARCH =
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
DEBIAN_ARCH = powerpcspe
endif
ifeq ($(strip $(DEBIAN_ARCH)),)
$(error Arch $(ARCH) not supported)
endif


include ../../mk/spksrc.spk.mk

.PHONY: debian-chroot-powerpcspe_extra_install
debian-chroot-powerpcspe_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
    debootstrap --foreign --arch=$(DEBIAN_ARCH) unstable $(STAGING_DIR)/var/chroottarget "http://ftp.ports.debian.org/debian-ports/"
	install -m 644 src/sources.list $(STAGING_DIR)/var/chroottarget/etc/apt/sources.list.default
	install -m 644 src/policy-rc.d $(STAGING_DIR)/var/chroottarget/usr/sbin/policy-rc.d
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/style.css $(STAGING_DIR)/app/style.css
	install -m 644 src/app/debian-chroot.js $(STAGING_DIR)/app/debian-chroot.js
	install -m 755 src/app/setup.py $(STAGING_DIR)/app/setup.py
	install -m 755 src/app/start.py $(STAGING_DIR)/app/start.py
	install -m 755 src/app/stop.py $(STAGING_DIR)/app/stop.py
	install -m 755 src/app/debian-chroot.cgi.py $(STAGING_DIR)/app/debian-chroot.cgi
	install -m 755 -d $(STAGING_DIR)/app/application
	install -m 644 src/app/application/* $(STAGING_DIR)/app/application/
	install -m 755 -d $(STAGING_DIR)/app/texts
	install -m 755 -d $(STAGING_DIR)/app/texts/enu
	install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/enu/strings
