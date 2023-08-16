class AppUrl {
  // DOMAIN URL LOCAL & LIVE
  // static var baseUrl = 'http://192.168.1.7/l9/active+/';

  static var baseUrl = 'https://active-plus.vingreentech.com/';

  // Login Url
  static var loginEndPoint = '${baseUrl}api/login';
  static var passwordChangeEndPoint = '${baseUrl}api/password_update';

  // Notification Server Key
  static var firebaseAppKeyEndPoint = '${baseUrl}api/add_server_key';

  // Home Page Urls
  static var userDetailsEndPoint = '${baseUrl}api/user_list';
  static var currentDayStatusEndPoint = '${baseUrl}api/checkin_status';
  static var attendanceStatusEndPoint = '${baseUrl}api/attendance_status';
  static var countEndPoint = '${baseUrl}api/dashboard_counts';
  static var attendanceListEndPoint = '${baseUrl}api/attendance_list';
  static var checkinEndPoint = '${baseUrl}api/check_in';
  static var checkoutEndPoint = '${baseUrl}api/check_out';

  // Profile Page Urls
  static var userProfileEndPoint = '${baseUrl}api/user_list';
  static var userProfileUpdateEndPoint = '${baseUrl}api/user_edits';
  static var userImageUpdateEndPoint = '${baseUrl}api/user_profile_edits';

  // static var get_client = 'api/clients_list';

  // Task Page Urls
  static var taskListEndPoint = '${baseUrl}api/task_list';
  static var taskListFilterEndPoint = '${baseUrl}api/task_filter';
  static var taskDetailsEndPoint = '${baseUrl}api/task_update';
  static var taskEditEndPoint = '${baseUrl}api/task_update';
  static var taskSubmitEndPoint = '${baseUrl}api/task_update_submit';
  static var addNewTaskEndPoint = '${baseUrl}api/get_task_select_values';
  static var addNewTaskSubmitEndPoint = '${baseUrl}api/task_add';
  static var taskFilterListEndPoint = '${baseUrl}api/task_list';

  // Lead Page Urls
  static var leadListEndPoint = '${baseUrl}api/lead_list';
  static var leadListFilterEndPoint = '${baseUrl}api/lead_filter';
  static var leadDetailsEndPoint = '${baseUrl}api/lead_details';
  static var leadEditEndPoint = '${baseUrl}api/lead_edit';
  static var leadUpdateEndPoint = '${baseUrl}api/lead_update';
  static var leadFilterListEndPoint = '${baseUrl}api/lead_list';
  static var leadTimelineAddEndPoint = '${baseUrl}api/timeline_add';
  static var leadCommunicationMediumEndPoint =
      '${baseUrl}api/get_communication_medium';
  static var leadCommunicationTypeEndPoint =
      '${baseUrl}api/get_communication_type';

  static var subStageEndPoint = '${baseUrl}api/get_lead_sub_stage';
  static var productsEndPoint = '${baseUrl}api/get_products';
  static var statesEndPoint = '${baseUrl}api/get_states';
  static var citiesEndPoint = '${baseUrl}api/get_cities';

  // Ticket Page Urls
  static var ticketListEndPoint = '${baseUrl}api/ticket_lists';
  static var ticketDetailsEndPoint = '${baseUrl}api/ticket_view';
  static var ticketUpdateEndPoint = '${baseUrl}api/ticket_view';
  static var ticketUpdateSubmitEndPoint = '${baseUrl}api/ticket_update_submit';
  static var ticketEditEndPoint = '${baseUrl}api/get_ticket_select_values';
  static var ticketSubmitEndPoint = '${baseUrl}api/ticket_add';
  static var ticketFilterListEndPoint = '${baseUrl}api/ticket_filter';

  // Petty Cash Page Urls
  static var pettyCashListEndPoint = '${baseUrl}api/pettycash_expense_list';
  static var pettyCashSubmitEndPoint = '${baseUrl}api/expense_add';
  static var pettyCashEditListEndPoint = '${baseUrl}api/pettycash_expense_list';
  static var pettyCashEditSubmitEndPoint = '${baseUrl}api/expense_edit';
  static var pettyCashDeleteEndPoint = '${baseUrl}api/expense_delete';

// Quotation Page Urls

  static var quotationListEndPoint = '${baseUrl}api/quotation_list';
  static var quotationAddSubmitEndPoint = '${baseUrl}api/quote_add';
  static var quotationEditDetailEndPoint = '${baseUrl}api/get_quote';
  static var quotationEditSubmitEndPoint = '${baseUrl}api/quote_edit';

// Invoice Page Urls

  static var invoiceListEndPoint = '${baseUrl}api/invoice_list';
  static var invoiceAddSubmitEndPoint = '${baseUrl}api/invoice_add';
  static var invoiceEditEndPoint = '${baseUrl}api/get_invoice';
  static var invoiceEditSubmitEndPoint = '${baseUrl}api/invoice_edit';

// Proforma Invoice Page Urls

  static var proformaListEndPoint = '${baseUrl}api/proforma_invoice_list';
  static var proformaInvoiceAddSubmitEndPoint =
      '${baseUrl}api/proforma_invoice_add';
  static var proformaInvoiceEditEndPoint = '${baseUrl}api/get_proforma_invoice';
  static var proformaInvoiceEditSubmitEndPoint =
      '${baseUrl}api/proforma_invoice_edit';
}
