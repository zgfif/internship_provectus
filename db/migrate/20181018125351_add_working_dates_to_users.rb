class AddWorkingDatesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :working_start_time, :string, default: '08:00:00'
    add_column :users, :working_end_time, :string, default: '21:00:00'
  end
end
