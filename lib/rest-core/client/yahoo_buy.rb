
require 'rest-core'

module RestCore
  YahooBuy = Builder.client do
    use Timeout       , 10

    use DefaultSite   , 'http://tw.partner.buy.yahoo.com/api/v1/'
    use DefaultHeaders, {'Accept' => 'application/xml'}

    use CommonLogger  , nil
    use Cache         , nil, 600 do
      use ErrorHandler, lambda{ |env|
        RuntimeError.new(env[RESPONSE_BODY]['message'])}
      use ErrorDetectorHttp
    end
  end
end

module RestCore::YahooBuy::Client
  include RestCore
end

class RestCore::YahooBuy
  include RestCore::YahooBuy::Client
end
