module Dune::Api
  class Contribution < ::Contribution
    scope :between_values, ->(start_at, ends_at) do
      return all unless start_at.present? && ends_at.present?
      where('value between ? and ?',
            start_at.to_s.sub(',', '').to_f,
            ends_at.to_s.sub(',', '').to_f)
    end

    scope :by_project_id, ->(project_id) do
      where(project_id: project_id)
    end
  end
end
