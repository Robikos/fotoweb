class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.attachment :picture
      t.timestamps
    end
  end
end
