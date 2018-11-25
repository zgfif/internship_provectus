class AddDefaultEventsTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :default_events_type, :integer
  end
end
