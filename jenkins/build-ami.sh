#!/bin/sh
#
# Build a new set of AMIs for Jenkins using Packer.  This script
# requires packer be installed, along with the packer.json and
# customize-ami.sh scripts in this directory.
#

OPTIND=1
packer_opts=""

while getopts "h?a:l" opt; do
    case "$opt" in
    h|\?)
	echo "usage: build-ami.sh [-a <ami list>]"
	echo "  -a <ami list>     Only build amis in ami list"
	echo "  -l                List ami names available for building"
	exit 1
	;;
    a)
	packer_opts="--only ${OPTARG}"
	;;
    l)
	ami_list=`sed -n -e 's/.*\"name\".*\"\(.*\)\".*/\1/p' packer.json | xargs`
	echo "Available amis: ${ami_list}"
	exit 0
	;;
    esac
done

export BUILD_DATE=`date +%Y%m%d%H%M`

packer build ${packer_opts} packer.json