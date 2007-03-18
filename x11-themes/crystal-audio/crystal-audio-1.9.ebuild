# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Configurable and full featured theme for FVWM-Crystal, tuned for audio work."
HOMEPAGE="http://crystal-audio.sourceforge.net/"
SRC_URI="mirror://sourceforge/crystal-audio/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND=">=x11-wm/fvwm-2.5.13
	>=x11-themes/fvwm-crystal-3.9.4
	media-sound/aumix
	media-sound/alsaplayer
	sys-devel/bc
	media-sound/qjackctl"

#S=${WORKDIR}/${MY_P}

src_compile() {
	einfo "There is nothing to compile."
}

src_install() {
	cd ${S}
	einstall || die "Installation failed."
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}

