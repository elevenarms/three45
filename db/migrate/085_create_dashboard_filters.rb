class CreateDashboardFilters < ActiveRecord::Migration
  def self.up
    exists = DashboardFilter.table_exists? rescue false
    if !exists
      create_table :dashboard_filters, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :user_id
        t.string :filter_direction
        t.string :filter_owner
        t.string :filter_type

        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE dashboard_filters ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = DashboardFilter.table_exists? rescue false
    if exists
      drop_table :dashboard_filters
    end
  end
end
