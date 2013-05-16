class CreateItemResults < ActiveRecord::Migration
  def change
    create_table :item_results do |t|
      t.string :identifier
      t.string :sequence_index
      t.datetime :datestamp
      t.string :session_status
      t.string :item_variable
      t.string :candidate_comment
      t.datetime :rendered_datestamp
      t.string :referer
      t.string :ip_address
      t.integer :item_id
      t.integer :user_id

      t.timestamps
    end
  end
end
