# frozen_string_literal: true

require 'csv'

class ExportRequestsCsv
  include Rails.application.routes.url_helpers
  def initialize(results)
    @results = results
  end

  def generated_file
    CSV.generate do |csv|
      csv << %w[id link name facebook_search twitter_link why_am_i_seeking email]
      @results.each do |request|
        csv << [
          request.id,
          request_url(request, locale: I18n.locale),
          request.requester.name,
          request.requester.facebook_search_link,
          request.requester.twitter_link,
          request.description,
          request.user.email_public ? request.user.email : nil
        ]
      end
    end
  end
end
