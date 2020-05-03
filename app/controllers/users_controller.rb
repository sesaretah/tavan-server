class UsersController < ApplicationController

    def service
        response = open('https://auth.ut.ac.ir:8443/cas/serviceValidate?service=https%3A%2F%2Ftavan.ut.ac.ir%2Fusers%2Fservice&ticket='+params[:ticket]).read
        result = Hash.from_xml(response.gsub("\n", ""))
        Rails.logger.info result
        if !result['serviceResponse']['authenticationSuccess'].blank?
            redirect_to('https://tavan.ut.ac.ir/app.html#!/login/'+result['serviceResponse']['authenticationSuccess']['user'])
        end
      end
    
end