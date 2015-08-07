class FriendshipSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :user_id, :friend_id

  REGXP = /(\d){4}-(\d){2}-(\d){2}/

  def created_at
    REGXP.match(object.created_at.to_s)[0]
  end
end
