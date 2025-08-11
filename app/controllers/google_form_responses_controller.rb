class GoogleFormResponsesController < ApplicationController
  before_action :set_course, :set_google_form
  before_action :set_google_form_response, only: %i[ show ]

  # GET /google_form_responses or /google_form_responses.json
  def index
    @google_form_responses = @google_form.responses
  end

  # GET /google_form_responses/1 or /google_form_responses/1.json
  def show
  end

  private
    def set_course
      @course = Course.find(params.expect(:course_id))
    end

    def set_google_form
      @google_form = @course.google_forms.find(params.expect(:google_form_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_google_form_response
      @google_form_response = @google_form.responses.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def google_form_response_params
      params.expect(google_form_response: [ :index, :response ])
    end
end
