feed_source="$1"
database="$2"
msql_options="$3"

local_file=$(mktemp -t dusoleil.XXXXXXXXXX) || exit 1
curl -su patsnyd:sjfdKgts4DL 'http://bseolized.com/ipgrabber/getlist.cgi?list=ips&format=csv' | 
  ruby -ne 'print if $_ =~ /^\d+\.\d+\.\d+\.\d+$/' > $local_file || exit 2
query="
  TRUNCATE blockips_updates;
  LOAD DATA CONCURRENT LOCAL INFILE '$local_file' INTO TABLE blockips_updates (ip) SET source = '$feed_source';
  "
echo $query | mysql --local-infile $msql_options $database
rm $local_file
