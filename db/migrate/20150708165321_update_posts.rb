class UpdatePosts < ActiveRecord::Migration
  def change
    add_column :posts, :title, :string
    add_column :posts, :text, :string
    add_reference :posts, :user, index: true
  end
end
