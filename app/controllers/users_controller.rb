class UsersController < ApplicationController
 rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_recor_error

    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else 
            render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
          render json: user
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
      end

    private

    def render_invalid_recor_error(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
    def user_params
        params.permit(:username, :password, :password_confirmation, :bio, :image_url)
    end
end


