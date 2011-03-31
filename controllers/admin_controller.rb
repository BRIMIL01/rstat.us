class Rstatus
  get "/admin" do
    redirect "/" and return unless logged_in? && current_user.admin?
    
  end
  
  get '/admin/users' do
    redirect "/" and return unless logged_in? && current_user.admin?
    
  end

  get '/admin/users/:username' do
    redirect "/" and return unless logged_in? && current_user.admin?
    
  end
  
  get '/admin/users/:username/edit' do
    redirect "/" and return unless logged_in? && current_user.admin?
    
  end
end