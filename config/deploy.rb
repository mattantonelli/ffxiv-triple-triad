lock "~> 3.16.0"

set :application, 'triad'
set :repo_url,    'https://github.com/mattantonelli/ffxiv-triple-triad'
set :branch,      ENV['BRANCH_NAME'] || 'master'
set :deploy_to,   '/var/rails/triad'
set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '3.1.0'

namespace :deploy do
  desc 'Symlink database configuration and secret key'
  after :updating, :symlink_config do
    on roles(:app) do
      # Application credentials
      execute :ln, '-s', shared_path.join('master.key'), release_path.join('config/master.key')

      # Persisted logs
      execute :ln, '-s', shared_path.join("log/#{fetch(:rails_env)}.log"), release_path.join("log/#{fetch(:rails_env)}.log")

      # Individual card images
      execute :rm, '-rf', release_path.join('public/images/cards/large')
      execute :rm, '-rf', release_path.join('public/images/cards/small')
      execute :ln, '-s', shared_path.join('public/images/cards/large'), release_path.join('public/images/cards/large')
      execute :ln, '-s', shared_path.join('public/images/cards/small'), release_path.join('public/images/cards/small')

      # Instance translation files
      execute :ln, '-s', shared_path.join('locales/instances/de.yml'), release_path.join('config/locales/instances/de.yml')
      execute :ln, '-s', shared_path.join('locales/instances/fr.yml'), release_path.join('config/locales/instances/fr.yml')
      execute :ln, '-s', shared_path.join('locales/instances/ja.yml'), release_path.join('config/locales/instances/ja.yml')
    end
  end

  before :updated, :create_images do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'app:update:bin'
          execute :rake, 'card_images:create'
          execute :ln, '-s', release_path.join('app/assets/images/cards/large.png'),
            release_path.join('public/images/cards/large.png')
          execute :ln, '-s', release_path.join('app/assets/images/cards/small.png'),
            release_path.join('public/images/cards/small.png')
        end
      end
    end
  end

  desc 'Restart application'
  after :publishing, :restart do
    on roles(:app) do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end
