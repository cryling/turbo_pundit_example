class Turbo::UserStreams::ActionBroadcastJob < ApplicationJob
  include TurboUserBroadcastHelper
  discard_on ActiveJob::DeserializationError

  def perform(stream, action:, target:, current_user: nil, **rendering)
    broadcast_action_to stream, action: action, target: target, current_user: current_user, **rendering
  end
end
