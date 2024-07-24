class CreateQueries < ActiveRecord::Migration[7.1]
  def change
    create_table :queries do |t|
      t.string :content
      t.string :user_ip

      t.timestamps
    end

    add_index :queries, :content
    add_index :queries, :user_ip
  end
end
