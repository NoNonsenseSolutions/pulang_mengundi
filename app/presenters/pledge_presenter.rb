class PledgePresenter
  class InvalidStatusError < StandardError 
  end;

  attr_reader :pledge
  def initialize(pledge)
    @pledge = pledge
  end

  def humanize_status
    text = case pledge.status
    when "waiting_for_transfer"
      "Pending donor transfer"
    when "donor_transferred"
      "Pending voter confirmation"
    when "requester_received"
      "Completed"
    when "requester_disputed"
      "Disputed"
    when "expired"
      "Expired"
    else
      raise InvalidStatusError, pledge.status
    end
    text.upcase
  end

  def status_klass
    klass = case pledge.status
    when "waiting_for_transfer"
      ""
    when "donor_transferred"
      "text-info"
    when "requester_received"
      "text-success"
    when "requester_disputed"
      "Disputed"
    when "expired"
      "Expired"
    else
      raise InvalidStatusError, pledge.status
    end
    klass
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

  def created_at
    pledge.request.created_at.strftime("%d/%m/%Y")
  end

  def amount
    pledge.request.target_amount
  end
end