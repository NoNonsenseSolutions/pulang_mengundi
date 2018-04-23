# frozen_string_literal: true

class ActiveStorage::AttachmentPolicy
  attr_reader :user, :document

  def initialize(user, document)
    @user = user
    @document = document
  end

  def destroy?
    record = document.record
    return record.requester == user if record.is_a? Request
    return record.donor == user if record.is_a? Pledge
  end
end
