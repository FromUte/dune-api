module Neighborly::Api
  class ApiConstraint
    attr_reader :revision

    def initialize(options)
      @revision = options.fetch(:revision)
      @default = options[:default]
    end

    def matches?(request)
      @default || request
        .headers
        .fetch(:accept)
        .include?("revision=#{revision}")
    end
  end
end
