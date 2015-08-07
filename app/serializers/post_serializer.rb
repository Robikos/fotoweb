class PostSerializer < ActiveModel::Serializer
  attributes :id, :picture_file_name, :picture_thumb_name, :picture_file_size, :picture_updated_at,
    :created_at, :updated_at, :title, :text, :comments_count

  REGXP = /((\d){4}-(\d){2}-(\d){2})\s(\d\d:\d\d)/

  def picture_file_name
    object.picture.url(:normal) || object.picture.url
  end

  def picture_thumb_name
    object.picture.url(:medium)
  end

  def comments_count
    object.comments.count
  end

  def created_at
    REGXP.match(object.created_at.to_s)[0] if object.created_at
  end

  def updated_at
    REGXP.match(object.updated_at.to_s)[0] if object.updated_at
  end
end
