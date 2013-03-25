A simple script to update an A DNS record on a nameserver that supports RFC 2136.

This was written to be called from cron on a workstation behind a NAT device, with no external interface of its own - hence the use of an API service to get the external IP address.

Pull requests welcome.