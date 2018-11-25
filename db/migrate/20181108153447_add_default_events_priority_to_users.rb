class AddDefaultEventsPriorityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :default_events_priority, :integer
  end
end
