class GoogleFormsController < ApplicationController
  before_action :set_course
  before_action :set_google_form, only: %i[ show edit update destroy ]

  # GET /google_forms or /google_forms.json
  def index
    @google_forms = @course.google_forms
  end

  # GET /google_forms/1 or /google_forms/1.json
  def show
  end

  # GET /google_forms/new
  def new
    @google_form = GoogleForm.new
  end

  # GET /google_forms/1/edit
  def edit
  end

  # POST /google_forms or /google_forms.json
  def create
    @google_form = @course.google_forms.new(google_form_params)

    respond_to do |format|
      if @google_form.save
        format.html { redirect_to [ @course, @google_form ], notice: "Google form was successfully created." }
        format.json { render :show, status: :created, location: @google_form }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @google_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /google_forms/1 or /google_forms/1.json
  def update
    respond_to do |format|
      if @google_form.update(google_form_params)
        format.html { redirect_to [ @course, @google_form ], notice: "Google form was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @google_form }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @google_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /google_forms/1 or /google_forms/1.json
  def destroy
    @google_form.destroy!

    respond_to do |format|
      format.html { redirect_to [ @course, :google_forms ], notice: "Google form was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course = Course.find(params.expect(:course_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_google_form
      @google_form = GoogleForm.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def google_form_params
      params.expect(google_form: [ :url, :name, :description ])
    end
end
