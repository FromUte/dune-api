module Neighborly::Api
  class Contribution < ::Contribution
    scope :between_values, ->(start_at, ends_at) do
      return all unless start_at.present? && ends_at.present?
      where('value between ? and ?', start_at, ends_at)
    end
  end
end
