class GoogleFilesController < ApplicationController
  before_action :set_course
  before_action :set_google_file, only: %i[ show download edit update destroy ]

  # GET /google_files or /google_files.json
  def index
    @google_files = @course.google_files
  end

  # GET /google_files/1 or /google_files/1.json
  def show
  end

  def download
    send_data @google_file.download, filename: @google_file.meta.name
  end

  # GET /google_files/new
  def new
    @google_file = GoogleFile.new
  end

  # GET /google_files/1/edit
  def edit
  end

  # POST /google_files or /google_files.json
  def create
    @google_file = @course.google_files.new(google_file_params)

    respond_to do |format|
      if @google_file.save
        format.html { redirect_to [ @course, @google_file ], notice: "Google file was successfully created." }
        format.json { render :show, status: :created, location: @google_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @google_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /google_files/1 or /google_files/1.json
  def update
    respond_to do |format|
      if @google_file.update(google_file_params)
        format.html { redirect_to [ @course, @google_file ], notice: "Google file was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @google_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @google_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /google_files/1 or /google_files/1.json
  def destroy
    @google_file.destroy!

    respond_to do |format|
      format.html { redirect_to [ @course, :google_files ], notice: "Google file was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course = Course.find(params.expect(:course_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_google_file
      @google_file = @course.google_files.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def google_file_params
      params.expect(google_file: [ :url, :name, :description ])
    end
end
