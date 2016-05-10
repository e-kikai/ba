# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
every 1.day, at: '2:00 am' do
  if ENV['RAILS_ENV'] == "development"
    command "sudo systemctl stop unicorn_ba;sudo systemctl start unicorn_ba"
  else
    command "sudo /etc/init.d/unicorn_ba restart"
  end
end
