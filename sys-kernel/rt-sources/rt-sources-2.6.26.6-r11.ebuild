# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"

ETYPE="sources"
inherit kernel-2 eutils fetch-tools reiser4-patch patcher
detect_version
#get_realtime_patch_url
K_NOSETEXTRAVERSION="don't_set_it"

FBSPLASH="fbcondecor-0.9.4_for_2.6.26-rt.patch"
RT_PATCH="patch-${KV}.bz2"

RESTRICT="nomirror"
DESCRIPTION="Ingo Molnars realtime patch applied on vanilla"
SRC_URI="${KERNEL_URI}
http://download.tuxfamily.org/proaudio/realtime-patches/${RT_PATCH}
fbcondecor? ( http://proaudio.tuxfamily.org/patches/${FBSPLASH} )"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="fbcondecor"

pkg_setup(){
	einfo "To enable additional patches for $PN use USE-flags"
	einfo
	einfo "fbcondecor - Add support for fbcondecor framebuffer splash"
	sleep 3
}

src_unpack(){
	kernel-2_src_unpack

	epatch "${DISTDIR}/${RT_PATCH}"

	# fix sandbox_problems
	 epatch "${FILESDIR}/build-id-sandbox-violation.patch"

	# Spock's stuff
	 use fbcondecor && patcher "${DISTDIR}/${FBSPLASH}" -a -f
}

K_EXTRAEINFO="This kernel is not supported by Gentoo If you have any issues, try
a matching vanilla-sources ebuild -- if the problem persists there, please file
a bug at http://bugme.osdl.org. If the problem only occurs with rt-sources then
please contact Ingo Molnar on the kernel mailinglist to get your issue resolved.
But first search the mailinglist-archiv if your problem is already
discussed/solved: http://lkml.org/ and
http://www.mail-archive.com/linux-rt-users@vger.kernel.org/ .
Recommended other packages: sys-process/rtirq and sys-apps/das_watchdog"