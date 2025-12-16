module SavedPins
  class Create
    def self.call(user:, pin:, collection_id: nil, new_collection_name: nil)
      new(user, pin, collection_id, new_collection_name).call
    end

    def initialize(user, pin, collection_id, new_collection_name)
      @user = user
      @pin = pin
      @collection_id = collection_id
      @new_collection_name = new_collection_name
    end

    def call
      collection = find_or_create_collection
      saved_pin = create_saved_pin(collection)
      notify_pin_owner
      saved_pin
    end

    private

    attr_reader :user, :pin, :collection_id, :new_collection_name

    def find_or_create_collection
      if collection_id.present?
        user.collections.find_by(id: collection_id)
      elsif new_collection_name.present?
        user.collections.create!(name: new_collection_name)
      else
        user.collections.find_or_create_by!(name: "Default")
      end
    end

    def create_saved_pin(collection)
      SavedPin.find_or_create_by!(
        pin_id: pin.id,
        collection_id: collection.id,
        user_id: user.id
      )
    end

    def notify_pin_owner
      return if pin.user == user

      Notification.create!(
        user: pin.user,
        actor: user,
        action: "saved your post",
        notifiable: pin,
        read: false
      )
    end
  end
end
