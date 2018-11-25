class AddDefaultValueToUserDefaultEventsType < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :default_events_type, :integer, default: 0
  end
end
