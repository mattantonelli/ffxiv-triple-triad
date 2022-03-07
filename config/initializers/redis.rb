class Redis
  def self.current
    # TODO: Decide on one of these
    # Redis::Namespace.new(:triad, redis: Redis.new)
    @current ||= Redis::Namespace.new(:triad, redis: Redis.new)
  end
end
