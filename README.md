# RestMore::YahooBuy

Yahoo!奇摩購物中心 web API client built with [rest-core][].

[rest-core]: https://github.com/cardinalblue/rest-core

### 使用方法 Usage

請先跟 Yahoo!奇摩 申請使用本 API，取得 api key 跟 secret。

安裝 gem 以後，用你的 API key 來建立一個 client：

    c = RestCore::YahooBuy.new(api_key:'你的key',secret:'你的secret')
    c.get_curr_time  # => 1381206695 

client 提供了以下三個對應到官方 API 的方法：

```
get_curr_time()
get_catalog(no, level_no)
get_gd_info(no, level_no, options={})
```

以及便利使用 get_gd_info 的 wrapper 方法：

```
get_all_gd_info(no, level_no, safe_mode=true)
```

各方法的詳細參數請研究 lib/rest-core/client/yahoo_buy.rb 以及參照 Yahoo 提供之說明文件。

### 感謝

Special thanks to [godfat](https://github.com/godfat/) for writing the rest-core gem, and help with development issues while writing this gem.

### License

MIT License