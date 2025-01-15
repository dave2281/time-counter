class PagesController < ApplicationController
  def main
    @deeds = Deed.where(user_id: Current.session.id)
  end
end
