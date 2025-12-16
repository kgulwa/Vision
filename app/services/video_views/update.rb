module VideoViews
  class Update
    def self.call(video_view:, duration_seconds:)
      new(video_view, duration_seconds).call
    end

    def initialize(video_view, duration_seconds)
      @video_view = video_view
      @duration_seconds = duration_seconds
    end

    def call
      video_view.update(
        ended_at: Time.current,
        duration_seconds: duration_seconds
      )
    end

    private

    attr_reader :video_view, :duration_seconds
  end
end
