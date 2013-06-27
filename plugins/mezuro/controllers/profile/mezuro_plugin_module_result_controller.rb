class MezuroPluginModuleResultController < MezuroPluginProfileController

  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  def module_result
    @module_result = Kalibro::ModuleResult.find(params[:module_result_id].to_i)
    @metric_results = Kalibro::MetricResult.metric_results_of(@module_result.id)
    @metric_id = params[:metric_id]
    render :partial => 'module_result'
  end

  def metric_result_history
    @history = Kalibro::MetricResult.history_of(params[:metric_name], params[:module_result_id].to_i)
    @div_id = "metric-chart-"+params[:metric_id]
    render :partial => 'score_history'
  end

  def module_result_history
    @history = Kalibro::ModuleResult.history_of(params[:module_result_id].to_i)
    @div_id = "grade-chart"
    render :partial => 'score_history'
  end

end
