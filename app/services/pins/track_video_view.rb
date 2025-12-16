module Pins
  class TrackVideoView
    def self.call(user:, pin:)
      return unless pin.file&.video?

      VideoView.create!(
        user_uid: user.uid,
        pin_id: pin.id,
        started_at: Time.current
      )
    end
  end
end
