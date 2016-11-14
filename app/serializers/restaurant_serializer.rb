class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :upvotes, :downvotes

  def upvotes
    object.upvotes.count
  end

  def downvotes
    object.downvotes.count
  end
end
