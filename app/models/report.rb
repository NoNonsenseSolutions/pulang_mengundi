# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :reporter, class_name: 'User'
  belongs_to :reported, class_name: 'User'

  validates :reporter_id, uniqueness: { scope: :reported_id }
  validates :reason, presence: true
end
