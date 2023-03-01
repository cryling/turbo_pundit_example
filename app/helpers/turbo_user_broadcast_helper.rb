module TurboUserBroadcastHelper
  include Turbo::Streams::ActionHelper
  include Turbo::Streams::StreamName

  def broadcast_action_to(*streamables, action:, target: nil, targets: nil, current_user: nil, **rendering)
    broadcast_stream_to(*streamables, content: turbo_stream_action_tag(action, target: target, targets: targets, template:
     rendering.delete(:content) || rendering.delete(:html) || (rendering.any? ? render_format(:html, current_user: current_user, **rendering) : nil)))
  end

  def broadcast_stream_to(*streamables, content:)
    ActionCable.server.broadcast stream_name_from(streamables), content
  end

  private

  def render_format(format, current_user:, **rendering)
    renderer(current_user: current_user).render(formats: [format], **rendering)
  end

  def renderer(current_user:)
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap do |i|
      i.set_user(current_user, scope: :user, store: false, run_callbacks: false)
    end
    return ApplicationController.renderer.new("warden" => proxy)
  end
end
