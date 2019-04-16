USE_ALERT_PCT=10

# Exclude list of unwanted monitoring, if several partions then use "|" to separate the partitions.
# An example: EXCLUDE_LIST="/dev/sda1|/dev/sda5"
EXCLUDE_LIST=""

function do_mail() {
while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usep  $USE_ALERT_PCT ] ; then
     echo "Running out of disk space: $partition is $usep% used on server $(hostname)." | \
     mail -s "WARNING: $(hostname) running out of disk space: $usep% used" shehbaz.pathan@teradata.com
  fi
done
}

if [ "$EXCLUDE_LIST" != "" ] ; then
  du -sh /opt |sort -rh | head -4 |awk '{print $1 " " $2}' | do_mail
else
  du -sh /opt | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}' | do_mail
fi]