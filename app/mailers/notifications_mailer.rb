class NotificationsMailer < ActionMailer::Base

    def notify_email(user_id, notify_type, notifier, notify_text, custom_text)
        @user = User.find(user_id)
        case notify_type
        when  'Work'
            @body = "#{t(:work_notification)} #{t(:via)} #{notifier} #{t(:inside)} #{notify_text}"
        when  'Task'
            @body = "#{t(:task_notification)}  #{t(:via)} #{notifier} #{t(:onto)} #{notify_text}" 
        when  'Report'
            @body = "#{t(:report_notification)}  #{t(:via)} #{notifier} #{t(:onto)} #{notify_text}" 
        when  'Comment'
            @body = "#{t(:comment_notification)}  #{t(:via)} #{notifier} #{t(:onto)} #{notify_text}" 
        when  'AddParticipant'
            @body = "#{custom_text}  #{t(:is_added_to)} #{notify_text} #{t(:via)} #{notifier}" 
        when  'RemoveParticipant'
            @body = "#{custom_text}  #{t(:removed_from)} #{notify_text} #{t(:via)} #{notifier}"  

        end

        mail(   :to      => @user.email,
                :from => 'snadmin@ut.ac.ir',
                :subject => t(:notification)
        ) do |format|
          format.text
          format.html
        end
    end
end