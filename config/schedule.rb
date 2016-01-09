# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 1.hour do
  runner 'Blockip.poll'
end

# every 1.minute do
#   runner 'Stat.save_from_cache'
# end

every 1.day do
  runner 'HitStat.populate_table'
  runner 'Hit.clear_data'
end

# Learn more: http://github.com/javan/whenever
