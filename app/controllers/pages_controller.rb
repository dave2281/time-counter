class PagesController < ApplicationController
  def main
    if params[:show_finished] == 'true'
      @deeds = Deed.where(finished: true, user_id: Current.user.id)
    else
      @deeds = Deed.where(finished: false, user_id: Current.user.id)
    end
    
    @pagy, @records = pagy(@deeds, items: 5)
  end
end
