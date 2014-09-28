class CreateSample < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.text :url
      t.text :linkurl

      t.timestamps
    end
  end
end
