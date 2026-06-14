# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

Jekyll::Hooks.register :site, :post_read do |site|
  data = site.data['shop_prices']
  next unless data.is_a?(Hash)

  items = data['Items'] || data['items']
  next unless items.is_a?(Array)

  base_uri = URI('https://restoremonarchy.com/browser/search')

  items.each do |item|
    next unless item.is_a?(Hash)

    item_id = item['ID'] || item['id']
    next if item_id.nil? || item_id.to_s.strip.empty?

    params = {
      'query' => item_id.to_s,
      'origin' => 'california-2',
      'category' => 'Item',
      'maxResults' => '1'
    }

    request_uri = base_uri.dup
    request_uri.query = URI.encode_www_form(params)

    begin
      response = Net::HTTP.start(
        request_uri.host,
        request_uri.port,
        use_ssl: request_uri.scheme == 'https',
        open_timeout: 5,
        read_timeout: 10
      ) do |http|
        req = Net::HTTP::Get.new(request_uri)
        req['User-Agent'] = 'Jekyll shop_prices_enricher'
        http.request(req)
      end

      next unless response.is_a?(Net::HTTPSuccess)

      result = JSON.parse(response.body)
      next unless result.is_a?(Array) && !result.empty? && result.first.is_a?(Hash)

      api_item = result.first
      item['iconUrl'] = api_item['iconUrl'] if api_item.key?('iconUrl')
      item['assetType'] = api_item['assetType'] if api_item.key?('assetType')
      item['url'] = api_item['url'] if api_item.key?('url')
    rescue StandardError => e
      Jekyll.logger.warn('shop_prices_enricher:', "Failed item #{item_id}: #{e.message}")
    end
  end
end