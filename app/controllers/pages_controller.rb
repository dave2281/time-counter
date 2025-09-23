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

    if params[:show_running_timers] == 'true'
      running_deeds = Deed.with_running_timers(Current.user.id)
      @deeds = running_deeds
    elsif params[:show_running_timers] == 'false'
      all_deeds = @deeds.to_a
      running_deeds = Deed.with_running_timers(Current.user.id)
      @deeds = all_deeds - running_deeds
    end

    @deeds = Deed.where(user_id: Current.user.id) if params[:show_all_tasks] == 'true'

    @deeds = @deeds.to_a if @deeds.respond_to?(:to_a) && !@deeds.is_a?(Array)
    
    @pagy, @records = pagy_array(@deeds, items: 4)
  end

  def calendar
    @deeds = Deed.where(user_id: Current.user.id)
  end
end
