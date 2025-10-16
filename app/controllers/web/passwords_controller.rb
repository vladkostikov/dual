class Web::PasswordsController < Web::ApplicationController
  def new
    @form = PasswordResetForm.new
  end

  def create
    @form = PasswordResetForm.new(password_reset_params)
    @form.deliver_reset_password_instructions if @form.user.present?

    redirect_to(new_password_path, notice: 'If your email exists, you will receive a password reset link.')
  end

  def edit
    @form = PasswordUpdateForm.new(token: params[:token])
  end

  def update
    @form = PasswordUpdateForm.new(password_update_params)

    if @form.save
      redirect_to(session_path, notice: 'Password has been successfully updated. Please log in.')
    else
      render(:edit)
    end
  end

  private

  def password_reset_params
    params.require(:password_reset_form).permit(:email)
  end

  def password_update_params
    params.require(:password_update_form).permit(:token, :password, :password_confirmation)
  end
end
