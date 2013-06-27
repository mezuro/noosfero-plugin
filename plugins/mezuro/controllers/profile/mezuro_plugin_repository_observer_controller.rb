# NOTE: In model, the equivalent class is ProcssingObserver, but we changed
# since it will soon be like this.
class MezuroPluginRepositoryObserverController < MezuroPluginProfileController

  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  def new
    @repository_id = params[:repository_id]
    @project_content = profile.articles.find(params[:id])
  end

  def save
    project_content = profile.articles.find(params[:id])
    repository_id = params[:repository_observer][:repository_id]
    repository_observer = Kalibro::ProcessingObserver.new({
      :name => params[:repository_observer][:name],
      :email => params[:repository_observer][:email],
      :repository_id => repository_id
    })

    if( repository_observer.save )
      redirect_to project_content.view_url
    else
      # FIXME
      message = URI.escape(CGI.escape(repository_observer.errors[0].message),'.')
      redirect_to project_content.view_url
      #redirect_to_error_page repository_observer.errors[0].message
      #redirect_to project_content.view_url
    end
  end

  private

end
