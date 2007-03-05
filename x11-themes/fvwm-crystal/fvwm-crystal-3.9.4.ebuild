# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-crystal/fvwm-crystal-3.0.4.ebuild,v 1.6 2007/02/04 19:20:09 beandog Exp $

DESCRIPTION="Configurable and full featured theme for FVWM, with lots of transparency. This version add a freedesktop compatible menu"
HOMEPAGE="http://fvwm-crystal.sourceforge.net/"
SRC_URI="mirror://sourceforge/crystal-audio/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND=">=x11-wm/fvwm-2.5.13
	media-gfx/imagemagick
	x11-misc/trayer
	|| ( >=x11-misc/habak-0.2.4.1 x11-misc/hsetroot )"

src_compile() {
	einfo "There is nothing to compile."
}

src_install() {
	einstall || die "einstall failed"

	dodoc AUTHORS COPYING README INSTALL NEWS ChangeLog doc/*
	cp -r addons ${D}/usr/share/doc/${PF}/

	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/fvwm-crystal

	insinto /usr/share/xsessions
	doins addons/fvwm-crystal.desktop
}

pkg_postinst() {
	einfo
	einfo "After installation, execute following commands:"
	einfo " $ cp -r /usr/share/doc/${PF}/addons/Xresources ~/.Xresources"
	einfo " $ cp -r /usr/share/doc/${PF}/addons/Xsession ~/.xinitrc"
	einfo
	einfo "Many applications can extend functionality of fvwm-crystal."
	einfo "They are listed in /usr/share/doc/${PF}/INSTALL.gz."
	einfo
}

