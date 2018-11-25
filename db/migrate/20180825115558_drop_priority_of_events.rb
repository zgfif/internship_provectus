class DropPriorityOfEvents < ActiveRecord::Migration[5.2]
  def change
    drop_table :priority_of_events
  end
end
