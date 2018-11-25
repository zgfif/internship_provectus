class CreatePriorityOfEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :priority_of_events, id: :uuid do |t|
      t.string :name
    end
  end
end