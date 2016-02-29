redis = Redis.new(
  host: ENV['REDIS_HOST'],
  port: ENV['REDIS_PORT']
)

Redis.current = case Rails.env.to_sym
                  when :development
                    Redis::Namespace.new(:qqd, redis: redis)
                  when :test
                    Redis::Namespace.new(:qqt, redis: redis)
                  else
                    Redis::Namespace.new(:qqp, redis: redis)
                end
