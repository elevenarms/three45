module InsuranceHelper
  include FilesHelper

  def insurance_carrier_options_for(target_workgroup, current_value=nil)
    insurance_carriers = Array.new

    # get the profile for the workgroup
    workgroup_profile = target_workgroup.find_default_profile
    if workgroup_profile
      # get sorted the list of insurance carriers
      insurance_carriers = workgroup_profile.tags_for_type('insurance_carriers')
    end

    # return the options
    return options_for_select([["-- Select a Provider -- ",""]] + insurance_carriers.sort { |x,y| x.name <=> y.name}.collect { |ic| [ic.name, ic.id] }, current_value)
  end

  def insurance_carrier_plan_options_for(target_workgroup, carrier_tag_id, current_value=nil)
    insurance_plans = Array.new

    if carrier_tag_id and !carrier_tag_id.empty?
      # get the profile for the workgroup
      workgroup_profile = target_workgroup.find_default_profile
      if workgroup_profile
        # get sorted the list of insurance carriers
        insurance_plans = workgroup_profile.tags_for_type_with_parent('insurance_carrier_plans', carrier_tag_id)
      end
    else
      return options_for_select([["-- Select a Provider First -- ",""]] + insurance_plans.sort { |x,y| x.name <=> y.name}.collect { |ic| [ic.name, ic.id] })
    end

    # return the options
    return options_for_select([["-- Select a Plan -- ",""]] + insurance_plans.sort { |x,y| x.name <=> y.name}.collect { |ic| [ic.name, ic.id] }, current_value)
  end

end
