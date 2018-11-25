class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :name
      t.string :avatar
      t.timestamps
    end
  end
end
