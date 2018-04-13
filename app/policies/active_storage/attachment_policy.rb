class ActiveStorage::AttachmentPolicy
  attr_reader :user, :document

  def initialize(user, document)
    @user = user
    @document = document
  end

  def destroy?
    record = document.record
    if record.is_a? Request
      return record.requester == user
    end
  end
end