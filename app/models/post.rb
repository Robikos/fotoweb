class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_attached_file :picture, :styles => {
    :normal => "640x640>", 
    :medium => "300x300>", 
    :thumb => "100x100>" }, 
    :default_url => "/images/:style/missing.png"

  validates_attachment :picture, :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }

  validates :title, :text, :picture, presence: true
end
