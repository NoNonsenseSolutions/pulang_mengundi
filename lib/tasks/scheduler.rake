# frozen_string_literal: true

task bus_scheduler_task: :environment do
  Bus.all.each do |row|
    scraped = Mechanize.new.get(row.link)

    seat = scraped.search(".//p[@class='stock in-stock']").children
    image_link = scraped.link_with(text: '').attributes.first[1]

    seat = 'Out of Stock' unless seat.present?

    row.update(seat: seat, image_link: image_link)
  end
end
