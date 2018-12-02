namespace :all do
  desc 'Loads all Triple Triad data'
  task load: :environment do
    puts 'Loading all Triple Triad data'
    Rake::Task['card_types:create'].invoke
    Rake::Task['cards:create'].invoke
    Rake::Task['npcs:create'].invoke
    Rake::Task['card_images:download'].invoke
  end
end
