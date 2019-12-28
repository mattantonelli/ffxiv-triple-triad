# Explicitly point to the rbenv bundle shim so the cronjob can find it
set :bundle_command, '~/.rbenv/shims/bundle exec'

every '0 3 * * *' do
  rake 'ownership:cache'
end
