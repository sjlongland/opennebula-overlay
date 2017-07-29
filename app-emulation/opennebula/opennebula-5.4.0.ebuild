# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="OpenNebula Enterprise Cloud manager"
HOMEPAGE="https://opennebula.org"
SRC_URI="http://downloads.opennebula.org/packages/opennebula-${PV}/opennebula-${PV}.tar.gz"

inherit scons-utils toolchain-funcs user

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql"

DEPEND="dev-lang/ruby
		dev-db/sqlite
		mysql? ( || ( dev-db/mariadb dev-db/mysql ) )
		dev-ruby/sqlite3
		dev-libs/xmlrpc-c[abyss]
		dev-util/scons
		dev-ruby/json
		dev-ruby/sinatra
		dev-ruby/uuidtools
		dev-ruby/curb
		dev-ruby/nokogiri"
RDEPEND="${DEPEND}"

src_prepare() {
	# Call this, or the setup will barf!
	eapply_user

	# Patch the SUNSTONE_MINIFIED_DIRS variable, which is missing a
	# $ sign
	sed -i -e '/^SUNSTONE_MINIFIED_DIRS/ s/="SUNSTONE_LOCATION/="$SUNSTONE_LOCATION/g' \
		"${S}/install.sh"
}

src_configure() {
	MYSCONS=(
		CC="$(tc-getCC)"
	)
	if use mysql
	then
		MYSCONS[1]='mysql=yes'
	fi
}

src_compile() {
	escons "${MYSCONS[@]}"
}

src_install() {
	cd "${S}"
	unset ROOT
	DESTDIR="${D}" ./install.sh -u oneadmin -g oneadmin || die

	# Install sunstone components, because the above script doesn't.
	DESTDIR="${D}" ./install.sh -u oneadmin -g oneadmin -s -p || die

	# These directories should not be installed by us, so remove them
	rm -fr "${D}/var/lock" "${D}/var/run"

	# Init scripts
	for f in "${FILESDIR}"/*.init
	do
		newinitd "${f}" "$( basename "${f}" .init )"
	done
}

pkg_setup() {
    enewgroup oneadmin
    enewuser oneadmin -1 /bin/bash /var/lib/one oneadmin
}
