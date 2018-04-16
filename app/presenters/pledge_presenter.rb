# frozen_string_literal: true

class PledgePresenter
  class InvalidStatusError < StandardError
  end

  attr_reader :pledge
  def initialize(pledge)
    @pledge = pledge
  end

  def humanize_status_for_donor
    text = case pledge.status
           when 'waiting_for_transfer'
             'Pending your transfer'
           when 'donor_transferred'
             'Pending voter confirmation'
           when 'requester_received'
             'Completed'
           when 'requester_disputed'
             'Disputed'
           when 'expired'
             'Expired'
           else
             raise InvalidStatusError, pledge.status
    end
    text.upcase
  end

  def humanize_status_for_requester
    text = case pledge.status
           when 'waiting_for_transfer'
             'Pending donor transfer'
           when 'donor_transferred'
             'Pending your confirmation'
           when 'requester_received'
             'Completed'
           when 'requester_disputed'
             'Disputed'
           when 'expired'
             'Expired'
           else
             raise InvalidStatusError, pledge.status
    end
    text.upcase
  end

  def status_klass
    klass = case pledge.status
            when 'waiting_for_transfer'
              ''
            when 'donor_transferred'
              'text-info'
            when 'requester_received'
              'text-success'
            when 'requester_disputed'
              'text-danger'
            when 'expired'
              'Expired'
            else
              raise InvalidStatusError, pledge.status
    end
    klass
  end

  def donor_name
    @pledge.donor.name
  end

  def donor_facebook_link
    @pledge.donor.facebook_link
  end

  def donor_twitter_link
    @pledge.donor.twitter_link
  end

  def requester_name
    @pledge.request.requester.name
  end

  def request_seat
    pledge.request.to_city
  end

  def request_state
    pledge.request.to_state
  end

  def request_created_at
    pledge.request.created_at.strftime('%d/%m/%Y')
  end

  def created_at
    pledge.created_at.strftime('%d/%m/%Y')
  end

  def request_target_amount
    pledge.request.target_amount
  end

  def amount
    pledge.amount
  end
end
