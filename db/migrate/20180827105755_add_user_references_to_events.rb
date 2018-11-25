class AddUserReferencesToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :user, type: :uuid, index: true
  end
end
