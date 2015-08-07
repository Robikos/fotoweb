class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :updated_at
  has_one :author, serializer: UserSerializer

  REGXP = /((\d){4}-(\d){2}-(\d){2})\s(\d\d:\d\d)/

  def created_at
    REGXP.match(object.created_at.to_s)[0]
  end
end
