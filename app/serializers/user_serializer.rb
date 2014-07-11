class UserSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.to_datetime.utc.rfc3339
  end

  attributes :id,
    :bio,
    :created_at,
    :email,
    :facebook_url,
    :linkedin_url,
    :other_url,
    :profile_type,
    :twitter_url,
    :name,
    :image_url,
    :admin

  def name
    object.display_name
  end

  def image_url
    object.display_image
  end
end
