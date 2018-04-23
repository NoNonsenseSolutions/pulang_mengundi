# frozen_string_literal: true

class SmsServiceJob < ApplicationJob
  queue_as :default

  def perform(phone:, message:)
    SmsService.new.deliver(phone: phone, message: message)
  end
end
