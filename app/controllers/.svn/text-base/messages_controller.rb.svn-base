class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_referral
  before_filter :load_target_message_eager, :only=>[:show, :print]
  before_filter :load_target_message, :only=>[:edit, :update, :destroy, :new_reply, :create_reply]
  before_filter :initialize_workflow_engine

  include MessagesQuerySystem

  # show all messages for the referral
  def index
    # messages grid setup - normally called from ReferralsController#summary using an XHR call
    setup_messages_filter_from_session_or_request
    query_messages_using_filter
    render :partial=>"results" and return if request.xhr?
  end

  # view a message
  def show
    begin
      # call the workflow engine to mark the message as read
      @engine.mark_message_read(:message=>@target_message)
      # call the workflow engine to mark the reply as read, if one is avail (since we group top-level messages with replies, we have to update both)
      @engine.mark_message_read(:message=>@target_message.reply_message) if @target_message.has_reply?
    rescue WorkflowEngine::WorkflowEngineException => e
      logger.error(e)
      handle_error("A server error occurred") and return
    end
    render :layout=>false and return if request.xhr?
  end

  # new message form
  def new
    @message = ReferralMessage.new
    @message_types = ReferralMessageType.find(:all, :order=>"name")
    render :layout=>false and return if request.xhr?
  end

  # create a new message (not a reply)
  def create
    @message = ReferralMessage.new(params[:message])
    @message.created_by = current_user
    @message_types = ReferralMessageType.find(:all, :order=>"name")

    # validate the model here to catch and render any errors
    if !@message.valid?
      flash.now[:partial] = "Please fix the following error(s)"
      render :action=>"new", :layout=>false, :status => 500 and return if request.xhr?
      render :action=>"new" and return
    end

    # if valid, ask the workflow engine to save and attach it to the referral
    begin
      referral = @engine.attach_message(:message=>@message)

      # if any file/fax id's were passed in as well, attach them to this message now
      if params[:file_ids]
        params[:file_ids].each do |file_id|
          # attach the message id to each file
          file = ReferralFile.find(file_id)
          file.update_attributes({ :referral_message_id => @message.id })

          # audit logging
          log_file_uploaded(current_user, @workgroup, @engine.referral, file, "compose")

        end
      end

      if params[:fax_ids]
        params[:fax_ids].each do |fax_id|
          # attach the message id to each file
          fax = ReferralFax.find(fax_id)
          fax.update_attributes({ :referral_message_id => @message.id })

          # audit logging
          log_fax_created(current_user, @workgroup, @engine.referral, fax, "compose")
        end
      end

      # audit logging
      log_message_created(current_user, @workgroup, @engine.referral, @message)

      render :partial=>"create_success" and return if request.xhr?
      redirect_to referral_path({ :id=>@target_referral.id}) and return
    rescue WorkflowEngine::WorkflowEngineException => e
      flash.now[:partial] = "Please fix the following errors"
      render :action=>"new", :layout=>false, :status => 500 and return if request.xhr?
      render :action=>"new", :status => 500 and return
    end
  end

  # reply form
  def new_reply
    @message_types = ReferralMessageType.find(:all, :order=>"name")
    render :layout=>false and return if request.xhr?
  end

  # save reply
  def create_reply
    @message = ReferralMessage.new(params[:message])
    @message.referral_message_type_id = 'reply_provided' if @target_message.request?
    @message.referral_message_type_id = 'info_provided'  if @target_message.note?
    @message.created_by = current_user
    @message.subject = "Re: #{@target_message.subject}"
    @message.reply_to_message = @target_message

    # validate the model here to catch and render any errors
    if !@message.valid?
      flash.now[:partial] = "Please fix the following error(s)"
      render :action=>"new", :layout=>false and return if request.xhr?
      render :action=>"new", :status => 500 and return
    end

    # if valid, ask the workflow engine to save and attach it to the referral
    begin
      referral = @engine.attach_message(:message=>@message)
      # now mark the original message as complete since the user has replied to it if it is a request
      # now handled in the engine: referral = @engine.complete_message(:message=>@target_message) if @target_message.request?

      # if any file/fax id's were passed in as well, attach them to this message now
      if params[:file_ids]
        params[:file_ids].each do |file_id|
          # attach the message id to each file
          file = ReferralFile.find(file_id)
          file.update_attributes({ :referral_message_id => @message.id })

          # audit logging
          log_file_uploaded(current_user, @workgroup, @engine.referral, file, "reply")
        end
      end

      if params[:fax_ids]
        params[:fax_ids].each do |fax_id|
          # attach the message id to each file
          fax = ReferralFax.find(fax_id)
          fax.update_attributes({ :referral_message_id => @message.id })

          # audit logging
          log_fax_created(current_user, @workgroup, @engine.referral, fax, "reply")
        end
      end

      # audit logging
      log_message_created(current_user, @workgroup, @engine.referral, @message)

      render :partial=>"reply_success" and return if request.xhr?
      redirect_to referral_path({ :id=>@target_referral.id}) and return
    rescue WorkflowEngine::WorkflowEngineException => e
      flash.now[:partial] = "Please fix the following errors"
      render :action=>"new", :layout=>false, :status => 500 and return if request.xhr?
      render :action=>"new", :status => 500 and return
    end
  end

  # handles voiding a message
  def destroy
    begin
      # call the workflow engine to mark the message as read and test
      @engine.void_message(:message=>@target_message)
      render :partial=>"destroy_success" and return if request.xhr?
    rescue WorkflowEngine::WorkflowEngineException => e
      handle_error("A server error occurred") and return
    end
    # TODO - refresh the entire page with the current filter?
    render :layout=>false and return if request.xhr?
  end

  def print
    render :layout=>"print"
  end

  def new_info
    @new_messages = ReferralMessage.find_unread_messages_for(@target_referral.id, @target_referral.source_or_target_for(@workgroup.id))
    render :layout=>"print"
  end

  def action_requested
    @messages = ReferralMessage.find_open_requests_for(@target_referral.id, @target_referral.source_or_target_for(@workgroup.id))
    render :layout=>"print"
  end

  def new_file_attachment
    render :partial=>"new_file"
  end

  def new_fax_attachment
    render :partial=>"new_fax"
  end

  def attach_file
    referral_file = ReferralFile.new( params[ 'referral_file' ] )

    referral_file.referral_file_type = ReferralFileType.find( params['file_type_id'] )
    referral_file.mime_type = MimeType.find( 'jpg' )

    referral_file.filename = referral_file.public_filename.clone

    @engine.attach_file( :file => referral_file )

    respond_to do |format|
      format.js do
        responds_to_parent do
          render :update do |page|
            page.replace_html 'new_message_file', link_to_remote( 'Add a Document', :update => 'new_message_file', :url => new_file_attachment_referral_messages_url( @target_referral ), :method => :get, :html => { :class => 'section_add_file' } )

            page.insert_html :bottom, 'hidden_ids', hidden_field_tag( 'file_ids[]', referral_file.id.to_s )
            page.insert_html :before, 'new_message_file', :partial => 'file_detail', :locals => { :file => referral_file }
          end
        end
      end
    end
  end

  def attach_fax
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

    render :update do |page|
      page.replace_html 'new_message_fax', link_to_remote( 'Add a Fax', :update => 'new_message_fax', :url => new_fax_attachment_referral_messages_url( @target_referral ), :method => :get, :html => { :class => 'section_add_file' } )

      page.insert_html :bottom, 'hidden_ids', hidden_field_tag( 'fax_ids[]', referral_fax.id.to_s )
      page.insert_html :before, 'new_message_fax', :partial => 'fax_detail', :locals => { :fax => referral_fax }
    end
  end
end
