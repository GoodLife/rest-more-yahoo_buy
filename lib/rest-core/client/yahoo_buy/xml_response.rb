
require 'rest-core/middleware'
require 'crack/xml'
require 'crack/util'

class RestCore::YahooBuy::XmlResponse
  include RestCore::Middleware

  XML_RESPONSE_HEADER = {'Accept' => 'application/xml'}.freeze

  def call env, &k
    return app.call(env, &k) if env[DRY]

    app.call(env.merge(REQUEST_HEADERS =>
      XML_RESPONSE_HEADER.merge(env[REQUEST_HEADERS]||{}))){ |response|
        yield(process(response))
      }
  end

  def process response
    response.merge(RESPONSE_BODY =>
      Crack::XML.parse(response[RESPONSE_BODY]))
  rescue => error
    fail(response, error)
  end
end
