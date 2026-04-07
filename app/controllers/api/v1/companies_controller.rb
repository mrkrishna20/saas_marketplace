class Api::V1::CompaniesController < ApplicationController
    before_action :authenticate_user, only: [:create]
    
    def create
        @company = Company.new(company_params)
        @company.user = current_user
    
        if @company.save
            current_user.update(role: 'admin')
        
            render json: { 
                company: @company,
                message: 'Company created successfully and user set as admin' 
            }, status: :created
        else
            render json: { 
                errors: @company.errors.full_messages 
            }, status: :unprocessable_entity
        end
    end
 
    private
 
    def company_params
        params.require(:company).permit(:name)
    end
end
 

