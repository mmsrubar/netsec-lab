#!/usr/bin/env bash

set -e

function test_forward_mapping()
{
  if [[ `dig +short $1 @$3` == "$2" ]];
  then
    echo -e "$1 -> $2 \t OK"
  fi
}

function test_reverse_mapping()
{
  if [[ `dig +short -x $1 @$3` == "$2" ]];
  then
    echo -e "$1 -> $2 \t OK"
  fi
}

function test_dns()
{
  echo "Test master for zone corp.sruby.com"
  DNS=192.168.100.1
  test_forward_mapping ns1.corp.sruby.com "192.168.100.1" $DNS
  test_forward_mapping ns2.corp.sruby.com "192.168.100.2" $DNS
  test_forward_mapping dhcp.corp.sruby.com "192.168.100.3" $DNS

  test_reverse_mapping  "192.168.100.1" ns1.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.2" ns2.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.3" dhcp.corp.sruby.com. $DNS

  echo
  echo "Test slave for zone corp.sruby.com"
  DNS=192.168.100.2
  test_forward_mapping ns1.corp.sruby.com "192.168.100.1" $DNS
  test_forward_mapping ns2.corp.sruby.com "192.168.100.2" $DNS
  test_forward_mapping dhcp.corp.sruby.com "192.168.100.3" $DNS

  test_reverse_mapping  "192.168.100.1" ns1.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.2" ns2.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.3" dhcp.corp.sruby.com. $DNS
}

test_dns
