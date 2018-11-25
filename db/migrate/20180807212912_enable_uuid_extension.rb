class EnableUuidExtension < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'
    connection.execute('create extension if not exists "pgcrypto"')
  end
end
