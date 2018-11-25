class AddDefaultValueToUserDefaultEventsPriority < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :default_events_priority, :integer, default: 0
  end
end
