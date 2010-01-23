class FaxFilesController < ApplicationController
  before_filter :login_required, :except=>[:create]
  before_filter :load_default_profile, :except=>[:create]
  before_filter :load_target_fax
  before_filter :load_target_fax_file, :only=>[:edit, :update, :destroy, :download]
  before_filter :initialize_workflow_engine

  #
  # Creates a new ReferralFaxFile and updates the fax status (if provided with a param name of 'new_fax_state_id')
  #
  # Parameters accepted:
  #
  # 'fax_file'[] - the attributes for the new ReferralFaxFile
  # 'new_fax_state_id' - the new referral_fax_state_id for the referral_fax referenced by the 'id' param
  #
  # This action currently responds to a POST to the following URL: /faxes/<referral_fax_id>/fax_files
  #                                                            or: /faxes/<referral_fax_id>/fax_files.xml (for XML responses)
  #
  # Uploaded faxes are dropped into public/faxes, which needs to exist locally
  # (it is symlinked on stage/www to a shared directory)
  #
  # Note: You must use a multipart upload to push the file
  #
  def create
    begin
      @fax_file = ReferralFaxFile.new(params['fax_file'])
      state_id = params['new_fax_state_id']
      @engine.attach_fax_file(:fax=>@target_fax, :fax_file=>@fax_file)
      @engine.update_fax_state(:fax=>@target_fax, :fax_state=>state_id) if state_id

      respond_to do |format|
        format.html { render :text=>"Created", :status=>200 }
        format.xml  { render :xml => @fax_file.to_xml }
      end
    rescue WorkflowEngine::WorkflowEngineException => e
      respond_to do |format|
        format.html { handle_error("A server error occurred") and return }
        format.xml  { render :xml => "A server error occurred: #{e}", :status=>500 }
      end
    end
  end

  def download
    begin
      send_file @target_fax_file.full_filename,
                :filename => @target_fax_file.filename,
                :type => @target_fax_file.content_type,
                :disposition => 'attachment'
    rescue => e
      handle_error("Unable to start the fax download at this time",e)
    end
  end
end
