
require 'rest-core'

module RestCore
  module YahooBuy
    autoload :Signature, 'rest-core/client/yahoo_buy/signature'
    Client = Builder.client(:api_key) do
      use Timeout       , 10

      use Signature, nil

      use DefaultSite   , 'http://tw.partner.buy.yahoo.com/api/v1/'
      use DefaultHeaders, {'Accept' => 'application/xml'}

      use CommonLogger  , nil
      use Cache         , nil, 600 do
        use ErrorHandler, lambda{ |env|
          RuntimeError.new(env[RESPONSE_BODY]['message'])}
        use ErrorDetectorHttp
      end
    end

    def self.new *args, &block
      Client.new *args, &block
    end
  end
end
