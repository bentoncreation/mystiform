class SubmissionsController < ApplicationController
  before_filter :disable_header, only: [:create]
  load_and_authorize_resource :form, find_by: :token, except: :create
  load_and_authorize_resource :submission, through: :form, except: :create
  skip_before_filter :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token, only: :create

  def index
    @form = Form.find_by!(token: params[:form_id])
    @submissions = @form.submissions.undeleted
                                    .order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv do
        send_data SubmissionExporter.new(@submissions).data,
                    type: "text/csv; charset=utf-8; header=present",
                    disposition: "attachment; filename=submissions.csv"
      end
    end
  end

  def create
    @form = Form.find_by!(token: params[:id])
    @submission = @form.submissions.build(data: submission_params,
                                          ip_address: request.remote_ip)
    if @submission.check_and_save
      redirect_to @form.redirect
    else
      render :create
    end
  end

  def delete
    @form = Form.find_by!(token: params[:form_id])
    @submission = @form.submissions.find_by!(id: params[:id])
    if @submission.delete
      flash[:notice] = "Submission sent to trash."
    else
      flash[:alert] = "Submission could not be sent to trash."
    end
    redirect_to @form
  end

  def undelete
    @form = Form.find_by!(token: params[:form_id])
    @submission = @form.submissions.find_by!(id: params[:id])
    if @submission.undelete
      flash[:notice] = "Submission removed from trash."
    else
      flash[:alert] = "Submission could not be removed from trash."
    end
    redirect_to @form
  end

  private

  def submission_params
    params.except(:utf8, :controller, :action, :id)
  end
end
