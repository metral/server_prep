#!/bin/bash

copy_ssh_keys="false"
do_upgrade="false"
server=""

while getopts cue: opt; do
  case $opt in
  c)
      copy_ssh_keys="true"
      ;;
  u)
      do_upgrade="true"
      ;;
  e)
      server=$OPTARG
      ;;
  esac
done

shift $((OPTIND - 1))

if [ "$copy_ssh_keys" == "true" ] && [ ${server:+1} ] ; then
    echo "copying ssh keys to '$server'"
    ssh-copy-id $server > /dev/null 2>&1
    ssh-copy-id -i ~/.ssh/id_rsa_argon.pub $server > /dev/null 2>&1
fi

if [ "$do_upgrade" == "true" ] && [ ${server:+1} ] ; then
    echo "upgrading '$server'"
    ssh $server "cd /root/ ; wget metralpolis.com/scripts/upgrade_ubuntu.sh; chmod +x /root/upgrade_ubuntu.sh ; /root/upgrade_ubuntu.sh > /root/upgrade_status.txt 2>&1 &" > /dev/null 2>&1
fi

