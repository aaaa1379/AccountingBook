json.array!(@doom_expenses) do |doom_expense|
  json.extract! doom_expense, :id, :item, :income, :expense, :total, :note, :delete_at
  json.url doom_expense_url(doom_expense, format: :json)
end
