class AddGoalIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :goal, type: :uuid, index: true
  end
end
