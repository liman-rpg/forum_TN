json.extract! answer, :id, :body, :created_at, :updated_at, :user_id
json.user do
  json.email answer.user.email
end
json.attachments answer.attachments do |attachment|
  json.id attachment.id
  json.filename attachment.file.identifier
  json.url attachment.file.url
end
json.votes answer.votes do |vote|
  json.id vote.id
  json.score vote.score
end
