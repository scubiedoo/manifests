#!/bin/bash
[ "x$VAGRANT_PROVISION" = "x1" ] || { echo "please run this script from manifests.sh" 1>&2; exit 1; }

build_ok running `basename ${BASH_ARGV[0]}`
eval "`load_configuration`"

function svn_checkout()
{
	local repo="$1"
	local dir="$2"
	if [ "x$http_proxy" != "x" ]; then
		# --------- svn servers snippet ---------
		# [global]
		# http-proxy-exceptions = *.exception.com, www.internal-site.org
		# http-proxy-host = defaultproxy.whatever.com
		# http-proxy-port = 7000
		# http-proxy-username = defaultusername
		# http-proxy-password = defaultpassword
		# http-compression = no
		# http-auth-types = basic;digest;negotiate
		# No http-timeout, so just use the builtin default.
		# No neon-debug-mask, so neon debugging is disabled.
		# ssl-authority-files = /path/to/CAcert.pem;/path/to/CAcert2.pem
		#
		local proxy=`echo $http_proxy|sed 's%http://%%g' |cut -d':' -f 1`
		local port=`echo $http_proxy|sed 's%http://%%g' |cut -d':' -f 2`
		sudo sed -i -e "/^\[global\]\$/,/^#\$/c \[global\]\nhttp-proxy-host = ${proxy}\nhttp-proxy-port = ${port}\n#\n" /etc/subversion/servers
		build_info patched /etc/subversion/servers
	fi
	
	success svn checkout ${repo} ${dir}
}

function create_configfile()
{
	success rm -f Config.in
	for f in ${MENUCONFIG_FILES}; do
		success "echo 'source $f' >> Config.in"
	done
}

function configure()
{
	execute [ -d menuconfig ] || { success svn_checkout ${MENUCONFIG_SVN} menuconfig; }
	trap_push "cd `pwd`"
		success cd menuconfig
		local dir=`pwd`
		success svn update
		success create_configfile
		
		# convenience... always use the $SRCDIR/.config as reference
		success "if [ -r $SRCDIR/.config ]; then cp -f $SRCDIR/.config .config; fi"
		success "if [ ! -r $SRCDIR/.config ]; then rm -f .config; fi"
		
		execute [ -r .config ] || {
			# configfile is set by KBUILD_DEFCONFIG
			success make defconfig
		}
		if [ ${CUBIECONFIG} = 1 ]; then
			success make menuconfig
		fi
		success cp .config $SRCDIR/.config
	trap_pop
}

cd $BUILDDIR
success configure
source $SRCDIR/.config
eval `build_export BUILDDIR "$CONFIG_BUILDDIR"`
readonly BUILDDIR
