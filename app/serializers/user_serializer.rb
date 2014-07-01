class UserSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.to_datetime.utc.rfc3339
  end

  attributes :id,
    :bio,
    :created_at,
    :display_image,
    :display_name,
    :email,
    :facebook_url,
    :linkedin_url,
    :other_url,
    :profile_type,
    :twitter_url
end
