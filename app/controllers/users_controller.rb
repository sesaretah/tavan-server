class UsersController < ApplicationController

    def service
        response = open('https://auth.ut.ac.ir:8443/cas/serviceValidate?service=https%3A%2F%2Ftavan.ut.ac.ir%2Fusers%2Fservice&ticket='+params[:ticket], {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
        result = Hash.from_xml(response.gsub("\n", ""))
        Rails.logger.info result
        if !result['serviceResponse']['authenticationSuccess'].blank?
            utid = result['serviceResponse']['authenticationSuccess']['user']
            user = User.find_by_email(utid + '@ut.ac.ir')
            if user.blank?
                password = SecureRandom.hex(6)
                user = User.create(email: utid+ '@ut.ac.ir', password: password, password_confirmation: password, last_login: DateTime.now)     
                Profile.create(name: utid, user_id: user.id)       
            end
            redirect_to('https://tavan.ut.ac.ir/app.html#!/login_jwt/'+JWTWrapper.encode({ user_id: user.id }))
        else
            redirect_to('https://tavan.ut.ac.ir/app.html#!/login_error/')
        end
      end
    
end