class GoogleSheetsController < ApplicationController
  before_action :set_course
  before_action :set_google_sheet, only: %i[ show edit update destroy ]

  # GET /google_sheets or /google_sheets.json
  def index
    @google_sheets = @course.google_sheets
  end

  # GET /google_sheets/1 or /google_sheets/1.json
  def show
  end

  # GET /google_sheets/new
  def new
    @google_sheet = GoogleSheet.new
  end

  # GET /google_sheets/1/edit
  def edit
  end

  # POST /google_sheets or /google_sheets.json
  def create
    @google_sheet = @course.google_sheets.new(google_sheet_params)

    respond_to do |format|
      if @google_sheet.save
        format.html { redirect_to [ @course, @google_sheet ], notice: "Google sheet was successfully created." }
        format.json { render :show, status: :created, location: @google_sheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @google_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /google_sheets/1 or /google_sheets/1.json
  def update
    respond_to do |format|
      if @google_sheet.update(google_sheet_params)
        format.html { redirect_to [ @course, @google_sheet ], notice: "Google sheet was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @google_sheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @google_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /google_sheets/1 or /google_sheets/1.json
  def destroy
    @google_sheet.destroy!

    respond_to do |format|
      format.html { redirect_to [ @course, :google_sheets ], notice: "Google sheet was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course = Course.find(params.expect(:course_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_google_sheet
      @google_sheet = @course.google_sheets.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def google_sheet_params
      params.expect(google_sheet: [ :url, :name, :description ])
    end
end
