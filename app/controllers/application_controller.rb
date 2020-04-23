class ApplicationController < ActionController::API
    require 'jalali_date'
    
    def is_valid?(obj, action)
        flag = false
        role = obj.user_role(current_user) if current_user
        access = obj.access(role) if role
        flag =  true if access && access.include?(action) 
        return flag
    end
      
    def record_visit
        controller = params[:controller].split('/')[1]
        Visit.create(user_id: current_user.id, visitable_id: params[:id], visitable_type: controller.classify, visitable_action:  params[:action], the_params: params) if controller
    end

    

end
