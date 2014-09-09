require 'csv'
require 'elasticsearch'
require 'rubygems'

ES = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])

CSV.foreach("maponics_sample_neighborhoods_wkt.txt", col_sep: '|', headers: :first_row) do |row|
  next if row[4] != 'M'

  # 0: 191979
  # 1: Raynor
  # 2: Sunnyvale
  # 3: 77000
  # 4: M
  # 5: SUNNYVALE
  # 6: San Francisco Bay Area, CA
  # 7: USA
  # 8: CA
  # 9: 06
  # 10: Santa Clara
  # 11: 06085
  # 12: San Jose
  # 13: 92830
  # 14: San Jose-Sunnyvale-Santa Clara, CA
  # 15: 41940
  # 16: Metro
  # 17: 37.345405
  # 18: -122.004985
  # 19: 2
  # 20: 20000000
  # 21: 1.14.1

  # "Hollywood, Los Angeles, CA, United States"
  # "Hollywood, FL, United States"
  # "Hollywood Boulevard, Los Angeles, CA, United States"

  puts "#{row[1]}, #{row[2]}, #{row[8]}, United States"
end
