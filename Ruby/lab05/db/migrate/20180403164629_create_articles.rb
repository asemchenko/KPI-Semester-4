class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :branch_id
      t.integer :author_id
      t.string :title
      t.text :text

      t.timestamps null: false
    end
  end
end
