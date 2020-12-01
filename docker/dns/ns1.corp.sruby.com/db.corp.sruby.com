$TTL 3h
$ORIGIN corp.sruby.com.
@ IN SOA ns1 hostmaster (
                2020113000  ; Serial
                3h          ; Refresh after 3 hours
                1h          ; Retry after 1 hour
                1w          ; Expire after 1 week
                1h )        ; Negative caching TTL of 1 hour

;
; Name servers for domain @
;
	IN NS  ns1
	IN NS  ns2

; DNS servers
ns1         IN A     192.168.100.1
ns2         IN A     192.168.100.2
dns-cache   IN A     192.168.100.9

; DHCP servers
dhcp  IN A     192.168.100.10
