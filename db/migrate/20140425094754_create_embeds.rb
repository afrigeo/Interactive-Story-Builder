class CreateEmbeds < ActiveRecord::Migration
  def change
    create_table :embeds do |t|
      t.integer :section_id
      t.string :title
      t.string :url
      t.text :code

      t.timestamps
    end
    
    add_index :embeds, :section_id
  end
end
