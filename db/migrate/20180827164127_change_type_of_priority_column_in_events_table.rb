class ChangeTypeOfPriorityColumnInEventsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :priority
    add_column :events, :priority, :integer
  end
end
