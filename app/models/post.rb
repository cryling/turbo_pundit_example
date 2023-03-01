class Post < ApplicationRecord
  include TurboUserBroadcastHelper
  include UserBroadcastable

  belongs_to :user

  after_create_commit :broadcast_new_post
  after_update_commit :broadcast_update_post

  def broadcast_new_post
    broadcast_to_user(channel: ["posts"],
                      partial: "posts/post",
                      action: :append,
                      target: "posts",
                      locals: {
                        post: self
                      })
  end

  def broadcast_update_post
    broadcast_to_user(channel: [self],
                      partial: "posts/post",
                      action: :replace,
                      target: "post_#{id}",
                      locals: {
                        post: self
                      })
  end
end
