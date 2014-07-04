class ProjectSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.to_datetime.utc.rfc3339
  end

  def online_date
    value = object.online_date
    if value
      value.to_datetime.utc.rfc3339
    end
  end

  attributes :id,
    :about_html,
    :address_city,
    :address_neighborhood,
    :address_state,
    :address_zip_code,
    :budget_html,
    :campaign_type,
    :category_id,
    :created_at,
    :featured,
    :goal,
    :hash_tag,
    :headline,
    :hero_image,
    :home_page,
    :more_links,
    :name,
    :online_date,
    :online_days,
    :organization_type,
    :permalink,
    :pledged,
    :recommended,
    :short_url,
    :site,
    :state,
    :street_address,
    :terms_html,
    :uploaded_image,
    :user_id,
    :video_embed_url,
    :video_thumbnail,
    :video_url
end
