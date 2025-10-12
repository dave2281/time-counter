require "date"
module ApplicationHelper
  include Pagy::Frontend

  def days_in_month(year, month)
    Date.new(year, month, -1).day
  end

  # Navigation helper methods for minimal navbar
  def nav_active_class(active = false)
    active ? "active" : ""
  end
end
