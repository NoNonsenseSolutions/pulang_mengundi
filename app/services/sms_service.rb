# frozen_string_literal: true

class SmsService
  def initialize
    @client = Aws::SNS::Client.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_ACCESS_KEY_SECRET'])
  end

  def deliver(phone:, message:)
    @client.publish(phone_number: phone, message: message)
  end
end
