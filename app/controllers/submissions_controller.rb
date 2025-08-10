class SubmissionsController < ApplicationController
  before_action :set_student
  before_action :set_submission, only: %i[ show edit update destroy ]

  # GET /submissions or /submissions.json
  def index
    @submissions = @student.submissions
  end

  # GET /submissions/1 or /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions or /submissions.json
  def create
    @submission = @student.submissions.new(submission_params)

    respond_to do |format|
      if @submission.save
        format.html { redirect_to [ @student, @submission ], notice: "Submission was successfully created." }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to [ @student, @submission ], notice: "Submission was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    @submission.destroy!

    respond_to do |format|
      format.html { redirect_to [ @student, :submissions ], notice: "Submission was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_student
      @student = Student.find(params.expect(:student_id))
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = @student.submissions.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.expect(submission: [ :file ])
    end
end
