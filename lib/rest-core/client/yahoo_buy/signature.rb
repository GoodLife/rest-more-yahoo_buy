
require 'rest-core/middleware'
require 'openssl'

class RestCore::YahooBuy::Signature
  def self.members; [:secret]; end
  include RestCore::Middleware

  def call env, &k
    sig = OpenSSL::HMAC.hexdigest('sha1', secret(env), percent_encode(env[REQUEST_QUERY]))

    # Move query parameters into path variable, to stop reordering
    env[REQUEST_PATH] = request_uri(env)
    # Add signature to the end of request
    env[REQUEST_QUERY] = {'signature'=>sig}

    app.call(env, &k)
  end
end
