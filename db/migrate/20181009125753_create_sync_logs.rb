class CreateSyncLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_logs, id: :uuid do |t|
      t.datetime :time
      t.string :calendar_id
      t.string :event_id
      t.integer :status
      t.string :reason
      
      t.references :user, type: :uuid, foreign_key: true
    end
  end
end
