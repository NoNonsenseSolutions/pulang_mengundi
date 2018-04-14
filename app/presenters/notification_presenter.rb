class NotificationPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Context
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def category
    if user.nil?
      :no_user
    elsif user.pledges.waiting_for_transfer.present?
      :pending_donor_transfer
    elsif user.expired_request_pledges.present?
      :can_be_expired
    elsif user.donor_transferred_request_pledges.present?
      :pending_received_confirmation
    elsif user.request && !user&.request&.completed? && user.profile_incomplete?
      :complete_profile_suggestion
    end
  end

  def text
    case category
    when :pending_donor_transfer
      "Transferred the money for your pledge?"
    when :can_be_expired
      "You've been waiting for a transfer for more than 2 hours."
    when :pending_received_confirmation
      "A donor has transferred funds"
    when :complete_profile_suggestion
      "Complete your profile to get a better chance to be sponsored"
    else
      ""
    end
  end

  def button
    case category
    when :pending_donor_transfer
      link_to pledge_path(user.pledges.waiting_for_transfer.first) do
        content_tag :button, class: 'btn btn-default btn-sm ml-3' do
          'Upload Receipt'
        end
      end
    when :can_be_expired
      link_to manage_pledge_path(user.expired_request_pledges.first) do
        content_tag :button, class: 'btn btn-default btn-sm ml-3' do
          'Expire or confirm pledge'
        end
      end
    when :pending_received_confirmation
      link_to manage_pledge_path(user.donor_transferred_request_pledges.first) do
        content_tag :button, class: 'btn btn-default btn-sm ml-3' do
          'Manage Pledge'
        end
      end
    when :complete_profile_suggestion
      link_to(edit_profiles_path) do
        content_tag(:button, class: 'btn btn-default btn-sm ml-3') do
          'Complete my Profile'
        end
      end
    else
      nil
    end
  end

  def container_class
    case category
    when :pending_donor_transfer, :pending_received_confirmation
      "alert alert-info"
    when :can_be_expired, :complete_profile_suggestion
      "alert alert-warning"
    else
      "hidden"
    end
  end
end