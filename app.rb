require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  @api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  @raw_response = HTTP.get(@api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)
  @keys = @parsed_data.keys
  @currencies = @parsed_data.fetch("currencies")
  @get_currency_array = @currencies.keys
  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  @api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  @raw_response = HTTP.get(@api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)
  @currencies = @parsed_data.fetch("currencies")
  @get_currency_array = @currencies.keys
  erb(:currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  @api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  @raw_response = HTTP.get(@api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)
  @convert_keys = @parsed_data.keys
  @amount = @parsed_data.fetch("query").fetch("amount")
  @conversion = @parsed_data.fetch("result")

  erb(:convert)
end
