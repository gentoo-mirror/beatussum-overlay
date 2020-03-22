# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="bb2b6b1aefcd70dfd1892149ac3a215f6c636b07"

inherit readme.gentoo-r1 java-pkg-2

DESCRIPTION="The official server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net"
SRC_URI="https://launcher.mojang.com/v1/objects/${EGIT_COMMIT}/server.jar -> ${P}.jar"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/minecraft
	acct-user/minecraft
	app-misc/dtach
	sys-apps/openrc
	|| (
		>=virtual/jre-1.8
		>=virtual/jdk-1.8
	)
"

RESTRICT="bindist strip test"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_install() {
	java-pkg_newjar "${P}.jar" "${PN}"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" --java_args '${JAVA_OPTS}'

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
