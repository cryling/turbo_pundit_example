module UserBroadcastable
  extend ActiveSupport::Concern

  included do
    def broadcast_to_user(channel:, partial:, action:, target:, locals: nil)
      channel_instances = ActionCable.server.pubsub.send(:redis_connection).pubsub(:channels, "*:#{stream_name_from(channel)}")

      subscriber_gids = channel_instances.map { |instance| Base64.decode64(instance[/^(.*?)(?=:)/]) }
      subscribers = GlobalID::Locator.locate_many subscriber_gids

      subscribers.uniq.each do |recipient|
        broadcast_action_later_to([recipient, channel], action: action, target: target, current_user: recipient, partial: partial, locals: locals)
      end
    end
  end

  private

  def broadcast_action_later_to(*streamables, action:, target: nil, targets: nil, current_user: nil, **rendering)
    Turbo::UserStreams::ActionBroadcastJob.perform_later(stream_name_from(streamables),
                                                         action: action,
                                                         target: target,
                                                         targets: targets,
                                                         current_user: current_user,
                                                         **rendering)
  end
end
