# == Schema Information
#
# Table name: disputes
#
#  id         :integer          not null, primary key
#  comment    :text
#  pledge_id  :integer
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Dispute < ApplicationRecord
  belongs_to :pledge
end
