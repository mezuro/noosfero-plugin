var processingTree = false;
var metricName;
var displayed_charts = [];
var moduleResults =  null;

jQuery(function (){
  jQuery('.source-tree-link').live("click", reloadModule);
  jQuery('[show-metric-history]').live("click", display_metric_history);
  jQuery('[show-grade-history]').live("click", display_grade_history);
  jQuery('#project_date_submit').live("click", reloadProcessingWithDate);
  showLoadingProcess(true);
  showProcessing();
});

function callAction(controller, action, params, callback){
  var profile = processingData('profile');
  var content = processingData('content');
  var endpoint = '/profile/' + profile + '/plugin/mezuro/' + controller + '/' + action + '/' + content;
  jQuery.get(endpoint, params, callback);
}

function showProcessing() {
  repository_id = processingData('repository-id');
  callAction('processing', 'state', {repository_id: repository_id}, showProcessingFor);
}

function display_metric_history() {
  var nTr = this.parentNode.parentNode; //gets the clicked TR
  var trIndex = jQuery.inArray( nTr, displayed_charts );
  var module_result_id = jQuery(this).attr('data-module-id');
  var formatted_name = jQuery(this).attr('show-metric-history');
  var metric_name = jQuery(this).attr('data-metric-name');

  if ( trIndex === -1 ) {//The element was not found in the displayed_charts Array
    moduleResults.fnOpen( nTr, function() {}, 'metric_history_'+formatted_name ); // So we create a new row after the clicked one
    displayed_charts.push( nTr ); // Finally we add it to the Array!
  }
  else { //Otherwise, we remove the row
    moduleResults.fnClose( nTr );
    displayed_charts.splice( trIndex, 1 );
  }

  metricName = formatted_name;
  jQuery('.metric_history_' + metricName).html("<img src='/images/loading-small.gif'/>");
  callAction('module_result', 'metric_result_history', {metric_name: metric_name, module_result_id: module_result_id}, show_metrics);

  return false;
}

function display_grade_history() {
  var module_result_id = jQuery(this).attr('data-module-id');
  toggle_mezuro("#historical-grade");
  callAction('module_result', 'module_result_history', {module_result_id: module_result_id}, show_grades);
  return false;
}

function show_metrics(content) {
  jQuery('.metric_history_' + metricName).html(content);
}

function show_grades(content) {
  jQuery('#historical-grade').html(content);
}

function toggle_mezuro(element){
  jQuery(element).toggle();
}

function reloadModule(){
  var module_result_id = jQuery(this).attr('data-module-id');
  showLoadingProcess(false);
  processingTree = true;
  callAction('module_result', 'module_result', {module_result_id: module_result_id}, showModuleResult);
  return false;
}

function reloadProcessingWithDate(date){
	reloadProcessing(date + "T00:00:00+00:00");
  return false;
}

function reloadProcessing(date){
  repository_id = processingData('repository-id');
  showLoadingProcess(true);
  callAction('processing', 'processing', {date: date, repository_id: repository_id}, processingCallback);
}

function processingCallback(content){
  showReadyProcessing(content);
  var module_result_id = jQuery("#module_result_root_id").attr('module_result_root_id');
  callAction('module_result', 'module_result', {module_result_id: module_result_id}, showModuleResult);
}

function showProcessingFor(state){
  repository_id = processingData('repository-id');
  if (state == 'ERROR') {
    jQuery('#processing-state').html('<div style="color:Red">ERROR</div>');
    callAction('processing', 'processing', {repository_id: repository_id}, showReadyProcessing);
    showModuleResult('');
  }
  else if (state == 'READY') {
    jQuery('#msg-time').html('');
    jQuery('#processing-state').html('<div style="color:Green">READY</div>');
    callAction('processing', 'processing', {repository_id: repository_id}, processingCallback);
  }
  else if (state.endsWith("ING")) {
    jQuery('#processing-state').html('<div style="color:DarkGoldenRod">'+ state +'</div>');
    jQuery('#msg-time').html("The project analysis may take long. <br/> You'll receive an e-mail when it's ready!");
    showProcessingAfter(2);
  }
}

function showProcessingAfter(seconds){
  if (seconds > 0){
    setTimeout(function() { showProcessingAfter(seconds - 1);}, 1000);
  } else {
    showProcessing();
  }
}

function showReadyProcessing(content) {
  jQuery('#processing').html(content);
}

function showModuleResult(content){
    jQuery('div#module-result').html(content);
    moduleResults = jQuery('table#module-result').dataTable({"sDom" : "ft", "iDisplayLength" : -1}); //{"sDom" : "tf", "iDisplayLength" : -1} shows just the table and the filtering and removes the row limit
}

function processingData(data){
  return jQuery('#processing').attr('data-' + data);
}

function showLoadingProcess(firstLoad){
	if(firstLoad)
  	showReadyProcessing("<img src='/images/loading-small.gif'/>");
  showModuleResult("<img src='/images/loading-small.gif'/>");
}

function sourceNodeToggle(id){
  var suffixes = ['_hidden', '_plus', '_minus'];
  for (var i in suffixes)
    jQuery('#' + id + suffixes[i]).toggle();
}
