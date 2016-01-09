# In crontab 
# 0 0 * * * /bin/bash -l /Users/rvanegas/src/dusoleil/script/daily.sh development

# cd into project directory derived from script filename
cd $(dirname $0)/..
# setup rbenv
source /Users/rvanegas/.profile-ruby
rbenv-init
# give rbenv-init a chance to setup
sleep 1
# environment is passed in from cron
script/rails runner -e $1 HitStat.populate_table
