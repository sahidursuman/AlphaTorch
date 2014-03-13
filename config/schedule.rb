# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "#{path}/log/cron_log.log"

every '00 00 4 * *' do
  runner "Workorder.generate_all_invoices", environment: :development
  #runner "Workorder.generate_all_invoices", environment: :production

  runner "Workorder.create_all_events",   environment: :development
  #runner "Workorder.generate_all_events",   environment: :production
end