# frozen_string_literal: true

class BusesController < ApplicationController
  def index
    @buses = Bus.all
    @all_cities = @buses.pluck('depart_city').uniq
    @city = params.dig(:search, :city)

    @buses = @buses.where('depart_city = ? OR arrive_city = ?', @city, @city) if @city.present?

    @departing_date = params.dig(:search, :departing_date)

    @buses = @buses.where('date = ?', @departing_date) if @departing_date.present?
  end
end
