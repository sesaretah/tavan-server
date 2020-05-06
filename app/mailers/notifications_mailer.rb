class NotificationsMailer < ActionMailer::Base
    include ActionView::Helpers::TextHelper
    def notify_email(user_id, notify_type, notifier, notify_text, custom_text, auxiliary_custom_text=nil)
        @user = User.find(user_id)
        @second_pargraph = ""
        @title = "#{t(:notification)}"
        case notify_type
        when  'Work'
            @body = "#{t(:work_notification)} #{t(:via)} #{notifier} #{t(:inside)} #{notify_text}"
            @second_pargraph =  "#{custom_text}"
            @title = "#{t(:new_work)} #{t(:inside)} #{truncate(notify_text)}"
        when  'Task'
            @body = "#{t(:task_notification)}  #{t(:via)} #{notifier} #{t(:onto)} #{notify_text}" 
        when  'Report'
            @body = "#{t(:report_notification)}  #{t(:via)} #{notifier} #{t(:onto)} #{notify_text}" 
            @second_pargraph =  "#{custom_text}"
            @title = "#{t(:new_report)} #{t(:inside)} #{truncate(notify_text)}"
        when  'Todo'
            @body = "#{t(:todo_notification)}  #{t(:via)} #{notifier} #{t(:onto)} #{notify_text}" 
            @second_pargraph =  "#{custom_text}"
            @title = "#{t(:new_todo)} #{t(:inside)} #{truncate(notify_text)}"
        when  'Comment'
            @body = "#{t(:comment_notification)}  #{t(:via)} #{notifier} #{t(:onto)} #{notify_text}"
            @second_pargraph =  "#{custom_text}"
            @title = "#{t(:new_comment_on)} #{truncate(notify_text)}"
        when  'AddInvolvement'
            @body = "#{custom_text}  #{t(:is_added_to)} #{notify_text} #{t(:via)} #{notifier}" 
            @second_pargraph =  ""
            @title = "#{t(:user)} #{t(:is_added_to)} #{truncate(notify_text)}"
        when  'RemoveInvolvement'
            @body = "#{custom_text}  #{t(:removed_from)} #{notify_text} #{t(:via)} #{notifier}"  
            @second_pargraph =  ""
            @title = "#{t(:user)} #{t(:removed_from)} #{truncate(notify_text)}"
        when  'ChangeStatus'
            @body = "  #{t(:status_changed)} #{notify_text}  #{t(:via)} #{notifier}"  
            @second_pargraph =  ""
            @title = "#{t(:status_changed)} #{truncate(notify_text)}"

        end

        mail(   :to      => @user.email,
                :from => 'tavan@ut.ac.ir',
                :subject => @title
        ) do |format|
          format.text
          format.html
        end
    end
end