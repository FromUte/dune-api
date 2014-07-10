module Neighborly::Api
  module V1
    class ProjectsController < Neighborly::Api::BaseController
      def index
        online_projects = Project.with_state('online')
        render json: online_projects
      end

      def destroy
        project = Project.find(params[:id])
        authorize project

        project.push_to_trash!
        head :no_content
      end

      [:approve, :launch, :reject, :push_to_draft].each do |name|
        define_method name do
          project = Project.find(params[:id])
          authorize project

          project.send("#{name.to_s}!")
          head :no_content
        end
      end
    end
  end
end
