Rails.application.config.session_store :redis_store,
                                      servers: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/0",
                                      expire_in: 1.hour