
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
      use Signature

      use DefaultSite   , 'http://tw.partner.buy.yahoo.com/api/v1/'

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

      # 取得 Server unix timestamp
      def get_curr_time
        get('getCurrTime')['currentTime'].to_i
      end

      # 取得某型錄下所有的子型錄
      def get_catalog(no, level_no)
        level_no = self.class.get_level_no(level_no)

        response = get('getCatalog', :no => no, :level_no => level_no)

        # Yahoo 的 API 設計很糟糕
        # 當只有一個子類別時，回傳的資料就沒有包在 Array 裡
        if categories = response['categories']['category']
          if categories.is_a? Hash
            [categories]
          else
            categories
          end
        else
          []
        end
      end

      # 取得某型錄下的賣場
      # options:
      #   :page - 頁數(預設第一頁)
      #   :ps - 回傳筆數(5~50，預設50筆)
      def get_gd_info(no, level_no, options={})
        level_no = self.class.get_level_no(level_no)

        options.merge!( :no => no, :level_no => level_no )
        response = get('getGdInfo', options)
        response['gds']['gd']
      end


      # 自製 api
      # 取得某型錄下的所有賣場
      # 需小心不要對頂級型錄使用，不然可能會導致呼叫太多次api
      def get_all_gd_info(no, level_no, safe_mode=true)
        level_no = self.class.get_level_no(level_no)

        if safe_mode && level_no != 4
          raise 'Getting all items under broad catalog'
        end

        default_per_page = 50

        response = get('getGdInfo', :no => no, :level_no => level_no)
        total_item = response['gds']['count'].to_i
        total_page = ( total_item / default_per_page.to_f ).ceil

        container = []
        total_page.times do |i|
          container.concat get_gd_info(no, level_no, :page => (i + 1), :ps => default_per_page)
        end
        container
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
        if level.is_a?(Integer) && level >= 0 && level < CATALOG_LEVEL.size
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
