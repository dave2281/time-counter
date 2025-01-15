class DeedsController < ApplicationController
  before_action :set_deed, only: %i[ show edit update destroy ]

  def index
    @deeds = Deed.all
  end

  def show
  end

  def new
    @deed = Deed.new
  end

  def edit
  end

  def create
    @deed = Deed.new(deed_params)

    respond_to do |format|
      if @deed.save
        format.html { redirect_to @deed, notice: "Deed was successfully created." }
        format.json { render :show, status: :created, location: @deed }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @deed.update(deed_params)
        format.html { redirect_to @deed, notice: "Deed was successfully updated." }
        format.json { render :show, status: :ok, location: @deed }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deed.destroy!

    if @deed.destroy
      format.html { redirect_to deeds_path, notice: "Deed was successfully destroyed." }
    else
      format.html { redirect_to deeds_path, alert: "Deed could not be destroyed." }
    end

  end

  private
    def set_deed
      @deed = Deed.find(params.expect(:id))
    end

    def deed_params
      params.require(:deed).permit(:title, :description, :time)
    end    
end
