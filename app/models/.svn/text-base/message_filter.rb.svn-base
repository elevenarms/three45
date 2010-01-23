#
# Stores user-specific message filters across sessions. Any attributes declared within this model
# are used by the UI but not stored after the session has expired.
#
#
#
class MessageFilter
  attr :referral_id, true
  attr :page_number, true
  attr :sort_field, true
  attr :sort_order, true
  attr :referral_source_or_target_id, true

  def to_order_by
    if sort_field == 'status'
      return "referral_message_states.name #{sort_order}"
    end

    if sort_field == 'type'
      return "referral_message_types.name #{sort_order}"
    end

    if sort_field == 'created'
      return "referral_messages.created_at #{sort_order}"
    end

    if sort_field == 'subject'
      return "referral_messages.subject #{sort_order}"
    end

    return nil
  end
end
