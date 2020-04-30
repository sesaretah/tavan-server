class ApplicationController < ActionController::API
    require 'jalali_date'
    before_action :inspect_unicode

    def inspect_unicode
        fix_unicode_values(nil, params)
    end
    
    def fix_unicode_values(parent, hash)
        hash.each {|key, value|
          value.is_a?(Hash) ? fix_unicode_values(key, value) : hash[key] = UnicodeFixer.fix(value)
        }
    end
    
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
