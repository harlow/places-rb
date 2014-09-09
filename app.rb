require 'active_support/time'
require 'elasticsearch'
require 'faraday'
require 'sinatra/base'
require 'sinatra/json'
require 'yajl'

ES = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])

class App < Sinatra::Base
  helpers Sinatra::JSON

  before do
    cache_control :public, :must_revalidate, max_age: 3600
    etag params[:query].downcase
  end

  get '/places' do
    results = ES.search(index: 'places', search_type: 'count', body: query)

    suggestions = results['suggest']['placesuggest'].first['options'].map do |result|
      time_zone_offset = Time.now.in_time_zone(result['payload']['timeZoneId']).utc_offset
      result['payload'].merge('timeZoneOffset' => time_zone_offset)
    end

    json suggestions
  end

  private

  def query
    {
      from: 0,
      size: 5,
      suggest: {
        placesuggest: {
          text: params[:query],
          completion: {
            field: 'suggest',
            fuzzy: {
              fuzziness: 2
            }
          }
        }
      }
    }
  end
end
