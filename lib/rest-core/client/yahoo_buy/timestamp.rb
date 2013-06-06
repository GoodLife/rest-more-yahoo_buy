
require 'rest-core/middleware'

class RestCore::YahooBuy::Timestamp
  include RestCore::Middleware

  def call env, &k
    env[REQUEST_QUERY].merge!(string_keys(:ts => Time.now.to_i))
    app.call(env, &k)
  end
end
