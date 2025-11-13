require "csv"

CATS_CSV = CSV.read('./cats.csv', headers: true)
CATS = CATS_CSV.map {|d| [d["id"], d["name"]] }.to_h

def judge_cat(id)
  CATS[id] || "unknown"
end
