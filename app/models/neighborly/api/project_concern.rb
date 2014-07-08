module Neighborly::Api::ProjectConcern
  extend ActiveSupport::Concern

  included do
    %i(created_at expires_at online_date).each do |name|
      # class << self
      #   def between_created_at(starts_at, ends_at)
      #     between_dates(:created_at, starts_at, ends_at)
      #   end
      # end
      define_singleton_method("between_#{name}") do |starts_at, ends_at|
        between_dates(name, starts_at, ends_at)
      end
    end

    private

    def self.between_dates(attribute, starts_at, ends_at)
      where(attribute => [starts_at..ends_at])
    end
  end
end
