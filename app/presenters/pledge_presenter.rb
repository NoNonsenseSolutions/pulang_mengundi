# frozen_string_literal: true

class PledgePresenter < ApplicationPresenter
  class InvalidStatusError < StandardError
  end

  attr_reader :pledge
  def initialize(pledge)
    @pledge = pledge
  end

  def humanize_status_for_donor
    text = case pledge.status
           when 'waiting_for_transfer'
             t('pledge.humanize_status_for_donor.waiting_for_transfer')
           when 'donor_transferred'
             t('pledge.humanize_status_for_donor.donor_transferred')
           when 'requester_received'
             t('pledge.humanize_status_for_donor.requester_received')
           when 'requester_disputed'
             t('pledge.humanize_status_for_donor.requester_disputed')
           when 'expired'
             t('pledge.humanize_status_for_donor.expired')
           else
             raise InvalidStatusError, pledge.status
           end
    text.upcase
  end

  def humanize_status_for_requester
    text = case pledge.status
           when 'waiting_for_transfer'
             t('pledge.humanize_status_for_requester.waiting_for_transfer')
           when 'donor_transferred'
             t('pledge.humanize_status_for_requester.donor_transferred')
           when 'requester_received'
             t('pledge.humanize_status_for_requester.requester_received')
           when 'requester_disputed'
             t('pledge.humanize_status_for_requester.requester_disputed')
           when 'expired'
             t('pledge.humanize_status_for_requester.expired')
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
              'text-danger'
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
