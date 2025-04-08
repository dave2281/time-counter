class PagesController < ApplicationController
  def main
    @deeds = Deed.where(user_id: Current.user.id)

    if params[:show_finished] == 'true'
      @deeds = @deeds.where(finished: true)
    elsif params[:show_finished] == 'false'
      @deeds = @deeds.where(finished: false)
    end

    if params[:show_just_created] == 'true'
      @deeds = @deeds.where(finished: false, total_time: nil)
    elsif params[:show_just_created] == 'false'
      @deeds = @deeds.where(finished: false).where.not(total_time: nil)
    end

    @deeds = Deed.where(user_id: Current.user.id) if params[:show_all_tasks] == 'true'


    @pagy, @records = pagy(@deeds, items: 5)
  end

  def calendar
    @deeds = Deed.where(user_id: Current.user.id)
  end
end
