namespace :ownership do
  desc 'Cache card ownership'
  task cache: :environment do
    active_user_ids = User.active.pluck(:id)
    active_user_count = active_user_ids.size.to_f
    ownership = Card.joins(:users).where('users.id in (?)', active_user_ids).group(:card_id).size
    ownership.each do |card_id, owners|
      percentage = "#{((owners / active_user_count) * 100).floor}%"
      Redis.current.hset(:ownership, card_id, percentage)
    end
  end
end
