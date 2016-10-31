#!/usr/bin/env bash
OPTIND=1
set -e

warntime='-24hours -5minutes'
crittime='-30hours'

while getopts "w:c:" opt; do
  case $opt in 
    w)
      warntime=$OPTARG
      ;;
    c)
      crittime=$OPTARG
      ;;
  esac
done


backup=$(envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-list --detail | tail -n 1)
backuptime=$(echo $backup | cut -f2 -d' ')
backupsize=$(echo $backup | cut -f3 -d' ')

now=$(date +%s)
lastbackuptime=$(date -d $backuptime +%s)
criticalbackuptime=$(date -d "$crittime" +%s)
warnbackuptime=$(date -d "$warntime" +%s)

timemessage="$(( (now - lastbackuptime) / 3600 % 60)) hours $(( (now - lastbackuptime) / 60 % 60)) minutes ago."
sizemessage="$(( (backupsize / 1024 / 1024) )) MB"

if [ $criticalbackuptime -ge $lastbackuptime ];
then
  echo "CRITICAL: ($sizemessage) Last backup was $timemessage" 
  exit 2
fi


if [ $warnbackuptime -ge $lastbackuptime ];
then
  echo "WARNING: ($sizemessage) Last backup was $timemessage" 
  exit 1
fi

echo "OK: ($sizemessage) Last backup was $timemessage" 
exit 0
