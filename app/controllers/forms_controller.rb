class FormsController < ApplicationController
  load_and_authorize_resource find_by: :token

  def index
    @forms = current_user.forms
  end

  def new
    @form = current_user.forms.new
  end

  def edit
    @form = current_user.forms.find_by(token: params[:id])
  end

  def show
    @form = current_user.forms.find_by(token: params[:id])
    @submissions = @form.submissions.undeleted
                                    .order(created_at: :desc)
                                    .page(params[:page])
  end

  def trash
    @form = current_user.forms.find_by(token: params[:id])
    @submissions = @form.submissions.deleted
                                    .order(created_at: :desc)
                                    .page(params[:page])
  end

  def create
    @form = current_user.forms.new(params[:form])
    if @form.save
      redirect_to(@form, notice: "Form was successfully created.")
    else
      render action: :new
    end
  end

  def update
    @form = current_user.forms.find_by(token: params[:id])
    if @form.update_attributes(params[:form])
      redirect_to(@form, notice: "Form was successfully updated.")
    else
      render action: :edit
    end
  end

  def destroy
    @form = current_user.forms.find_by(token: params[:id])
    if @form.destroy
      redirect_to forms_path, notice: "Form was successfully deleted."
    else
      redirect_to @form, alert: "Form could not be deleted."
    end
  end
end
