# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  reporter_id :integer
#  reported_id :integer
#  reason      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Report < ApplicationRecord
  belongs_to :reporter, class_name: 'User'
  belongs_to :reported, class_name: 'User'

  validates :reporter_id, uniqueness: { scope: :reported_id }
  validates :reason, presence: true
end
