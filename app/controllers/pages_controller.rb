class PagesController < ApplicationController
  def main
    @deeds = Deed.all.where(user_id: Current.user.id)
  end
end
