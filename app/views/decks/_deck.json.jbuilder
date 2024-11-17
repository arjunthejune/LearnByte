json.extract! deck, :id, :title, :description, :created_at, :updated_at
json.url deck_url(deck, format: :json)
