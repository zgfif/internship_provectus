class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.string :description
      t.integer :status
      t.integer :priority
      t.references :event, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
