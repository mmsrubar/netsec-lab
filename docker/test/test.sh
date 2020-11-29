#!/usr/bin/env bash

PREFIX=192.168
SERVERS=100

VLAN100=(1 2 3)         # servers

function print_header()
{
  echo
  echo $1
  echo "=========================================================="
}

function test_forward_mapping()
{
  echo -n "$1 -> $2"
  if [[ `dig +short $1 @$3` == "$2" ]];
  then
    echo -e "\tOK"
  else
    echo -e "\tFAIL"
  fi
}

function test_reverse_mapping()
{
  echo -n "$1 -> $2"
  if [[ `dig +short -x $1 @$3` == "$2" ]];
  then
    echo -e "\tOK"
  else
    echo -e "\tFAIL"
  fi
}

function test_ping()
{
  echo -n "ping $1"
  if ping -c1 $1 > /dev/null;
  then
    echo -e "\tOK"
  else
    echo -e "\tFAIL"
  fi
}

function test_icmp()
{
  print_header "Ping all systems:"

  for i in ${VLAN100[@]};
  do
    test_ping "$PREFIX.$SERVERS.$i"
  done
}

function test_dns()
{
  print_header "Test master for zone corp.sruby.com"
  DNS=192.168.100.1
  test_forward_mapping ns1.corp.sruby.com "192.168.100.1" $DNS
  test_forward_mapping ns2.corp.sruby.com "192.168.100.2" $DNS
  test_forward_mapping dhcp.corp.sruby.com "192.168.100.3" $DNS

  test_reverse_mapping  "192.168.100.1" ns1.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.2" ns2.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.3" dhcp.corp.sruby.com. $DNS

  print_header "Test slave for zone corp.sruby.com"
  DNS=192.168.100.2
  test_forward_mapping ns1.corp.sruby.com "192.168.100.1" $DNS
  test_forward_mapping ns2.corp.sruby.com "192.168.100.2" $DNS
  test_forward_mapping dhcp.corp.sruby.com "192.168.100.3" $DNS

  test_reverse_mapping  "192.168.100.1" ns1.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.2" ns2.corp.sruby.com. $DNS
  test_reverse_mapping  "192.168.100.3" dhcp.corp.sruby.com. $DNS
}

test_icmp
test_dns
