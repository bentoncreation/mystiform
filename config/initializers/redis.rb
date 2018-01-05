Resque.redis = Redis.new(Rails.application.secrets.redis.symbolize_keys)
Resque.redis.namespace = "mystiform:resque"
