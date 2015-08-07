class LikeSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :user_id, :post_id

  REGXP = /((\d){4}-(\d){2}-(\d){2})\s(\d\d:\d\d)/

  def created_at
    REGXP.match(object.created_at.to_s)[0]
  end
end
