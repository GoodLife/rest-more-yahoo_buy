
require 'rest-core'

module RestCore
  module YahooBuy
    autoload :Signature, 'rest-core/client/yahoo_buy/signature'
    autoload :Timestamp, 'rest-core/client/yahoo_buy/timestamp'
    autoload :XmlResponse, 'rest-core/client/yahoo_buy/xml_response'
    Client = Builder.client(:api_key) do
      use Timeout       , 10

      use DefaultQuery
      use Timestamp
      use Signature, nil

      use DefaultSite   , 'http://tw.partner.buy.yahoo.com/api/v1/'
      use DefaultHeaders, {'Accept' => 'application/xml'}

      use CommonLogger  , nil
      use Cache         , nil, 600 do
        use ErrorHandler, lambda{ |env|
          RuntimeError.new(env[RESPONSE_BODY]['message'])}
        use ErrorDetectorHttp
        use XmlResponse
      end
    end

    class Client
      def default_query
        {:pkey => api_key}
      end

      # 取得某型錄下所有的子型錄
      def get_catalog(no, level_no)
        level_no = self.class.get_level_no(level_no)

        response = get('getCatalog', :no => no, :level_no => level_no)
        response['categories']['category']
      end

      # 取得某型錄下所有的賣場
      # options:
      #   :page - 頁數(預設第一頁)
      #   :ps - 回傳筆數(5~50，預設50筆)
      def get_gd_info(no, level_no, options={})
        level_no = self.class.get_level_no(level_no)

        options.merge!( :no => no, :level_no => level_no )
        response = get('getGdInfo', options)
        response['gds']['gd']
      end

      # catalog level 型錄層級
      # 把 API 中的 level_no 與 url 用到型錄層級名作對應
      CATALOG_LEVEL = ['','z','sub','catid','catitemid'].freeze
      def self.get_level_name(level_number)
        CATALOG_LEVEL[level_number]
      end
      # 依照輸入的 level 回傳 level_no
      # level 可以是 level_no 本身或是 level 的 param 名稱
      def self.get_level_no(level)
        if level.is_a? Integer && level > 0 && level < CATALOG_LEVEL.size
          return level
        end

        # if level is not level_no, lookup the table
        CATALOG_LEVEL.index(level)
      end
    end

    def self.new *args, &block
      Client.new *args, &block
    end
  end
end
