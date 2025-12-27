class Pins::ShowPresenter
  def initialize(pin:)
    @pin = pin
  end

  def comments
    @comments ||= @pin.comments
                      .includes(:user, :replies)
                      .select { |comment| visible?(comment) }
  end

  private

  def visible?(comment)
    return false unless comment.user.present?

    parent = comment.parent
    parent.nil? || parent.user.present?
  end
end
