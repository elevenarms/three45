class FaxesController < ApplicationController
  BARCODE_GENERATOR_BASE_URL = "http://67.207.132.161/barcode/generate"

  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral, :except=> [:update_status, :cover_page]
  before_filter :load_target_fax, :only=> [:update_status, :cover_page]
  before_filter :initialize_workflow_engine

  # lists all faxes associated to the referral
  def index
    render :partial=>"edit_index" if params['edit_mode']

    unless( params['edit_mode'] )
      @engine.referral.wizard_step_mark_complete :faxes
      @engine.referral.save!

      if @engine.referral.wizard_step == :faxes.to_s
        render :partial => 'next_step'
      else
        render :update do |page|
          page.replace_html 'referral_faxes', :partial => 'faxes/index', :locals=>{ :edit_disabled => false }
        end
      end
    end
  end

  # create an associated fax
  def new
    render :partial=>"edit_new_fax_detail"
  end

  def create
    referral_fax = ReferralFax.new

    referral_fax.referral_fax_state_id = ReferralFaxState.find('waiting').id

    referral_fax.page_count = params["page_count"]

    Tag.find( :all, :conditions => [ "tag_type_id = ?", 'referral_fax_content_types' ] ).each do |content_type|
      if params["#{content_type.id}"]
        referral_fax.referral_fax_content_selections << ReferralFaxContentSelection.new( :tag_id => content_type.id )
      end
    end

    referral_fax.comments = params['comments']

    @engine.attach_fax( :fax => referral_fax )

    # audit logging
    method_of_create = (@engine.referral.status_new?) ? "initial" : "edit"
    log_fax_created(current_user, @workgroup, @engine.referral, referral_fax, method_of_create)

    render :partial => "edit_index"
  end

  # edit an existing associated fax
  def edit
    referral_fax = ReferralFax.find( params['id'] )
    render :partial=>"edit_fax_detail", :locals => { :fax => referral_fax }
  end

  def update
    referral_fax = ReferralFax.find( params['id'] )

    # clear content types
    ReferralFaxContentSelection.delete_all( [ "referral_fax_id = ?", referral_fax.id ] )

    Tag.find( :all, :conditions => [ "tag_type_id = ?", 'referral_fax_content_types' ] ).each do |content_type|
      if params["#{content_type.id}"]
        referral_fax.referral_fax_content_selections << ReferralFaxContentSelection.new( :tag_id => content_type.id )
      end
    end

    referral_fax.comments = params['comments']
    referral_fax.page_count = params["page_count"]
    referral_fax.save!

    render :partial=>"fax_detail", :locals => { :fax => referral_fax, :editing_controls => true }
  end

  #
  # Updates a ReferralFax with the new fax state
  #
  # Parameters accepted:
  #
  # 'id' - the referral_fax_id that this file should be attached to
  # 'new_fax_state_id' - the new referral_fax_state_id for the referral_fax referenced by the 'id' param
  # 'error_details' - (optional) any details about the error, if the status isn't received_successfully
  #
  # This action currently responds to a POST to the following URL: /faxes/<referral_fax_id>/update_status
  #                                                            or: /faxes/<referral_fax_id>/update_status.xml (for XML responses)
  #
  def update_status
    begin
      @engine.update_fax_state(:fax=>@target_fax, :fax_state=>params['new_fax_state_id'], :error_details=>params[:error_details])
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

  def cover_page
    @active_source = @target_referral.active_source
    @active_target = @target_referral.active_target
    render :layout=>"print"
  end

  # disassociate a fax
  def destroy
    ReferralFax.destroy(params['id'])

    render :partial=>"edit_index"
  end
end
