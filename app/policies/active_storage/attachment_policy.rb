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
    elsif record.is_a? Pledge
      return record.donor == user
    end
  end
end