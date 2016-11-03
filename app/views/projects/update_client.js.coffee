$("#project_client_id").empty().append("<%= escape_javascript(options_for_select(@clients.collect { |c|[c.name.titleize, c.id] }, params[:client_id])) %>")
$('#project_client_id').trigger("chosen:updated");

