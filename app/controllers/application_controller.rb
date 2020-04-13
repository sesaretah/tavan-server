class ApplicationController < ActionController::API
    def record_visit
        controller = params[:controller].split('/')[1]
        Visit.create(user_id: current_user.id, visitable_id: params[:id], visitable_type: controller.classify, visitable_action:  params[:action]) if controller
    end

end
