#
# Represents a Referral between a referring physician (ReferralSource) and a consultant (ReferralTarget). A Referral
# created by the consultant is called a request referral (aka reverse referral) and works slightly different in
# that the ReferralTarget is the one creating the referral (rather than the source).
#
# A Referral has an active source and active target, which are the most current ReferralSource and ReferralTarget for
# the referral. Since a referral may be declined by a consultant, multiple ReferralTargets may exist. The active target
# determines the target that the referral is currently assigned.
#
#
#
class Referral < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :referral_state
  belongs_to :cpt_code
  belongs_to :icd9_code
  belongs_to :created_by_user, :class_name=>"User", :foreign_key=>"created_by_user_id"
  belongs_to :created_by_workgroup, :class_name=>"Workgroup", :foreign_key=>"created_by_workgroup_id"
  belongs_to :active_source, :foreign_key=>"active_source_id", :class_name=>"ReferralSource"
  belongs_to :active_target, :foreign_key=>"active_target_id", :class_name=>"ReferralTarget"
  has_many :referral_patients
  has_many :referral_messages
  has_many :referral_diagnosis_selections
  has_many :referral_targets
  has_many :referral_sources
  has_many :referral_insurance_plans
  has_many :referral_files
  has_many :referral_fax_files
  has_many :referral_type_selections
  has_many :referral_studies
  has_many :referral_faxes, :class_name=>"ReferralFax"

  def self.find_eager(id)
    # TODO: may want to trim this down - it is getting too big
    Referral.find(:first, :conditions=>["referrals.id = ?", id], :include=>[:referral_state, :referral_sources, :referral_targets, :cpt_code, :icd9_code, :referral_patients, { :referral_insurance_plans => [:insurance_carrier_tag, :insurance_carrier_plan_tag]}, :referral_diagnosis_selections])
  end

  def self.search_and_filter(filter, results_per_page)
    page_number = (filter.page_number || "1").to_i
    offset = page_number == 1 ? nil : (page_number-1) * results_per_page

    limit_sql = "LIMIT #{results_per_page}" if offset.nil?
    limit_sql = "LIMIT #{offset}, #{results_per_page}" unless offset.nil?

    order_by = " " if filter.to_order_by.nil?
    order_by = "ORDER BY #{filter.to_order_by}" unless filter.to_order_by.nil?

    outbound_sql  = "FROM referrals r, referral_sources rs, referral_targets rt, referral_patients rp, referral_type_selections rts, tags rtst, referral_target_states tstates, referral_source_states sstates WHERE (rs.id = r.active_source_id AND rt.id = r.active_target_id AND rp.referral_id = r.id AND rts.referral_id = r.id AND rtst.id = rts.tag_id AND tstates.id = rt.referral_target_state_id AND sstates.id =rs.referral_source_state_id) AND (rs.workgroup_id = '#{filter.workgroup_id}')"

    inbound_sql  ="FROM referrals r, referral_sources rs, referral_targets rt, referral_patients rp, referral_type_selections rts, tags rtst, referral_target_states tstates, referral_source_states sstates WHERE (rs.id = r.active_source_id AND rt.id = r.active_target_id AND rp.referral_id = r.id AND rts.referral_id = r.id AND rtst.id = rts.tag_id AND tstates.id = rt.referral_target_state_id AND sstates.id =rs.referral_source_state_id) AND (rt.workgroup_id = '#{filter.workgroup_id}')"
    
    if filter.filter_by_owner?
      if filter.filter_owner == 'unassigned'
        inbound_sql += "AND (rt.user_id IS NULL) "
      else
       # debugger
        inbound_sql += "AND rt.user_id = '#{filter.filter_owner}'"# OR (rs.user_id ='#{filter.filter_owner}') "
        outbound_sql += "AND rs.user_id = '#{filter.filter_owner}' "
      end
    end

    if filter.filter_by_type?
      if filter.filter_type == 'other'
        outbound_sql += "AND (rts.tag_type_id != 'referral_standard_types') "
        inbound_sql  += "AND (rts.tag_type_id != 'referral_standard_types') "
      else
        outbound_sql += "AND (rts.tag_id = '#{filter.filter_type}') "
        inbound_sql  += "AND (rts.tag_id = '#{filter.filter_type}') "
      end
    end

    if !filter.search.nil? and !filter.search.empty?
      # see if this is a DOB search
      dob_search_regex = /^(\d{4})-?\d{2}-?\d{2}$/
      matched = filter.search.match(dob_search_regex)
      if matched
        outbound_sql += " AND (rp.dob = '#{matched[0]}') "
        inbound_sql  += " AND (rp.dob = '#{matched[0]}') "
      else
        outbound_sql += " AND (rp.last_name like '%#{filter.search}%' OR rp.first_name like '%#{filter.search}%' OR rp.ssn like '%#{filter.search}%' OR rt.display_name like '%#{filter.search}%') "
        inbound_sql  += " AND (rt.display_name like '%#{filter.search}%' OR rp.last_name like '%#{filter.search}%' OR rp.first_name like '%#{filter.search}%' OR rp.ssn like '%#{filter.search}%' OR rt.display_name like '%#{filter.search}%') "
      end

    end

    if filter.filter_by_status?
      outbound_sql += " AND (rs.referral_source_state_id = '#{filter.filter_status}') "
      inbound_sql  += " AND (rt.referral_target_state_id = '#{filter.filter_status}') "
    end

    outbound_select_fields = "SELECT r.id as referral_id, rts.tag_type_id as tag_type_id, rtst.name as referral_type_name, rp.first_name as patient_first_name, rp.last_name as patient_last_name, rp.middle_name as patient_middle_name, rp.dob as patient_dob, rp.ssn as patient_ssn, r.to_name as to_name, r.from_name as from_name, sstates.name as status "
    inbound_select_fields = "SELECT r.id as referral_id, rts.tag_type_id as tag_type_id, rtst.name as referral_type_name, rp.first_name as patient_first_name, rp.last_name as patient_last_name, rp.middle_name as patient_middle_name, rp.dob as patient_dob, rp.ssn as patient_ssn, r.to_name as to_name, r.from_name as from_name, tstates.name as status "
        if filter.filter_by_direction?

        if filter.filter_direction == 'out'
          outbound_count_sql = "SELECT count(r.id) #{outbound_sql}"
          count   = Referral.count_by_sql(outbound_count_sql)
          #puts "outbound_count: #{count}"

          outbound_select_sql = "#{outbound_select_fields} #{outbound_sql} #{order_by} #{limit_sql}"
          #puts "outbound_sql:\n#{outbound_select_sql}"
          results = Referral.connection.select_all(outbound_select_sql)
        elsif filter.filter_direction == 'in'
          inbound_count_sql = "SELECT count(r.id) #{inbound_sql}"
          count   = Referral.count_by_sql(inbound_count_sql)
          #puts "inbound_count: #{count}"

          inbound_select_sql = "#{inbound_select_fields} #{inbound_sql} #{order_by} #{limit_sql}"
          #puts "inbound_select_sql:\n#{inbound_select_sql}"
          results = Referral.connection.select_all(inbound_select_sql)
        end
      else
  
      # Phase 1 - find all referral ids by using a UNION across inbound and outbound queries
      phase1_sql = "(SELECT r.id as referral_id #{outbound_sql}) UNION DISTINCT (SELECT r.id as referral_id #{inbound_sql})"
      #puts "phase1_sql:\n#{phase1_sql}"
      # note: we have to grab all and count manually, as we can't do a count on a union
      phase1_results = Referral.connection.select_all(phase1_sql)
      count = phase1_results.length
      #phase1_results.each_with_index do |result,i|
      #  puts "row:#{(i+1)} - #{result['referral_id']}"
      #end

      # Phase 2 - same union with all fields, sorted and limited
      phase2_sql = "(#{outbound_select_fields} #{outbound_sql}) UNION DISTINCT (#{inbound_select_fields} #{inbound_sql}) #{order_by} #{limit_sql}"
      #puts "phase2_sql:\n#{phase2_sql}"
      # note: we have to grab all and count manually, as we can't do a count on a union
      phase2_results = Referral.connection.select_all(phase2_sql)
      #phase2_results.each_with_index do |result,i|
      #  puts "row:#{(i+1)} - #{result['referral_id']} #{result['status']}"
      #end
      results = phase2_results
    end

    # Now, load the full referral models using the IDs we found
    #referral_ids = results.collect { |r| r["referral_id"]}
    #referrals = Referral.find(:all, :conditions=>["id in (?)", referral_ids], :order=>"#{filter.to_order_by}", :include=>[:referral_state, :referral_sources, :referral_targets, :cpt_code, :icd9_code, :referral_patients, { :referral_insurance_plans => [:insurance_carrier_tag, :insurance_carrier_plan_tag]}, :referral_diagnosis_selections])

    total_pages = (count / results_per_page)
    total_pages += 1 if (count % results_per_page) != 0

    return results, total_pages, count
  end

  def self.count_awaiting_acceptance_for_workgroup(workgroup_id)
    return ReferralTarget.count('id', :conditions=>["workgroup_id = ? AND referral_target_state_id = 'waiting_acceptance'", workgroup_id])
  end

  def self.count_new_info_for_workgroup(workgroup_id)
    count =  ReferralTarget.count('id', :conditions=>["workgroup_id = ? AND referral_target_state_id = 'new_info'", workgroup_id])
    count += ReferralSource.count('id', :conditions=>["workgroup_id = ? AND referral_source_state_id = 'new_info'", workgroup_id])
    return count
  end

  def self.count_action_requested_for_workgroup(workgroup_id)
    count  = ReferralTarget.count('id', :conditions=>["workgroup_id = ? AND referral_target_state_id = 'waiting_response'", workgroup_id])
    count += ReferralSource.count('id', :conditions=>["workgroup_id = ? AND referral_source_state_id = 'waiting_response'", workgroup_id])
    return count
  end

  def self.count_profile_referral_in(profile)
    return ReferralTarget.count('id', :conditions=>["workgroup_id = ?", profile.workgroup_id]) if profile.workgroup_profile?
    return ReferralTarget.count('id', :conditions=>["user_id = ?", profile.user_id])
  end

  def self.count_profile_referral_out(profile)
    return ReferralSource.count('id', :conditions=>["workgroup_id = ?", profile.workgroup_id]) if profile.workgroup_profile?
    return ReferralSource.count('id', :conditions=>["user_id = ?", profile.user_id])
  end

  # returns the first referral for a given workgroup (nice for UNS workgroups), or nil if none are found
  def self.find_first_for(workgroup)
    targets = ReferralTarget.find(:all, :conditions=>["workgroup_id = ?", workgroup.id]) if workgroup
    return targets.first.referral if targets and !targets.empty? and targets.first
    return nil
  end

  def count_documents
    count  = ReferralFile.count('id', :conditions=>["referral_id = ?", self.id])
    count += ReferralFax.count('id', :conditions=>["referral_id = ?", self.id])
    return count
  end

  def count_new_info_for_workgroup(workgroup_id)
    source_or_target = source_or_target_for(workgroup_id)
    return ReferralMessage.count_new_info_for(self.id, source_or_target.id)
  end

  def count_actions_for_workgroup(workgroup_id)
    source_or_target = source_or_target_for(workgroup_id)
    return ReferralMessage.count_open_requests_for(self.id, source_or_target.id)
  end

  def status_new?
    return self.referral_state_id == ReferralState::NEW
  end

  def status_waiting_approval?
    return self.referral_state_id == ReferralState::WAITING_APPROVAL
  end

  def status_provisional?
    return self.referral_state_id == ReferralState::PROVISIONAL
  end

  def status_in_progress?
    return self.referral_state_id == ReferralState::IN_PROGRESS
  end

  def status_closed?
    return self.referral_state_id == ReferralState::CLOSED
  end

  def delete_referral_type_selections!
    ReferralTypeSelection.delete_all(["referral_id = ?", self.id])
  end

  def delete_referral_sources!
    ReferralSource.delete_all(["referral_id = ?", self.id])
  end

  def delete_referral_targets_in_new_state!
    ReferralTarget.delete_all(["referral_id = ? AND referral_target_state_id in ('new')", self.id])
  end

  def delete_diagnosis_selections!
    ReferralDiagnosisSelection.delete_all(["referral_id = ?", self.id])
  end

  # forcefully remove a referral, including all children rows (ignoring acts_as_paranoid safety net)
  def delete_with_cascade!
    sql = ActiveRecord::Base.connection();
    sql.update "SET FOREIGN_KEY_CHECKS = 0" #Disable forign key checks in MySQL parser
    sql.execute "DELETE FROM referral_diagnosis_selections WHERE referral_id='#{self.id}'"
    sql.execute "DELETE FROM referral_insurance_plans WHERE referral_id='#{self.id}'"
    sql.execute "DELETE FROM referral_patients WHERE referral_id='#{self.id}'"
    sql.execute "DELETE FROM referral_type_selections WHERE referral_id='#{self.id}'"
    sql.execute "DELETE FROM referral_files WHERE referral_id='#{self.id}'"
    sql.execute "DELETE FROM referral_messages WHERE referral_id='#{self.id}'"
    sql.execute "DELETE FROM referral_fax_files WHERE referral_id='#{self.id}'"
    self.referral_faxes.each do |f|
      sql.execute "DELETE FROM referral_fax_content_selections WHERE id='#{f.id}'"
    end
    sql.execute "DELETE FROM referral_faxes WHERE referral_id='#{self.id}'"
    # Delete from 3 tables @ the same time... Just seeing if it works performance is the same as far a I know
    sql.execute "DELETE FROM referrals,referral_sources,referral_targets USING referrals,referral_sources,referral_targets WHERE referrals.id='#{self.id}' AND referral_sources.referral_id='#{self.id}' AND referral_targets.referral_id='#{self.id}'"
    self.freeze # force the model to be frozen, since it has been deleted forcefully (not via destroy method)
  end  

  # validate the state of the referral, since the assembly is asynchronous
  def valid_for_finish?
    # this set of rules isn't in the spec yet, so I'm taking a first pass...

    # clear any previous errors
    errors.clear

    # 1. has a single source?
    if self.active_source_id.nil?
      errors.add("active_source","A referring user must be selected")
    end
    # 2. has a target in the 'new' state?
    if self.active_target_id.nil?
      errors.add("active_target","A consulting provider must be selected")
    end
    # 3. has a patient?
    if self.referral_patients.empty?
      errors.add("referral_patients","A patient must be selected")
    end
    # 4. has a referral_type_selection
    # TODO: commenting out this check since the block isn't complete yet
    #if self.referral_type_selections.empty?
    #  errors.add("referral_type_selections","A requested service must be selected")
    #end
    # x. TBD - has insurance?

    return (errors.empty?)
  end

  def valid_target_for_accept?
    # clear any previous errors
    errors.clear

    if self.active_target.workgroup.ppw? and (self.active_target.user.nil? or !self.active_target.user.is_physician?)
      errors.add("active_target","A physician has not been selected as the consulting provider")
    end

    return (errors.empty?)
  end

  def source_or_target_for(workgroup_id)
    return self.active_source if self.active_source and self.active_source.workgroup_id == workgroup_id
    return self.active_target if self.active_target and self.active_target.workgroup_id == workgroup_id
    return nil
  end

  def opposite_source_or_target_for(workgroup_id)
    return self.active_target if self.active_source and self.active_source.workgroup_id == workgroup_id
    return self.active_source if self.active_target and self.active_target.workgroup_id == workgroup_id
    return nil
  end

  # Display helpers

  def display_patient_id
    return referral_patients.first.id if referral_patients.first
    return "N/A"
  end

  def display_patient_name
    return referral_patients.first.last_first.to_s if referral_patients.first
    return "N/A"
  end

  def display_patient_dob
    return referral_patients.first.display_dob if referral_patients.first
    return "N/A"
  end

  def display_patient_ssn
    return referral_patients.first.display_ssn if referral_patients.first
    return "N/A"
  end

  def display_patient_gender
    return referral_patients.first.display_gender if referral_patients.first
    return "N/A"
  end

  def display_patient_phone
    return referral_patients.first.display_phone if referral_patients.first
    return "N/A"
  end

  def display_to_name
    return active_target.display_name unless active_target.nil?
    return "N/A"
  end

  def display_from_name
    return active_source.display_name unless active_source.nil?
    "N/A"
  end

  def display_referral_type
    # TODO: how to handle more than one?
    return referral_type_selections.first.tag.name if referral_type_selections.first
  end

  def display_primary_insurance_carrier
    return referral_insurance_plans.first.display_carrier_name if referral_insurance_plans.first
    return "N/A"
  end

  def display_primary_insurance_plan
    return referral_insurance_plans.first.display_plan if referral_insurance_plans.first
    return "N/A"
  end

  def display_primary_insurance_details
    return referral_insurance_plans.first.display_details if referral_insurance_plans.first
    return "N/A"
  end

  def display_last_action
    return updated_at.strftime("%m-%d-%Y")
  end

  def wizard_step_mark_complete(step)
    # only mark forward progress (user can open previous section for editing)
    [ :service_provider, :service_request, :patient, :insurance, :referring_physician, :files, :faxes, :complete ].reverse.each do |candidate|
      if( candidate.to_s == wizard_step )
        break
      elsif( candidate == step )
        self.wizard_step = step.to_s
      end
    end
  end

  def wizard_step_complete?(step)
    # steps: service_provider, service_request, patient, insurance, files, faxes, referring_physician, complete

    # puts wizard_step + ' == ' + step.to_s + ' ?'

    return ( wizard_step == :complete.to_s ) if step == :complete
    return ( wizard_step == :faxes.to_s || step == :complete ) if step == :faxes
    return ( wizard_step == :files.to_s || wizard_step_complete?( :faxes ) ) if step == :files
    return ( wizard_step == :referring_physician.to_s || wizard_step_complete?( :files ) ) if step == :referring_physician
    return ( wizard_step == :insurance.to_s || wizard_step_complete?( :referring_physician ) ) if step == :insurance
    return ( wizard_step == :patient.to_s || wizard_step_complete?( :insurance ) ) if step == :patient
    return ( wizard_step == :service_request.to_s || wizard_step_complete?( :patient ) ) if step == :service_request

    step == :service_provider
  end

  def wizard_complete?
    wizard_step_complete? :complete
  end

  def request_referral?
    return self.active_source.workgroup_id != self.created_by_workgroup_id
  end
end
