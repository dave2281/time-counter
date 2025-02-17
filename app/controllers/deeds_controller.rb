class DeedsController < ApplicationController
  before_action :set_deed, only: %i[ show edit update destroy ]

  # GET /deeds or /deeds.json
  def index
    @deeds = Deed.all
  end

  # GET /deeds/1 or /deeds/1.json
  def show
  end

  # GET /deeds/new
  def new
    @deed = Deed.new
  end

  # GET /deeds/1/edit
  def edit
  end

  # POST /deeds or /deeds.json
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

  # PATCH/PUT /deeds/1 or /deeds/1.json
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

  # DELETE /deeds/1 or /deeds/1.json
  def destroy
    @deed.destroy!

    respond_to do |format|
      format.html { redirect_to deeds_path, status: :see_other, notice: "Deed was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deed
      @deed = Deed.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def deed_params
      params.fetch(:deed, {})
    end
end
