#!/bin/bash

function usage {
    echo "Usage: $0 <flags>"
    echo
    echo "          -n nameserver - DNS server to send updates to"
    echo "          -p privkey - Path to private key"
    echo "          -r record - Record to update"
    echo "          -t ttl - Time to live for updated record"
    echo "          -z zone - Zone to update"
    exit 1
}

# Parse arguments
while getopts "n:p:r:t:z:" flag ; do
    case $flag in
	n) nameserver=$OPTARG ;;
	p) priv_key=$OPTARG ;;
	r) record=$OPTARG ;;
	t) ttl=$OPTARG ;;
	z) zone=$OPTARG ;;
	*) usage ;;
    esac
done

if [ -z $nameserver ] ; then
    echo "Nameserver is a required option; exiting."
    echo
    usage
fi

if [ -z $priv_key ] ; then
    echo "Path to private key is a required option; exiting."
    echo
    usage
fi

if [ -z $record ] ; then
    echo "DNS record is a required option; exiting."
    echo
    usage
fi

if [ -z $ttl ] ; then
    ttl=300
fi

if [ -z $zone ] ; then
    echo "DNS zone is is a required option; exiting."
    echo
    usage
fi

# Get external IP from DynDNS; alternative site options include
# <http://api.externalip.net/ip/>:
external_ip=$(curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]\{7,15\}\).*/\1/')

logger $(echo "server $nameserver
zone $zone
update delete $record A
update add $record $ttl A $external_ip
show
send" | nsupdate -k $priv_key -v 2>&1)
