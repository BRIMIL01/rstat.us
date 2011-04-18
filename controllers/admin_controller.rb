class Rstatus
  before '/admin/*' do
    redirect "/" and return unless logged_in? && current_user.admin?
  end
  
  get "/admin" do
    @user_count = User.count
    @users_new_24hours = User.count(["created_at > #{24.hours.ago}"])
    @update_count = Update.count
    @updates_24hours = Update.count(["created_at > #{24.hours.ago}"])
    haml :"index"
  end

  get '/admin/search/:username' do
    @users = User.where(:username => /#{params[:username]}/i)
    if @users.count == 1
      @user = @users.first
      if request.xhr? 
        haml :"_user_profile", :layout => false
      else
        haml :"_user_profile"
      end
    else
      if request.xhr? 
        haml :"_user_list", :layout => false
      else
        haml :"_user_list"
      end
    end
  end

  get '/admin/user/:username' do
    @user = User.first(:username => params[:username])
    if request.xhr? 
      haml :"_user_profile", :layout => false
    else
      haml :"_user_profile"
    end
  end
  
  put '/admin/users/:username' do
    @user = User.first(:username => params[:username])
    if @user.edit_user_profile(params)
      if request.xhr? 
        "Profile saved!"
      else
        flash[:notice] = "Profile saved!"
      end
    else
      if request.xhr? 
        "Profile could not be saved!"
      else
        flash[:notice] = "Profile could not be saved!"
      end
    end
  end
  
  delete '/admin/users/:username' do
    @user = User.first(:username => params[:username])
    @user.destroy
  end
end