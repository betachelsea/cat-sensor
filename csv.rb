require "csv"

FILENAME = "#{ENV['PRJ_ROOT']}/latest.csv"
HEADERS = %w(timestamp id)

def append_with_limit(row, limit: 1000)
  rows = []

  if File.exist?(FILENAME)
    rows = CSV.read(FILENAME, headers: true)
  else
    rows = CSV::Table.new([], headers: HEADERS)
  end

  rows << row
  rows = rows.to_a.last(limit)

  CSV.open(FILENAME, "w", headers: HEADERS) do |csv|
    rows.each { |r| csv << r }
  end
end
