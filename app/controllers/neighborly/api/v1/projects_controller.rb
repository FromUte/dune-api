module Neighborly::Api
  module V1
    class ProjectsController < Neighborly::Api::BaseController
      def index
        online_projects = Project.with_state('online')
        render json: online_projects
      end

      def update
        @project = Project.find(params[:id])
        authorize @project
        respond_with Project.update(params[:id], permitted_params)
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

      private

      def permitted_params
        params.permit(policy(@project || Project).permitted_attributes)[:project]
      end
    end
  end
end
