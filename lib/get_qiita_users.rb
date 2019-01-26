require 'csv'
require 'dotenv/load'
require 'qiita'

PER_PAGE = 100.freeze

client = Qiita::Client.new(access_token: ENV['QIITA_API_TOKEN'])
first_users = client.list_users(per_page: PER_PAGE)
csv_header = first_users.body.first.keys

CSV.open('qiita_users.csv', 'w') do |csv|
  csv << csv_header
  first_users.body.each do |user|
    csv << user.values
  end
  # TODO: DRY にできないか？
  (2..50).each do |n|
    items = client.list_users(page: n, per_page: PER_PAGE)
    items.body.each do |item|
      csv << item.values
    end
  end
end
