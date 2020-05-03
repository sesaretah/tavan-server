class V1::RegistrationController < ApplicationController
    def service
        response = open('https://auth.ut.ac.ir:8443/cas/serviceValidate?service=https%3A%2F%2Ftavan.ut.ac.ir%2Fusers%2Fservice&ticket='+params[:ticket]).read
        @result = Hash.from_xml(response.gsub("\n", ""))
        if !@result['serviceResponse']['authenticationSuccess'].blank?
          @utid = @result['serviceResponse']['authenticationSuccess']['user']
          @sso = Sso.where(utid: @utid).first
          if @sso.blank?
            @sso = Sso.create(utid: @utid, uuid: SecureRandom.uuid)
          end
          @sso.status = 'success'
          @sso.save
          @user = User.where(utid: @utid).first
          if !@user.blank?
            sign_in(@user)
            redirect_to after_sign_in_path_for(@user)
          else
            redirect_to '/users/sign_up?sso='+ @sso.uuid
          end
        end
      end
end
