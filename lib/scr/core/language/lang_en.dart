import 'package:b2b/scr/core/language/en/bill_checker.dart';
import 'package:b2b/scr/core/language/en/card_history.dart';
import 'package:b2b/scr/core/language/en/card_info.dart';
import 'package:b2b/scr/core/language/en/commerce.dart';
import 'package:b2b/scr/core/language/en/loan.dart';
import 'package:b2b/scr/core/language/en/payroll.dart';
import 'package:b2b/scr/core/language/en/tax_manage.dart';
import 'package:b2b/scr/core/language/en/transaction_status.dart';

import 'en/electric.dart';

const Map<String, String> en_US = {
// intro
  'page_1': 'Chào mừng đến với VPBank NEOBiz',
  'page_2': 'Chúng tôi giúp bạn kết nối \ntới mọi dịch vụ ở VPBank',
  'page_3': 'Chúng tôi sẽ chỉ cho bạn mua sắm dễ dàng. \nHãy ở nhà với chúng tôi.',
  'page_4': 'Sẵn sàng chạm tới mọi thứ nào.',

  'change_lang': 'Change language',
  'author_biometric': 'Verify',

  'continue': 'Continue',

//Bottom Tabbar
  'tab_home': 'Home',
  'tab_transaction': 'Inquiry',
  'tab_notification': 'Notifications',
  'tab_more': 'Settings',

// utilities
  'bank_default': 'Beneficiary Bank',
  'having_an_error': 'Processing Error, please try again later!',
  'wrong_format_input': 'Wrong format inputted',
  'having_wrong_connect_internet': 'Connection Error, Please check network activity and retry',

// account manage screen
  'account_manage_title_login': 'SIGN IN',
  'account_manage_title_header': 'Select user account',
  'account_manage_title_done': 'DONE',
  'account_manage_title_login_account_other': 'SIGN IN NEW ACCOUNT',
  'account_manage_title_active_otp': 'Smart OTP account is not active on this device. Please sign in and active',
  'account_mange_title_opt_not_available': 'Smart OTP is not available for this account',
  'account_mange_title_active_login_with_pin': 'Are you sure to de-active sign in PIN code method?',
  'account_mange_title_not_active_pin': 'Your PIN code is not setup',

  // biometric screen
  'biometric_button_try_again': 'TRY AGAIN',
  'biometric_title_sinh_trac_hoc': 'Biometrics authentication',
  'biometric_title_setting_sinh_trac_hoc': 'Do you want setup biometric authentication?',
  'biometric_title_use_sinh_trac_hoc': ' USE BIOMETRIC',
  'biometric_title_not_use_sinh_trac_hoc': 'Do not use biometric ',
  'biometric_title_cancel': 'Cancel',
  'biometric_title_setting': 'Settings',
  'biometric_title_setting_face_ID': 'Please setup Face ID method',
  'biometric_title_out_try_again': 'Run out of failed attempts',
  'biometric_message_use_face_ID': 'Please use Face ID to authenticate',
  'biometric_title_setup_face_ID': 'Setup Face ID',
  'biometric_title_use_face_ID': 'USE FACE ID',
  'biometric_title_not_use_face_ID': 'Do not use Face ID',
  'biometric_title_question_setup_face_ID': 'Do you want setup Face ID?',
  'biometric_title_not_confirm_face_ID': 'Face not recognized',
  'biometric_title_setting_touch_ID': 'Please setup Touch ID method',
  'biometric_message_use_touch_ID': 'Please use TouchID to authenticate',
  'biometric_title_setup_touch_ID': 'Setup Touch ID',
  'biometric_title_use_touch_ID': 'USE TOUCH ID',
  'biometric_title_not_use_touch_ID': 'Do not use Touch ID',
  'biometric_title_question_setup_touch_ID': 'Do you want setup Touch ID?',
  'biometric_title_not_confirm_touch_ID': 'Touch not recognized',
  'biometric_message_setting_fingerprint': 'Please setup fingerprint to use biometric authentication',
  'biometric_message_setting': 'Please use biometric to authenticate',
  'biometric_title_setup_fingerprint': 'Setup fingerprint',
  'biometric_title_use_fingerprint': 'USE FINGERPRINT',
  'biometric_title_not_use_fingerprint': 'Do not use fingerprint',
  'biometric_question_use_fingerprint': 'Do you want setup fingerprint?',
  'biometric_not_confirm_fingerprint': 'Fingerprint not recognized',

  // First login screen
  'first_login_title_add_account': 'Sign in new account',
  'first_login_title_username': 'Username',
  'first_login_title_password': 'Password',
  'first_login_title_help': 'Support',
  'first_login_title_exchange_rate': 'Exchange Rate',
  'first_login_title_onboard_online': 'Open account online',
  'first_login_title_interest_rate': 'Interest Rate',
  'dialog_message_input_username': 'Please enter a valid Username',

  // otp_screen
  'otp_title_out_of_time_get_otp': 'OTP code is expired.\nClick on resend',
  'otp_message_confirm': 'Authentication Completed',
  'otp_send_again': 'Resend request completed',
  'otp_confirm_information': 'Confirm Information',
  'otp_title_input_otp': 'Request OTP code',
  'otp_title_get_again': 'Resend OTP',
  'otp_title_get_activation_code_again': 'Resend activation code',
  'otp_title_input_otp_activation_code': 'Please enter activation code',
  'sotp_activation_title': 'Smart OTP activation',
  'otp_inactive':
      'Smart OTP is not active on this device. Please activate Smart OTP to authorize finance transaction on VPBank NEOBiz',
  'sotp_not_active_dialog_title': 'Register Smart OTP',
  'sotp_not_active_dialog_content':
      '''Please active <font style='color: #00B74F; font-weight: bold'>VPBank Smart OTP</font> to authorize finance transaction on this device''',
  'sotp_activated_dialog_title': 'Registration Smart OTP Completed',
  'sotp_activated_dialog_content':
      '''Successfully activated <font style='color: #00B74F; font-weight: bold'>VPBank Smart OTP</font> has been activated successfully in this device.''',
  'sotp_activated_other_device_dialog_content':
      '''<font style='color: #00B74F; font-weight: bold'>VPBank Smart OTP</font> account activated by other device, please re-activate account on this device to authorize finance transaction''',

  // pin_screen
  'pin_title_confirm': 'Confirm',
  'pin_title_setup': 'Setup PIN code',
  'pin_title_setup_otp': 'Setup Smart OTP PIN code',
  'pin_title_confirm_app': 'Confirm PIN',
  'pin_title_confirm_otp': 'Confirm PIN',
  'pin_message_input_use_app': 'Please enter PIN code',
  'pin_message_input_use_app_old': 'Please enter old PIN code',
  'pin_message_input_use_OTP': 'Please enter Smart OTP PIN code',
  'pin_message_input_use_OTP_old': 'Please enter old Smart OTP PIN code',
  'pin_message_setup_pin_and_next': 'Please setup PIN code',
  'pin_message_setup_again': 'Please re-enter PIN code',
  'pin_title_not_use': 'Do not use PIN code',
  'pin_message_not_duplicate': 'PIN code does not match',
  'pin_message_incorrect': 'Incorrect PIN code. Remaining time',
  'pin_message_turn': 'left',

  // re_login_screen
  're_login_login_with_account_other': 'Sign-in with another account',
  're_login_service_account': 'Account Service',
  're_login_transaction_management': 'Trans. \nManagement',

  // beneficiary_screen
  'beneficiary_title_header': 'Beneficiary list',
  'beneficiary_title_find_bank': 'Term Deposit',

  // home_action_manager
  'home_action_message_have_selected_7': '%number Items Selected',

  // home_screen
  'home_title_customer': 'Customer',
  'home_button_logout': 'SIGN OUT',
  'home_title_well_come': 'Hi, ',
  'home_title_transfer_money': 'Transfer',
  'home_title_payroll': 'Single Payroll',
  'home_title_account': 'Account',
  'home_title_transaction_management': 'Trans. Management',
  'home_title_term_header': 'Term and conditions',
  'home_title_item_other': 'More',
  'home_title_feedback': 'Feedback',

  // list_second_home_screen
  'list_second_title_setup': 'Settings',
  'list_second_title_save': 'Save',
  'list_second_message_save_success': 'Change Success!',
  'list_second_message_selected_7': 'Requirement %number Items Selected',
  'list_second_title_utilities_list': 'Utilities List',

  // profile screen
  'profile_title_header': 'User Profile',
  'profile_title_business_information': 'Company information',
  'profile_title_customer_name': 'Customer name',
  'profile_title_customer_code': 'Customer ID',
  'profile_title_customer_address': 'Address',
  'profile_title_customer_service_package': 'Service Packages',
  'profile_title_customer_credit_limit': 'Credit limit',
  'profile_title_information': 'Personal Information',
  'profile_title_full_name': 'Full name',
  'profile_title_ID_Passport_number': 'ID/Passport',
  'profile_title_account_information': 'Account information',
  'profile_title_otp_method_receiving': 'Default OTP method',
  'profile_title_otp_phone_number_receiving': 'Phone No receiving OTP',
  'profile_title_otp_email_receiving': 'Email receiving OTP',
  'profile_title_role': 'User role',
  'profile_title_last_login': 'Last logged in time',
  'profile_title_logout': 'Sign Out',

  // saving_screen
  'saving_title_call_program': 'TERM DEPOSIT TYPE',
  'saving_title_term_deposit_online': 'Online term deposit',
  'saving_title_method_of_receiving_interest': 'Interest payment',
  'saving_title_period': 'Tenor',
  'saving_title_interest_rate': 'Interest rate(%/year)',
  'saving_title_text_feet_1': 'Interest rate for SMEs.',
  'saving_title_text_feet_2': 'Interest amount is based on actual basic A/365',
  'saving_title_text_feet_3': 'Please contact the nearest branch to get details about other interest rates.',

  // list_otp_intro
  'otp_intro_model_1':
      'An Application to create a One-Time Password (OTP) in compliance with mandatory regulations of the SBV for online banking transactions.',
  'otp_intro_model_2': 'OTP is encrypted as being sent to customer’s device.',
  'otp_intro_model_3': 'Customers need to provide PIN/Face ID/ Touch ID to get One-Time Password (OTP).',
  'otp_intro_model_4':
      'Operation With Smart OTP, internet connection or data roaming is not required to do transactions.',

  // smart_otp_intro_screen
  'smart_otp_intro_title_start_use': 'Start',

  // smart_otp_screen
  'smart_otp_code': 'OTP',
  'smart_otp_auto_update_later': 'Auto update after',
  'smart_otp_minus': 'seconds',
  'smart_otp_approval_code': 'Authorisation Ref:',
  'smart_otp_message_warning': '''<font style="color: red; font-weight: 500">Warning:</font></div></br>
      <font color="gray" style="line-height: 16pt">Do not provide OTP code to anyone in any situation even bankers or policeman to avoid <font style="font-weight:500">LOSING MONEY!</font></font>''',
  'smart_otp_normal': 'Basic',
  'smart_otp_advanced': 'Advanced',
  'sotp_active':
      '''<div style="line-height: 18pt; font-size: 12pt"><strong style="font-weight: 600; font-size:13pt"> Instructions to activate VPBank Smart OTP</strong><br/>
          <font style="color: green; font-weight: 600; font-size: 12pt">Step 1:</font> Activation code of VPBank Smart OTP will be sent via SMS or email registration<br>
<font style="color: green; font-weight: 600; font-size: 12pt">Step 2:</font> Enter activation code to activate the services</div>''',

  // term screen
  'term_title_confirm': 'AGREE',
  'title_confirm': 'AGREE',

  // transfer_to_account_screen
  'transfer_to_account_title_goto_account_number': 'Transfer to account',
  'transfer_to_account_number': ' To Account',
  'transfer_to_card_number': 'To Card',
  'transfer_to_account_title_source_account': 'Debit account',
  'transfer_to_account_title_beneficiary_information': 'Beneficiary details',
  'transfer_input': 'Fast transfer 247',

  //transfer_screen
  'transfer_title_choose_transfer_method': 'Choose payment method',
  'description_transfer': 'Payment details',
  'can_not_find_account': 'Invalid Account',

  // find_atm_screen
  'find_atm_title_direction': 'Directions',
  'find_atm_title_branch': 'Branch',
  'find_atm_title_atm_machine': 'ATM',
  'find_atm_title_atm_deposit': 'CDM',
  'find_atm_title_transaction_branch': 'Branches',

  // container_item
  'container_item_continue': 'Continue',

  // data_hard_core
  'data_hard_core_bank': 'Beneficiary bank',
  'data_hard_core_count_money': 'Amount',
  'data_hard_core_note': 'Note(optional)',
  'data_hard_core_start_date': 'Start date',
  'data_hard_core_frequency': 'Frequency',
  'data_hard_core_card': 'Card',
  'data_hard_core_loan': 'Loan',
  'data_hard_core_commerce': 'Trade Finance',
  'data_hard_core_guarantee': 'Guarantee',
  'data_hard_core_ld': 'LC & Collection',
  'data_hard_core_discount': 'Negotiating',
  'data_hard_core_transfer_money_vpbank': 'Internal transfer',
  'data_hard_core_transfer_247': 'Fast transfer 247',
  'data_hard_core_interbank_money_transfer': 'Domestic transfer',

  // language
  'title_select_language': 'Select language',
  'title_language_vi': 'Vietnamese',
  'title_language_en': 'English',

  // dialog
  'dialog_title_delete': 'Remove user account?',
  'dialog_message_delete': 'Are you sure to remove this user account?',
  'dialog_button_skip': 'Skip',
  'dialog_button_cancel': 'CANCEL',
  'dialog_button_delete': 'Remove',
  'dialog_button_close': 'CLOSED',
  'dialog_message_system_is_maintenance': 'Apologize for the disturbance. Thanks!',
  'dialog_title_system_is_maintenance': 'System under maintenance',
  'dialog_title_notification': 'Notice',
  'dialog_login_with_pin': 'Sign in by PIN code activated by other device.',
  'dialog_login_with_touch_ID': 'Sign in by touch ID activated by other device.',
  'dialog_login_with_face_ID': 'Sign in by face ID activated by other device.',
  'dialog_message_login_fail': 'Sign in failed. Please check network activity and retry',
  'dialog_message_login_session_expired': 'Your session has expired. Please sign in again.',
  'dialog_title_forgot_password': 'Forgot Password?',
  'dialog_message_forgot_password':
      'Call our customer service representative <b style="color: #00b74f">1900545415</b> for service request',
  'dialog_message_input_password': 'Please enter a valid password',
  'dialog_message_ask_logout': 'Are you sure you want to sign out VPBank NEOBiz?',

  //transfer
  'beneficiary_info': 'Beneficiary details',
  'account_number': 'Account number',
  'beneficiary_name': 'Beneficiary name',
  'receive_name': 'Receive name',
  'save_beneficiary': 'Save beneficiary',
  'save_remember_name': 'Alias name',
  'transfer_amount': 'Amount',
  'transfer_content': 'Payment details',
  'fee_account': 'Charge Account',
  'to_account_number': 'To Account',
  'to_card_number': 'To Card',
  'enter_amount': 'Enter amount',
  'enter_info': 'Payment description',
  'card_number': 'Card number',
  'the_money_must_be_bigger_than_zero': 'Amount greater than 0',
  'account_number_sekleton': 'ACC - %number',
  'choose_source_account': 'Select debit account',
  'free_amount': 'Free of charge',
  'number_of_money': 'Amount in words',
  'fee_type': 'Charge type',
  'fee_amount': 'Charge amount',
  'content': 'Payment details',
  'time': 'Created',
  'wait_approve': 'Pending approval',
  'back': 'Back',
  'send': 'Send',

  //Search
  'pick_bank': 'Choose beneficiary bank',
  'pick_bank_place': 'Province/City',
  'pick_beneficiary': 'Beneficiary',

  //Account Service
  'as_requset_send_statement_success': 'Statement request completed',
  'as_back_to_list_account': 'Back to the Account List',
  'as_list_account': 'Account List',
  'as_period': 'Time period',
  'as_for_amount': 'Amount',
  'as_for_content_transaction': 'Payment details',
  'as_input_content_transaction': 'Enter payment details',
  'as_file_format': 'Format of statement ',
  'as_choose_time_transaction': 'Select a time period to have a maximum of 1,000 transactions/ 1 statement',
  'as_list_result': 'Result List',
  'as_send_statement': 'Send request',
  'as_list_transaction': 'Transaction List',
  'as_send_statement_email': 'Statement via email',
  'as_fill_full_time_search': 'Please select from time to time in Time period',
  'as_find_time_invalid': 'Invalid time range. The start date cannot be greater than the end date',
  'as_find_time_invalid_new': 'Invaid time range. The start date cannot be greater than the end date',
  'as_find_time_out_of_date': 'List of transactions is limited within %mouth months from today',
  'transaction_information': 'Transaction detail',
  'transaction_list': 'Transaction List',
  'account_tools': 'Account management tools',
  'online_statement': 'Account statement',
  'send_email_offline_statement': 'Statement via email',
  'as_surplus': 'Ledger balance',
  'as_available_balances': 'Available balance',
  'as_id_number': 'Business registration number',
  'title_address': 'Address',
  'title_account_type': 'Types of account',
  'title_open_branch': 'Branch',
  'title_open_date': 'Open date',
  'title_error_no_data': 'Record not found',
  'title_beneficiary_name': 'Beneficiary name',
  'title_out_of_request_transaction':
      'Over the limitation of transaction display, kindly use Statement via email tools to resume your service',
  'title_deposits': 'Deposit amount',
  'title_open_expried_date': 'Effective date',
  'title_expried_date': 'Expired date',
  'title_due_information': 'Settlement method',
  'title_finalization_account': 'Settlement account',
  'title_type_deposits': 'Deposit type',
  'title_deposits_branch': 'Branch',
  'title_balance_fluctuations_content': 'Amount / Payment details',
  'title_balance_after_transactions': 'Available balance',

  // Bottom sheet
  'one_week': '1 week',
  'two_week': '2 weeks',
  'one_mouth': '1 month',
  'elective': 'Custom',

  // Exchange rate screen
  'ers_exchange_header': 'Converter',
  'ers_exchange_convert': 'Convert',
  'ers_exchange_from_currency': 'From',
  'ers_exchange_to_currency': 'To',
  'ers_exchange_rate_info': 'Exchange Rate',
  'ers_exchange_currency_list_title': 'Currency',
  'ers_exchange_currency_list_header_name': 'Currency',
  'ers_exchange_currency_list_header_buy': 'Buying rate',
  'ers_exchange_currency_list_header_sell': 'Selling rate',
  'ers_exchange_info': 'The exchange rates are for indicative purpose only',

  //URL
  'url_otp_term': 'https://vpbankonline.vpbank.com.vn/tnc-vpbank-smart-otp-en/',

  'charge_account': 'Charge Account',
  'transfer_cost': 'All charge to remitter %vat',
  'paid_recipients': 'All charge to beneficiary %vat',
  'enter_card_number': 'Enter Card No',
  'enter_account_number': 'Enter Account No',

  // Settings screen
  'sts_screen_title': 'Settings',
  'sts_feedback_title': 'Give us feedback',
  'sts_login_faceid': 'Sign in using FaceID',
  'sts_login_finger': 'Sign in using fingerprint',
  'sts_login_pin': 'Sign in using PIN',
  'sts_login_pin_change': 'Change PIN',
  'sts_password_change': 'Change Password',
  'sts_otp_method': 'OTP method',
  'sts_smart_otp': 'Smart OTP',
  'sts_sotp_change_pin': 'Change Smart OTP PIN',
  'sts_sotp_reset': 'Re-active Smart OTP',
  'sts_sotp_resync': 'Synchronization Smart OTP',
  'sts_sotp_resynced': 'Synchronization is completed!',
  'sts_sotp_toc': 'Terms and condition Smart OTP',
  'sts_notification': 'Notifications',
  'sts_notification_balance_preview': 'Previewing balance change',
  'sts_notification_balance_preview_desc': '''<p style="line-height: 16pt; font-size: 13pt; color: #666667;">
      <font>When the feature is turned on, you can see the previewing balance change notice without sign in<br>
      <font color="#ff6863">Note: The risk of disclosing personal transaction information</font></font></p>''',
  'sts_notification_transaction': 'Accounts receive notification',
  'sts_notification_transaction_pending': 'Waiting for approval',
  'sts_notification_transaction_step1': 'Waiting for confirmation',
  'sts_notification_transaction_waiting': 'Waiting for confirmation',
  'sts_notification_transaction_error': 'Failed',
  'sts_notification_other': 'Other',
  'sts_notification_other_desc': 'Promotion, VPBank messages',

  //Notification
  "notification": "Notifications",
  "all": "All",
  "balance_change": "Balance alert",
  "transaction_pending": "Payment pending",
  "end_dow": "Promotion",
  // 'message_content_noti' : 'Account %account, có biến động số dư %balance, với nội dung: %content',
  'message_content_noti':
      '''<div style="line-height: 18pt; font-size: 16pt">Account <strong style="font-weight: 600; font-size:16pt">%account</strong>
          <br>%title <strong style="font-weight: 600; font-size:16pt;color:%color">%balance</strong>, content: %content</div>''',

  'message_bill_noti':
  '''<div style="line-height: 18pt; font-size: 16pt">Account <strong style="font-weight: 600; font-size:16pt">%account</strong>
          <br>%title <strong style="font-weight: 600; font-size:16pt;color:%color">%balance</strong> / Transaction type: bill payment</div>''',
  // Change OTP Method screen
  'cotps_screen_title': 'OTP method',
  'cotps_sms': 'Via SMS',
  'cotps_sms_desc': 'Send to phone number',
  'cotps_email': 'Via Email',
  'cotps_email_desc': 'Send to email',
  'cotps_sotp': 'Smart OTP',
  'cotps_confirm': 'Confirm',

  // Change password screen
  'cpws_screen_title': 'Change password',
  'cpws_old_password': 'Current password',
  'cpws_new_password': 'New password',
  'cpws_new_password_repeat': 'Confirm new password',
  'cpws_confirm': 'Change password',

  // Transaction query screen
  'tqs_screen_title': 'Transaction history',
  'tqs_find_by_transaction': 'Inquiry by transaction',
  'tqs_transaction_id': 'Payment ID',
  'tqs_input_transaction_id': 'Enter payment ID',
  'tqs_journal_entry': 'Reference No',
  'tqs_input_journal_entry': 'Enter reference No',
  'tqs_time_range': ' Inquiry by time',
  'tqs_find_by_time_range': 'Time period',
  'tqs_from_date': 'From',
  'tqs_to_date': 'To',
  'tqs_find_by_amount': 'Inquiry by amount',
  'tqs_from_amount': 'From',
  'tqs_to_amount': 'To',
  'tqs_input_amount': 'Enter amount',
  'tqs_amount_currency': 'Currency',
  'tqs_find_by_memo': 'Inquiry by payment details',
  'tqs_input_memo': 'Required full payment details',
  'tqs_input_memo_content': 'Enter payment details',
  'tqs_inquiry': 'Inquiry',
  'no_ben_list': 'Record not found',

  //TransactionManager
  'transaction_management': 'Transactions',
  'selected': 'Select',
  'selected_all': 'All',
  'un_selected_all': 'Unselect',
  'close_filter': 'Closed',
  'wait_processing': 'Pending Approval',
  'ben_account': 'Beneficiary account',
  'no_city_list': 'Record not found',
  'no_branch_list': 'Record not found',
  'selected1': 'Selected',
  'transaction': 'Transaction',
  'cancel': 'Reject',
  'approve': 'Approve',
  'cancel_transaction': 'Delete',
  'invalid_from_to_amount': 'Error. To amount must greater than From account',
  'invalid_from_to_date': 'Error . The start date cannot be greater than the end date',
  'transaction_service_type': 'Transaction Type',
  'no_transaction_follow_filtter': 'Record not found',
  'no_transaction_wait_approve': 'No transaction pending for approver',
  'apply': 'Apply',
  "error_no_reason": 'Something went wrong!',
  'choose': 'Select',
  'debit_acct': 'Acc',

  // Transaction approve
  'tas_screen_title_single': 'Transaction Management',
  'tas_screen_title_multi': 'Transaction Management',
  'tas_reject_dialog_title': 'Confirm reject transactions',
  'tas_cancel_dialog_title': 'Confirm delete transactions',
  'tas_reject_dialog_message_label': 'Reason for rejection',
  'tas_reject_dialog_cancel': 'Cancel',
  'tas_reject_dialog_confirm': 'Confirm',
  'tas_rejected_toast': 'Transaction rejected',
  'tas_canceled_toast': 'Transaction deleted',

  'tas_approving_title': 'Approval process',
  'tas_cancelling_title': 'Reject process',
  'tas_approving_transaction': 'Transactions',
  'tas_approving_total_amount': 'Total amount',
  'tas_cancelling_total_amount': 'Total amount',
  'tas_approving_transaction_list_title': 'Approval transaction details',
  'tas_cancelling_transaction_list_title': 'Reject transaction details',

  'tas_action_title': '%action',
  'tas_action_total_amount': 'Total %action amount',
  'tas_action_trans_list': 'Transaction list',
  'tas_action_cancel': 'deleting',
  'tas_action_reject': 'rejecting',
  'tas_action_approve': 'approving',
  'tas_approving_transaction_detail_title': 'Transaction details',

  'tas_td_debit_account': 'Debit account',
  'tas_td_ben_info': 'Beneficiary details',
  'tas_td_ben_bank': 'Beneficiary bank',
  'tas_td_ben_city': 'Province/City',
  'tas_td_ben_branch': 'Branch',
  'tas_td_amount': 'Amount',
  'tas_td_amount_in_words': 'Amount in words',
  'tas_td_charge_account': 'Charge account',
  'tas_td_exchange_rate': 'Rate',
  'tas_td_exchange_rate_notice':
      'The official rate will be applied at the time the last Approver authorises the transaction',
  'tas_td_debit_amount': 'Debit amount',
  'tas_td_converted_amount': 'Indicative equivalent amount',
  'tas_td_charge_amount': 'Charges',
  'tas_td_memo': 'Payment details',
  'tas_td_appr_time': 'Approved time',
  'tas_td_reject_cause': 'Reason for rejection',
  'tas_reason_required': 'Please provide comment',
  'tas_td_confirm_success': 'Confirmed',
  'tas_td_success': 'Successful',

  // Transaction inquiry
  'tis_report_title': 'Transaction information',
  'tis_transaction_detail': 'Transaction details',
  'tis_accounting_entry': 'Payment ID',
  'tis_transaction_code': 'Reference No',
  'tis_debit_account': 'Debit account',
  'tis_ben_info': 'Beneficiary details',
  'tis_amount': 'Amount',
  'tis_amount_in_words': 'Amount in words',
  'tis_memo': 'Payment details',
  'tis_charge': 'Charge details',
  'tis_charge_account': 'Charge account',
  'tis_timestamp': 'Created time',
  'tis_go_back': 'BACK',
  'tis_share': 'SHARE',

  'tis_range_one_week': '1 week',
  'tis_range_two_week': '2 weeks',
  'tis_range_one_month': '1 month',
  'tis_range_custom': 'Custom',
  'tis_inquiry_error_general': 'Something went wrong. Please try again later!',
  'tis_no_result': 'Record not found!',

  'tis_balance_change': 'Amount:',
  'tis_end_of_list': 'End',
  'tis_list_screen_title': 'Transaction List',
  'tis_detail_screen_title': 'Transaction Detail',
  'tis_payroll_detail_screen_title': 'Payroll Transaction Detail',
  'tis_transaction_type': 'Transaction type:',
  'tis_tp_payroll': 'Payroll',
  'tis_tp_transfer': 'Transfer',

  // auth
  'auth_biometric_not_available': 'Biometrics authentication unavailable ',
  'auth_not_setup_biometrics': 'Biometrics authentication not setup',
  'auth_account_locked_incorrect_otp': 'Run out of OTP failed attempts, account is locked',
  'auth_biometric_login_setup_success': 'biometrics sign in method setup completed',
  'auth_pin_login_setup_success': 'PIN code sign in method setup completed',
  'auth_title_error': 'Authentication error. Try again later',

  //smart otp
  'smart_otp_error_active_code': 'Error occurs when sending the activation code. Please try again',
  'smart_otp_no_smart_otp': 'Smart OTP is not available for this account.',
  'smart_otp_active': 'Smart OTP is not active on this device. Please sign in to activate Smart OTP',
  'smart_otp_cancel_active': 'Are you sure to de-active Smart OTP account?',
  'smart_otp_use_question': 'Do you want to use SmartOTP?',
  'smart_otp_qr_code_incorrect': 'Unauthorized scanning QR Code',
  'smart_otp_verify_code': 'Authorisation Ref',
  'smart_otp_error_not_get_otp': 'Error occurs when trying to resend OTP',
  'resend_otp_success': 'Resend OTP completed',

  //Time
  'month': 'month',
  'title_gotit': 'OK, I UNDERSTOOD',
  'gotit': 'Understood',

  // transfer
  'title_bank': 'Bank',
  'title_select_city': 'Select Province/City',
  'title_select_brach': 'Select Branch',
  'title_sender': 'Remitter',
  'title_search_bank': 'Search bank',
  'title_vietnam_dong': 'Vietnamese Dong',

  // widget
  'title_note': 'Note: ',
  'title_select_date': 'Select date',
  'title_done': 'Done',
  'title_input_amount_min': 'Enter minimum value',
  'title_input_amount_max': 'Enter maximum value',
  'title_type_amount': 'Currency',
  'title_month': 'Month %month',
  'title_register': 'Register',
  'title_change_pin_success': 'Change Smart OTP PIN success',
  'title_success': 'Completed',
  'title_sync_smart_otp': 'Synchronization Smart OTP time',

  // ERROR
  'updating': 'Updating',
  'year': '%value%/year',
  'error_title_no_internet': 'No Internet connection',
  'title_cancel': 'Cancel',
  'error_title_enter_full_info': 'Please enter full details!',
  'error_title_an_unknown': 'Unknown issue occurs!',
  'error_title_change_password_success': 'Change Password completed!',
  'error_title_password_correct_format': 'Password is invalid format!',
  'error_title_password_incorrect': 'Password do not match!',
  'error_title_password':
      'New password must have\n• At least 8 characters\n• At least 1 lowercase letter (a-z)\n• At least 1 uppercase letter (A-Z)\n• At least 1 number (0-9)\n• At least 1 special character (@#\$%^&+=)\n• No consecutive characters (asdf, ASDF, 1234)\n• No whitespace',

  // validator
  'title_out_of_character': 'Exceeded the maximum of characters',
  'title_not_length_of_character': 'The minimum of characters not met',
  'title_email_format': 'The general format of an email address is @abc.def',

  'title_vat_include': ' (VAT included)',

  //==========================================================================
  //Connection
  'connection_time_out': 'Something went wrong. Please check your connection and retry!',

  //interest rate
  'other_amount': 'Any deposit amount',
  'amount0to500m': 'Deposit amount less than 500mil VND',
  'amount500mto5b': 'From 500mil VND to less than 5bil VND',
  'amountBigger5b': 'Deposit amount from 5bil VND',
  'interest_end_of_period': 'Interest paid at maturity',
  'interest_periodically': 'Periodic interest',
  'interest_prepaid': 'Interest paid in advance',
  'interest_monthly': 'Monthly period',
  'interest_quarterly': 'Quarterly period',
  'interest_every_6_months': 'Every 6 months',
  'interest_yearly': 'Yearly period',

  //confirm password
  'confirm_input_password': 'Please enter your password to continue',
  'confirm_pass_title': 'Verify Password',
  'confirm_pass_note': '''<div style="line-height: 18pt; font-size: 13pt;"><strong>Note:</strong><br>
          <font style="color: green; font-weight: 600;">- </font>Verify your change by your password<br>
          <font style="color: green; font-weight: 600;">- </font>Your account will be disabled when you enter an incorrect password 5 times</div>''',

  //notification
  'title_setting_notification': 'Notification settings',
  'title_preview': 'Preview your balance without signed-in',
  'content_preview':
      '''<div style="line-height: 18pt; font-size: 12pt"><strong style="font-weight: 600; font-size:13pt">When the feature is on, you can see the balance change notification right at the login screen</strong><br/>
          <font style="color: green; font-weight: 600; font-size: 12pt">Note:</font> This feature carries a risk of revealing transaction information</div>''',
  'title_account_get_noti': 'Account',
  'title_on_off': 'On/Off',
  'title_account': 'Accounts',
  'see_more': 'View more',
  'version': 'Version',
  'no_permission_for_feature': "You don't has permission for this feature!",
  'select_payroll_method': 'Select payroll method',
  'can_not_save': 'Can not save',
  'config': "Config",
  'sotp_remove_activation': 'Your Smart OTP has been deactivated',
  'trans_info_title': 'TRANSACTION INFORMATION',
  'trans_approve_successful': 'Selected transactions have been approved successfully',
  'trans_approve_message':
      'Transactions have been sent to bank for processing and transactions status can be viewed at Home page, Inquiry.',
  'trans_back_main': 'Back',

  'message_no_notification': 'There is no notification!',
  'title_internal_payroll': 'Internal Payroll',
  'title_domestic_payroll': 'Domestic payroll',
  'title_not_permission_setting_balance':
      'You are not abtitle_donele to view balance movement notification. Please kindly sign-in and enable previewing balance change in Settings.',
  'title_day': 'day',
  'sotp_synced_success': 'Smart OTP is synced successfully',
  'sotp_remove_all_token': 'Remove all Activated Smart OTP on this device',
  'sotp_remove_all_token_msg': 'Are you sure you want to remove all Activated Smart OTP on this device?',
  'sotp_remove_all_token_success_msg': 'Remove all token successful.',
  'title_future_develop': 'This feature is developing',
  'sotp_account_disable':
      'Your Smart OTP has been disabled because of entering an invalid PIN code many times. Please re-activate to use!',
  'feedback_message': 'To improve VPBank NEOBiz, we need some feedback. Join the survey now?',
  'title_wai_confirm': 'Pending',
  'login_to_see_notify': '%message. You need login account %account to see details',
  'see': 'Show',
  'retry': 'Retry',

// Current deposits
  'cds_title': 'EXISTING TERM DEPOSIT',
  'cds_filter': 'Filter',
  'cds_online_deposits': 'Online deposit',
  'cds_offline_deposits': 'Offline deposit',
// Current deposits - Detail
  'cdds_title': 'Transaction Details',
  'cdds_account': 'Debit account',
  'cdds_amount': 'Deposit amount',
  'cdds_amount_in_words': 'Amount in words',
  'cdds_period': 'Term',
  'cdds_effective_date': 'Effective date',
  'cdds_maturity_date': 'Maturity date',
  'cdds_interest_method': 'Interest payment',
  'cdds_settlement_method': 'Settlement method',
  'cdds_interest_rate': 'Listed interest rate',
  'cdds_settlement_account': 'Account for settlement',
  'cdds_referral_cif': 'Introducer’s CIF',
  'cdds_note': 'Note',
  'cdds_reject_reason': 'Reason for rejection',
  'cdds_final_settlement': 'Settle',
  'cdds_final_settlement_title': 'Deposit settlement',
  'cdds_final_settlement_confirm_title': 'Confirmation',
  'cdds_interest_in_term': 'Interest rate',
  'cdds_interest_early': 'Prematurity interest rate',
  'cdds_continue': 'Continue',
  'cdds_saving_notice': '''
<span>Note:</span> Value date, maturity date, interest rate depend on approved transaction date
''',
  'cdds_online_notice': '''
<span>Note:</span> If you close the online term deposit before maturity, you will receive only non-term interest rate in accordance with the VPBank policy
''',
  'cdds_offline_notice': '''
<font style="color: green; font-weight: 600; font-size: 12pt">Note:</font> If you need to close term deposit before maturity, please make the transaction at VPBank Branch
''',

  // Deposit
  'existing_deposits': 'Existing Term Deposit',
  'open_online_deposits': 'Open Online Term Deposit',
  'user_vps_deposits': 'Online Term Deposit For VPS-NĐT ',
  'user_normal_deposits': 'Online Term Deposit',
  'deposit_type': 'Deposit Type',
  'receive_interest_method': 'Interest Payment',
  'open_now': 'Open',
  'interest_value': 'Interest rate',
  'expert_profit': 'Expected interest amount',
  'deposits': 'Deposit Amount',
  'period': 'Term',
  'minimum': 'Minimum is 10 000 000 VND',
  'effective_date': 'Effective Date',
  'expiration date': 'Maturity Date',
  'evoucher_code': 'Evoucher',
  'due_processing_method': 'Settlement Method',
  'account_receive_profit': 'Account for settlement',
  'cif_refer': 'Introducer\'s CIF',
  'not_require': 'Optional',
  'enter_evoucher': 'Input Evoucher',
  'note': 'Note: ',
  'deposits_term_1': 'By clicking "Continue" button, you agree to ',
  'trading_condition': 'Term & Conditions',
  'deposits_term_2': 'of VPBank\'s online term deposit serivce',
  'select_period': 'Select Term',
  'note_confirm_deposits': 'Value date, maturity date, interest rate depend on approved transaction date',
  'listed_interest_rate': 'Listed interest rate',
  'profit_interest_rate': 'Preferential interest rate',
  'max_interest_rate': 'interest rate can not exceed SBV ceiling rate %rate %',
  'get_rollover_err_msg': 'Failed to get tennor',
  'notice_minimum_saving_amount': 'Minimum amount is 10 000 000 VND',

  'listed_interest': 'Listed interest rate',

  // Deposit item
  'di_amount': '''<p>%id - <span>%amount</span></p>''',
  'di_interest': 'Interest rate %r - Term: %p',
  'di_account': 'Account',
  'di_amount_detail': 'Deposit Amount',
  'sav_prod_type': 'Deposit Type',
  'sav_prod_type_az': 'Open Term Deposit ',
  'sav_prod_type_closeaz': 'Settlement',
  'sav_interest': 'Interest Rate: %i%/year',
  'sav_term': 'Term: %t',

// Transaction item
  'ti_debit_acc': 'Dr Acc',
  'ti_debit_acc_full': 'Debit account',
  'ti_saving_acc': 'SA',
  'ti_saving_acc_full': 'Saving account',
  'ti_interest_rate_value': '%i%/year',
  'ti_info_title': 'Transaction Detail %type',

// Deposit manage
  'dms_title': 'Pending Approval',
  'dms_title_open_az': 'DEPOSIT PENDING FOR APPROVAL',
  'dms_title_close_az': 'SETTLEMENT PENDING FOR APPROVAL',
  'dms_waiting_for_approval': 'Pending Approval',
  'dms_rejected': 'Rejected',
  'dms_info': 'Transaction Detail',
  'dms_reject_dialog_title': 'Notice',
  'dms_reject_dialog_content': 'Yêu cầu hủy giao dịch thành công',
  'dms_reject_dialog_button': 'Back to Term Deposit List',
  'dmcds_title': 'SUCESSFUL',
  'dmcds_back': 'Back to Transaction Management',

// Close Az screens
  'caz_info_screen_title': 'Transaction Detail',
  'caz_init_screen_title': 'Settlement',
  'caz_confirm_screen_title': 'Confirm Information',

// Filter
  'df_btn_open': 'Filter',
  'df_btn_close': 'Close',
  'df_period': 'Term',
  'df_period_dialog_title': 'Select Term',
  'df_from_amount': 'From Amount',
  'df_to_amount': 'To Amount',
  'df_from_date': 'From Date',
  'df_to_date': 'To Date',
  'df_date_range_title': 'Select Time',
  'df_clear': 'Delete',
  'df_apply': 'Apply',
  'df_no_data': 'There is no transaction',
  'df_no_data_with_filter': 'Could not find any transaction',
  // transaction category
  'tc_transfer': 'Payment',
  'tc_saving': 'Term Deposit',
  'tc_payroll': 'Payroll',
  'tc_payroll_single': 'Single Payroll',
  'tc_fx': 'FX Trans',
  'tc_bill': 'Bills',
  ...payrollEnUS,
  ...transactionStatusEnUS,
  ...cardHistoryEnUs,
  ...cardInfoEnUs,
  ...loanEnUS,
  ...taxManageEnUS,
  ...billCheckerEnUs,

  'transaction_noti_title': 'Transaction %value has been created',
  'noti_transfer_content': 'Amount: %amount %ccy/ Details: %content',
  'noti_saving_content': 'Amount: %amount %ccy/ Content: %content',
  'noti_bill_content': 'Amount: %amount %ccy/ Transaction type: bill payment',
  'skip_transaction_if_done': '(Please ignore if the transactions have been approved)',

  'see_detail': 'Detail',

  'card': 'Card',
  'card_debit': 'Debit Card',
  'card_credit': 'Credit card',
  'card_payment_credit_card': 'Pay for credit',
  'card_payment_confirm_screen_title': 'Confirmation',
  'card_payment_min': 'Min pay amount',
  'card_payment_all': 'Pay total amount',
  'account_payment': 'From account',
  'destination_card': 'To card/ contract',
  'pick_payment_card': 'Choose card to pay',
  'export_file': 'Export file',
  'card_menu': 'Card service',
  'card_payment': 'Card payment',
  'card_get_contract_info_err': 'Retrieving card information failed',

  //Tiền vay
  'loan': 'Tiền vay',
  'loan_balance': 'Dư nợ khoản vay',
  'pick_statement_card': 'Chọn thẻ cần sao kê',
  'select_statement_period': 'Select period',
  'no_loan_list': 'Bạn không có khoản vay',
  'loan_info': 'Thông tin khoản vay',
  'approved_amount': 'Số tiền được duyệt',
  'debt': 'Dư nợ',
  'current_interest': 'Lãi suất hiện tại',
  'borrow_date': 'Ngày vay',
  'info_amount_due_to_pay': 'Thông tin số tiền đến hạn phải trả',
  'total_amount_due_to_pay': 'Tổng số tiền đến hạn phải trả',
  'next_payment_due_date': 'Ngày đến hạn thanh toán tiếp theo',
  'root_amount_due_to_pay': 'Gốc đến hạn trả',
  'interest_due_to_pay': 'Lãi đến hạn trả',
  'info_amount_out_date': 'Thông tin số tiền quá hạn phải trả hiện tại',
  'total_amount_out_date': 'Tổng số tiền quá hạn phải trả',
  'root_amount_out_date': 'Gốc quá hạn',
  'interest_amount_out_date': 'Lãi quá hạn',
  'interest_penalty_out_date': 'Lãi phạt quá hạn',
  'loan_history': 'Lịch sử giao dịch khoản vay',
  'export_loan': 'XUẤT FILE SAO KÊ NỢ ĐẾN HẠN',

  //Trade Finance
  'statement_lc': 'L/C and Collection Transaction Statement ',
  'statement_guarantee': 'Guarantee Transaction Statement',
  'statement_ck': 'Negotiation Transaction Statement',
  'title_lc': 'LC & Collection',
  'reference_number': 'Ref Number',
  'enter_reference_number': 'Input Reference Number',
  'guarantee_number': 'Guarantee Number',
  'enter_guarantee_number': 'Input Guarantee Number',
  'release_date': 'Issue Date',
  'expire_date': 'Expire Date',
  'detail': 'More Detail',
  'title_bao_lanh': 'Guarantee',
  'bao_lanh_number': 'Guarantee Number',
  'contract_number': 'Contract Number',
  'enter_contract_number': 'Enter Contract Number',
  'discount': 'Negotiation',
  'discount_date': 'Negotiate Date',
  ...commerceEnUs,

  //Tax
  'tax_id': 'Tax Code',
  'register_tax': 'Tax Registration',
  'notice_tax_pending':
      'Your tax code <font style="color: green; font-weight: 600; font-size: 12pt">%s</font> is registered at VPBank with status <font style="color: black; font-weight: 700; font-size: 12pt">pending for approval</font>. Please check again',
  'notice_tax_reject':
      'Your tax code <font style="color: green; font-weight: 600; font-size: 12pt">%id</font> is registered at VPBank with status <font style="color: black; font-weight: 700; font-size: 12pt">rejected by approver</font> The reason is <font style="color: black; font-weight: 700; font-size: 12pt">%reason</font>. Please check again',
  'customer_info': 'Customer Information',
  'tax_debit_account': 'Tax Debit Account',
  'fee_payment_account': 'Fee Payment Account',
  'general_tax_info': 'II. Tax information from General Department of Taxation',
  'tax_payer_name': 'Taxpayer',
  'email': 'Email',
  'phone_number': 'Phone Number',
  'career': 'Career',
  'address': 'Address',
  're_register': 'Re-register',
  'tax_condition': 'Tax Registration Commitment',
  'notice_not_register_tct':
      'Your tax code <font style="color: green; font-weight: 600; font-size: 12pt">%id</font> has not registered at VPBank. Please check again',
  'back_to_main': 'Back to home screen',
  'notice_tax_approved':
      'Your tax code <font style="color: green; font-weight: 600; font-size: 12pt">%id</font> is registered at VPBank. Please check again',
  'tax_menu_manage': 'Tax Registration Management',
  'canceled': 'Transaction is canceled!',
  //FX
  'can_not_get_rate': 'can not get exchange rate',
  'fx_rate_note': 'The official rate will be applied at the time when the last Approver authorises the transaction',
  'fx_debit_amount': 'Debit Amount',
  'fx_estimate_conversion_amount':'Indicative equivalent amount',
  ...electricEnUS,

  // JB/Root
  'root_notice': 'To ensure information security, VPBank NEOBiz does not work on jailbroken/rooted devices. Please use this application on devices that have not been tampered with!',
  'root_close_app_btn': 'Close application',
};
