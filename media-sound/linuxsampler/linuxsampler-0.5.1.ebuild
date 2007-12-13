# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features."
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa arts jack sqlite"

RDEPEND=">=media-libs/liblscp-0.5.5
	>=media-libs/libgig-3.2.1
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	arts? ( || ( kde-base/kdebase kde-base/arts ) )
	sqlite? ( >=dev-db/sqlite-3.3 )"

DEPEND="${RDEPEND}"

pkg_setup() {
	if [ $(gcc-major-version)$(gcc-minor-version) -eq 41 ]; then
		ewarn "${PN} will maybe crash a lot with gcc-4.1."
		ewarn "You better upgrade to 4.2!"
	fi

	if ! use sqlite; then
		ewarn "sqlite useflag not set. Disabling support for instrument-db!"
	fi
}

src_compile() {
	local myconf=""
	use arts && myconf="--with-arts-prefix=/usr/kde/3.5"
	
	# disable nptl bug check for gcc-4.1
	[[ $(gcc-major-version)$(gcc-minor-version) -eq 41 ]] && \
		myconf="--disable-nptl-bug-check"
	
	econf \
		`use_enable alsa alsa-driver` \
		`use_enable arts arts-driver` \
		`use_enable jack jack-driver` \
		`use_enable sqlite instruments-db` \
		${myconf} || die "configure failed"
	
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
}