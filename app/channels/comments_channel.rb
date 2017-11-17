class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "questions/#{data['question_id']}/comments"
  end
end
