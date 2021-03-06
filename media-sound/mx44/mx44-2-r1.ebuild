# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils eutils versionator
RESTRICT="mirror"
MY_PN="${PN/m/M}"
MY_P="${MY_PN}.$(replace_version_separator "0" "-")"

DESCRIPTION="Mx44 is a polyphonic midi realtime software synthesizer"
HOMEPAGE="http://web.comhem.se/luna/"
SRC_URI="http://web.comhem.se/luna/${MY_P}.tar.gz"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
PATCHES=( "${FILESDIR}/${PN}-autotoolize.patch" )

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DOCS=( "${WORKDIR}/${MY_P}/README" )

IUSE=""
DEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
