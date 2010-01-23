class CreateReferralTypeSelections < ActiveRecord::Migration
  def self.up
    exists = ReferralTypeSelection.table_exists? rescue false
    if !exists
      create_table :referral_type_selections, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :referral_id, :limit => 36, :null => false

        # tag_type may either be the standard referral types or a service tag type
        # (see mini-spec on ServiceRequestBlock
        t.string :tag_type_id, :limit => 36, :null => false
        # tag_id corresponds to the tag_type
        t.string :tag_id, :limit => 36, :null => false

        t.text    :diagnosis_text
        t.text    :additional_instructions

        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_type_selections ADD PRIMARY KEY (id)"

      remove_column :referrals, :diagnosis_text
      remove_column :referrals, :instruction_text
    end
  end

  def self.down
    exists = ReferralTypeSelection.table_exists? rescue false
    if exists
      drop_table :referral_type_selections
      # not going to recreate referral columns removed above
    end
  end
end
