# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

def enrich_shop_entries(entries, category, base_uri, origin)
  return unless entries.is_a?(Array)

  entries.each do |entry|
    next unless entry.is_a?(Hash)

    entry['iconUrl'] = nil
    entry['assetType'] = nil
    entry['url'] = nil

    entry_id = entry['ID'] || entry['id']
    next if entry_id.nil? || entry_id.to_s.strip.empty?

    params = {
      'query' => entry_id.to_s,
      'origin' => origin,
      'category' => category,
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

      api_entry = result.first
      entry['iconUrl'] = api_entry['iconUrl'] if api_entry.key?('iconUrl')
      entry['assetType'] = api_entry['assetType'] if api_entry.key?('assetType')
      entry['url'] = api_entry['url'] if api_entry.key?('url')
    rescue StandardError => e
      Jekyll.logger.warn('shop_prices_enricher:', "Failed #{category.downcase} #{entry_id}: #{e.message}")
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  data = site.data['shop_prices']
  next unless data.is_a?(Hash)

  items = data['Items'] || data['items']
  vehicles = data['Vehicles'] || data['vehicles']

  base_uri = URI('https://restoremonarchy.com/browser/search')
  origin = site.config.dig('shop_prices_api', 'origin')
  origin = origin.to_s.strip
  origin = 'california-2' if origin.empty?

  enrich_shop_entries(items, 'Item', base_uri, origin)
  enrich_shop_entries(vehicles, 'Vehicle', base_uri, origin)
end