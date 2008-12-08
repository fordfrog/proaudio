# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils multilib linux-info autotools

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="http://jackaudio.org/downloads/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="3dnow altivec alsa caps celt coreaudio cpudetection doc debug ieee1394
jack-tmpfs mmx netjack oss portaudio sse freebob"

RDEPEND="
	>=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	caps? ( sys-libs/libcap )
	celt? ( >=media-libs/celt-0.5.0 )
	portaudio? ( =media-libs/portaudio-18* )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	freebob? ( sys-libs/libfreebob )
	ieee1394? ( media-libs/libffado )
	netjack? ( media-libs/libsamplerate )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if use caps; then
		if kernel_is 2 4 ; then
			einfo "will build jackstart for 2.4 kernel"
		else
			einfo "using compatibility symlink for jackstart"
		fi
	fi
}

src_compile() {
	# building docs isn't configureable anymore, they are build if doxygen is
	# installed
	local myconf="--with-html-dir=/usr/share/doc/${PF}"

	if use jack-tmpfs; then
		myconf="${myconf} --with-default-tmpdir=/dev/shm"
	else
		myconf="${myconf} --with-default-tmpdir=/var/run/jack"
	fi

	if use dbus; then
		myconf="${myconf} --enable-dbus --enable-pkg-config-dbus-service-dir"
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -fno-common
		use altivec && append-flags -force_cpusubtype_ALL \
			-maltivec -mabi=altivec -mhard-float -mpowerpc-gfxopt
	fi

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	# Also, without -O2 it will not compile as well.
	# we test if it is present before enabling the configure flag.
	if use cpudetection ; then
		if (! grep 3dnow /proc/cpuinfo >/dev/null) ; then
			ewarn "Can't build cpudetection (dynsimd) without cpu 3dnow support. see bug #136565."
		elif (! grep sse /proc/cpuinfo >/dev/null) ; then
			ewarn "Can't build cpudetection (dynsimd) without cpu sse support. see bug #136565."
		elif (! grep mmx /proc/cpuinfo >/dev/null) ; then
			ewarn "Can't build cpudetection (dynsimd) without cpu mmx support. see bug #136565."
		else
			einfo "Enabling cpudetection (dynsimd). Adding -mmmx, -msse, -m3dnow and -O2 to CFLAGS."
			myconf="${myconf} --enable-dynsimd"

			filter-flags -O*
			append-flags -mmmx -msse -m3dnow -O2
		fi
	fi

	econf \
		$(use_enable freebob) \
		$(use_enable ieee1394 firewire) \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable caps capabilities) $(use_enable caps stripped-jackd) \
		$(use_enable coreaudio) \
		$(use_enable debug) \
		$(use_enable mmx) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		$(use_enable sse)  \
		$(use_enable 3dnow dynsimd) \
		--disable-dependency-tracking \
		${myconf} || die "configure failed"
	emake || die "compilation failed"

	if use caps && kernel_is 2 4 ; then
		einfo "Building jackstart for 2.4 kernel"
		cd "${S}"/jackd
		emake jackstart || die "jackstart build failed."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	if use caps; then
		if kernel_is 2 4 ; then
			cd "${S}/jackd"
			dobin jackstart
		else
			dosym /usr/bin/jackd /usr/bin/jackstart
		fi
	fi

	if ! use jack-tmpfs; then
		keepdir /var/run/jack
		chmod 4777 ${D}/var/run/jack
	fi

	if use doc; then
		mv ${D}/usr/share/doc/${PF}/reference/html \
		   ${D}/usr/share/doc/${PF}/

		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	else
		rm -rf ${D}/usr/share/doc
	fi

	rm -rf ${D}/usr/share/doc/${PF}/reference
}