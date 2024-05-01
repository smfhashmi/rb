json.extract! comment, :id, :title, :body, :created_at, :updated_at
json.url comment_url(comment, format: :json)
