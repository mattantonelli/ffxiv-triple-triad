namespace :ownership do
  desc 'Cache card ownership'
  task cache: :environment do
    active_user_ids = User.active.pluck(:id)
    total = active_user_ids.size.to_f
    current = Redis.current.hgetall(:ownership)

    percentages = Card.joins(:users).where('users.id in (?)', active_user_ids).group(:card_id).count
      .each_with_object({}) do |(id, owners), h|
      percentage = ((owners / total) * 100).to_s[0..2].sub(/\.\Z/, '').sub(/0\.0/, '0')
      h[id] = "#{percentage}%"
    end

    updated = percentages.filter_map do |id, percentage|
      id unless percentage == current[id.to_s]
    end

    # Touch cards with updated ownership to expire cached data
    Card.where(id: updated).update_all(updated_at: Time.now)

    Redis.current.hmset(:ownership, percentages.to_a.flatten)
  end
end
