class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar_file_name, :posts_count

  REGXP = /(\d){4}-(\d){2}-(\d){2}/

  def avatar_file_name
    object.avatar.url(:medium)
  end

  def posts_count
    object.posts.count
  end

  def created_at
    REGXP.match(object.created_at.to_s)[0]
  end
end
