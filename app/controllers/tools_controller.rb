class ToolsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def audit_trail
        @audits = Audited::Audit.order("id DESC")
        @actions  = @audits.pluck(:action).uniq.sort
        @types  = @audits.pluck(:auditable_type).uniq.sort
        @users  = User.all

        unless params[:date].blank?  
            @audits = @audits.where("DATE(created_at) = ?", params[:date])
        end

        unless params[:audit_action].blank?
            @audits = @audits.where(action: params[:audit_action])
        end

        unless params[:type].blank?
            @audits = @audits.where(auditable_type: params[:type])
        end

        unless params[:user_id].blank?
            @audits = @audits.where(user_id: params[:user_id])
        end
            
        @audits = @audits.paginate(page: params[:page], per_page: 15)
    end

    def relancer
    end

    def relancer_do
        require 'rake'
    
        Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
        Rails.application.load_tasks # providing your application name is 'sample'
          
        # capture output
        @stdout_stream = capture_stdout do
          Rake::Task['factures:relancer'].reenable # in case you're going to invoke the same task second time.
          Rake::Task['factures:relancer'].invoke(params[:enregistrer])
        end
    end
    
end