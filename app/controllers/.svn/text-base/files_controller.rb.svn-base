class FilesController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral, :except=>[:download]
  before_filter :initialize_workflow_engine, :except=>[:download]
  before_filter :load_target_file, :only=>[:download]

  # lists all files/documents associated to the referral
  def index
    render :partial=>"edit_index" if params['edit_mode']

    unless( params['edit_mode'] )
      @engine.referral.wizard_step_mark_complete :files
      @engine.referral.save!

      if @engine.referral.wizard_step == :files.to_s
        render :partial => 'next_step'
      else
        render :update do |page|
          page.replace_html 'referral_files', :partial => 'files/index', :locals=>{ :edit_disabled => false }
        end
      end
    end
  end

  # create new empty file object
  def new
    render :partial=>"edit_new_file_detail"
  end

  def create
    begin
      referral_file = ReferralFile.new( params[ 'referral_file' ] )

      referral_file.referral_file_type = ReferralFileType.find( params['file_type_id'] )
      referral_file.mime_type = MimeType.find( 'jpg' )

      referral_file.filename = referral_file.public_filename.clone

      @engine.attach_file( :file => referral_file )

      # audit logging
      method_of_upload = (@engine.referral.status_new?) ? "initial" : "edit"
      log_file_uploaded(current_user, @workgroup, @engine.referral, referral_file, method_of_upload)

      respond_to do |format|
        format.js do
          responds_to_parent do
            render :update do |page|
              page.replace_html 'referral_files', :partial => 'edit_index'
            end
          end
        end
      end
    rescue => e
      logger.error("Errors: #{referral_file.errors.full_messages}")
      logger.error("#{e}\n"+e.backtrace.join("\n"))

      # audit logging
      log_file_upload_failed(self.current_user, @workgroup, @engine.referral, e)

      # format error messages for display
      flash[:partial] = 'FILE UPLOAD DID NOT SUCCEED, PLEASE CHECK VALUES'

      respond_to do |format|
        format.js do
          responds_to_parent do
            render :update do |page|
              page.replace_html 'file_detail_new', :partial => 'edit_new_file_detail'
            end
          end
        end
      end
    end
  end

  # edit existing file object
  def edit
    referral_file = ReferralFile.find( params['id'] )
    render :partial=>"edit_file_detail", :locals => { :file => referral_file }
  end

  def update
    referral_file = ReferralFile.find( params['id'] )

    referral_file.referral_file_type = ReferralFileType.find( params['file_type_id'] )
    referral_file.description = params['description']

    referral_file.save!

    render :partial=>"file_detail", :locals => { :file => referral_file, :editing_controls => true }
  end

  # remove existing file object
  def destroy
    ReferralFile.destroy(params['id'])

    render :partial=>"edit_index"
  end

  def download
    begin
      send_file @target_file.full_filename,
                :filename => @target_file.filename,
                :type => @target_file.content_type,
                :disposition => 'attachment'
    rescue => e
      handle_error("Unable to start the file download at this time",e)
    end
  end
end
