class UsersController < ApplicationController
	before_action :signed_in_to_root, only: [:new, :create]
	before_action :signed_in_user, 	only: [:index, :edit, :update]
	before_action :correct_user,  	only: [:edit, :update]
	before_action :admin_user,			only: :destroy

	def index
		@users = User.paginate(page: params[:page])
	end

	def destroy
		user = User.find(params[:id])
		if user == current_user
			flash[:false] = "You can't destroyed yourself!"
		else
			user.destroy
			flash[:success] = "User destroyed."
			redirect_to users_url
		end
	end

  def show 
  	@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

  def new
		@user = User.new
  end

	def create 
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end

		def signed_in_to_root
			redirect_to(root_path) unless !signed_in?
		end
end

