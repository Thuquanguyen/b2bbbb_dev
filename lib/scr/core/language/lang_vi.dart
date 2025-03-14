import 'package:b2b/scr/core/language/vi/bill_checker.dart';
import 'package:b2b/scr/core/language/vi/card_history.dart';
import 'package:b2b/scr/core/language/vi/card_info.dart';
import 'package:b2b/scr/core/language/vi/commerce.dart';
import 'package:b2b/scr/core/language/vi/electric.dart';
import 'package:b2b/scr/core/language/vi/loan.dart';
import 'package:b2b/scr/core/language/vi/payroll.dart';
import 'package:b2b/scr/core/language/vi/tax_manage.dart';
import 'package:b2b/scr/core/language/vi/transaction_status.dart';

const Map<String, String> vi_VN = {
// intro
  'page_1': 'Chào mừng đến với Candy',
  'page_2': 'Chúng tôi giúp bạn kết nối \ntới mọi dịch vụ ở Việt Nam',
  'page_3': 'Chúng tôi sẽ chỉ cho bạn mua sắm dễ dàng. \nHãy ở nhà với chúng tôi.',
  'page_4': 'Sẵn sàng chạm tới mọi thứ nào.',

  'change_lang': 'Đổi ngôn ngữ',
  'author_biometric': 'Xác thực',

  'continue': 'Tiếp tục',

//Bottom Tabbar
  'tab_home': 'Trang chủ',
  'tab_transaction': 'Truy vấn',
  'tab_notification': 'Thông báo',
  'tab_more': 'Cài đặt',

// utilities
  'bank_default': 'Ngân hàng thụ hưởng',
  'having_an_error': 'Đã xảy ra lỗi, vui lòng thử lại',
  'wrong_format_input': 'Sai định dạng nhập liệu',
  'having_wrong_connect_internet': 'Có lỗi xảy ra, vui lòng kiểm tra kết nối và thử lại!',

// account manage screen
  'account_manage_title_login': 'ĐĂNG NHẬP',
  'account_manage_title_header': 'Chọn tài khoản',
  'account_manage_title_done': 'XONG',
  'account_manage_title_login_account_other': 'ĐĂNG NHẬP TÀI KHOẢN KHÁC',
  'account_manage_title_active_otp':
      'Tài khoản này chưa kích hoạt Smart OTP bạn có muốn kích hoạt không? Đăng nhập để kích hoạt',
  'account_mange_title_opt_not_available': 'Tài khoản này chức năng Smart OTP không khả dụng',
  'account_mange_title_active_login_with_pin': 'Bạn có chắc chắn muốn huỷ kích hoạt đăng nhập bằng mã PIN không?',
  'account_mange_title_not_active_pin': 'Bạn chưa cài đặt mã PIN',

  // biometric screen
  'biometric_button_try_again': 'THỬ LẠI',
  'biometric_title_sinh_trac_hoc': 'Sinh trắc học',
  'biometric_title_setting_sinh_trac_hoc': 'Bạn có muốn thiết lập sinh trắc học?',
  'biometric_title_use_sinh_trac_hoc': 'SỬ DỤNG SINH TRẮC HỌC',
  'biometric_title_not_use_sinh_trac_hoc': 'Không sử dụng sinh trắc học',
  'biometric_title_cancel': 'Hủy',
  'biometric_title_setting': 'Cài đặt',
  'biometric_title_setting_face_ID': 'Vui lòng cài đặt xác thực Face ID',
  'biometric_title_out_try_again': 'Bạn đã quá số lần thử',
  'biometric_message_use_face_ID': 'Vui lòng sử dụng FaceID để xác thực',
  'biometric_title_setup_face_ID': 'Thiết lập Face ID',
  'biometric_title_use_face_ID': 'SỬ DỤNG FACE ID',
  'biometric_title_not_use_face_ID': 'Không sử dụng Face ID',
  'biometric_title_question_setup_face_ID': 'Bạn có muốn thiết lập Face ID?',
  'biometric_title_not_confirm_face_ID': 'Không nhận diện được Face ID',
  'biometric_title_setting_touch_ID': 'Vui lòng cài đặt xác thực Touch ID',
  'biometric_message_use_touch_ID': 'Vui lòng sử dụng TouchID để xác thực',
  'biometric_title_setup_touch_ID': 'Thiết lập Touch ID',
  'biometric_title_use_touch_ID': 'SỬ DỤNG TOUCH ID',
  'biometric_title_not_use_touch_ID': 'Không sử dụng Touch ID',
  'biometric_title_question_setup_touch_ID': 'Bạn có muốn thiết lập Touch ID?',
  'biometric_title_not_confirm_touch_ID': 'Không nhận diện được Touch ID',
  'biometric_message_setting_fingerprint': 'Vui lòng cài đặt vân tay để sử dụng xác thực',
  'biometric_message_setting': 'Vui lòng sử dụng sinh trắc học để xác thực',
  'biometric_title_setup_fingerprint': 'Thiết lập vân tay',
  'biometric_title_use_fingerprint': 'SỬ DỤNG VÂN TAY',
  'biometric_title_not_use_fingerprint': 'Không sử dụng vân tay',
  'biometric_question_use_fingerprint': 'Bạn có muốn thiết lập vân tay?',
  'biometric_not_confirm_fingerprint': 'Không nhận diện được vân tay',

  // First login screen
  'first_login_title_add_account': 'Thêm tài khoản',
  'first_login_title_username': 'Tên đăng nhập',
  'first_login_title_password': 'Mật khẩu',
  'first_login_title_help': 'Hỗ trợ',
  'first_login_title_exchange_rate': 'Tỷ giá',
  'first_login_title_onboard_online': 'Mở tài khoản Online',
  'first_login_title_interest_rate': 'Lãi suất',
  'dialog_message_input_username': 'Vui lòng nhập tên đăng nhập để tiếp tục đăng nhập vào ứng dụng',

  // otp_screen
  'otp_title_out_of_time_get_otp': 'Đã hết thời gian nhận mã OTP.\nVui lòng thử lại',
  'otp_message_confirm': 'Đã xác thực',
  'otp_send_again': 'Đã gửi yêu cầu lấy lại mã xác thực',
  'otp_confirm_information': 'Xác nhận thông tin',
  'otp_title_input_otp': 'Đang gửi yêu cầu mã xác thực...',
  'otp_title_get_again': 'Lấy lại OTP',
  'otp_title_get_activation_code_again': 'Lấy lại mã kích hoạt',
  'otp_title_input_otp_activation_code': 'Vui lòng nhập mã kích hoạt',
  'sotp_activation_title': 'Kích hoạt smart otp',
  'otp_inactive':
      'Quý khách hàng chưa kích hoạt Smart OTP trên thiết bị này. Vui lòng thực hiện kích hoạt Smart OTP để thực hiện các giao dịch tài chính trên ứng dụng VPBank NEOBiz',
  'sotp_not_active_dialog_title': 'Đăng ký sử dụng Smart OTP',
  'sotp_not_active_dialog_content':
      '''Bạn chưa đăng ký và kích hoạt sử dụng <font style='color: #00B74F; font-weight: bold'>VPBank Smart OTP</font> để sử dụng cho giao dịch trên ứng dụng''',
  'sotp_activated_dialog_title': 'Smart OTP Đã đăng ký thành công',
  'sotp_activated_dialog_content':
      '''Bạn đã đăng ký và kích hoạt sử dụng <font style='color: #00B74F; font-weight: bold'>VPBank Smart OTP</font>. Hiện giờ bạn có thể sử dụng cho giao dịch trên ứng dụng''',
  'sotp_activated_other_device_dialog_content':
      '''Tài khoản của bạn đã bị kích hoạt trên thiết bị khác vui lòng kích hoạt lại <font style='color: #00B74F; font-weight: bold'>VPBank Smart OTP</font> để sử dụng cho giao dịch trên ứng dụng''',

  // pin_screen
  'pin_title_confirm': 'Xác thực',
  'pin_title_setup': 'Thiết lập mã pin',
  'pin_title_setup_otp': 'Thiết lập mã PIN Smart OTP',
  'pin_title_confirm_app': 'Xác nhận mã pin',
  'pin_title_confirm_otp': 'Xác nhận mã pin',
  'pin_message_input_use_app': 'Vui lòng nhập mã PIN để đăng nhập ứng dụng',
  'pin_message_input_use_app_old': 'Vui lòng nhập mã PIN tiếp tục',
  'pin_message_input_use_OTP': 'Vui lòng nhập mã PIN để sử dụng Smart OTP',
  'pin_message_input_use_OTP_old': 'Vui lòng nhập mã PIN để tiếp tục',
  'pin_message_setup_pin_and_next': 'Vui lòng thiết lập mã PIN và tiếp tục',
  'pin_message_setup_again': 'Vui lòng nhập lại mã PIN và tiếp tục',
  'pin_title_not_use': 'Không sử dụng mã PIN',
  'pin_message_not_duplicate': 'Cài đặt mã PIN không trùng nhau',
  'pin_message_incorrect': 'Mã PIN không đúng. Bạn còn',
  'pin_message_turn': 'lượt',

  // re_login_screen
  're_login_login_with_account_other': 'Đăng nhập bằng tài khoản khác',
  're_login_service_account': 'DV Tài khoản',
  're_login_transaction_management': 'Quản lý \ngiao dịch',

  // beneficiary_screen
  'beneficiary_title_header': 'Danh sách người thụ hưởng',
  'beneficiary_title_find_bank': 'Tiền gửi',

  // home_action_manager
  'home_action_message_have_selected_7': 'Bạn đã chọn đủ %number tiện ích',

  // home_screen
  'home_title_customer': 'Khách hàng',
  'home_button_logout': 'ĐĂNG XUẤT',
  'home_title_well_come': 'Xin chào, ',
  'home_title_transfer_money': 'Chuyển tiền',
  'home_title_payroll': 'TT lương đơn lẻ',
  'home_title_account': 'Tài khoản',
  'home_title_transaction_management': 'Quản lý giao dịch',
  'home_title_term_header': 'Điều khoản và điều kiện',
  'home_title_item_other': 'Khác',
  'home_title_feedback': 'Góp ý',

  // list_second_home_screen
  'list_second_title_setup': 'Thiết lập',
  'list_second_title_save': 'Lưu',
  'list_second_message_save_success': 'Lưu thành công!',
  'list_second_message_selected_7': 'Bạn cần chọn đủ %number tiện ích',
  'list_second_title_utilities_list': 'Danh mục tiện ích',

  // profile screen
  'profile_title_header': 'Thông tin chi tiết',
  'profile_title_business_information': 'Thông tin doanh nghiệp',
  'profile_title_customer_name': 'Tên khách hàng',
  'profile_title_customer_code': 'Mã khách hàng',
  'profile_title_customer_address': 'Địa chỉ',
  'profile_title_customer_service_package': 'Gói dịch vụ',
  'profile_title_customer_credit_limit': 'Xếp hạng tín dụng',
  'profile_title_information': 'Thông tin cá nhân',
  'profile_title_full_name': 'Họ và tên',
  'profile_title_ID_Passport_number': 'Số CMND/Hộ chiếu',
  'profile_title_account_information': 'Thông tin tài khoản',
  'profile_title_otp_method_receiving': 'Phương thức nhận OTP',
  'profile_title_otp_phone_number_receiving': 'Số điện thoại nhận OTP',
  'profile_title_otp_email_receiving': 'Email nhận OTP',
  'profile_title_role': 'Vai trò',
  'profile_title_last_login': 'Lần truy cập gần nhất',
  'profile_title_logout': 'Đăng xuất',

  // saving_screen
  'saving_title_call_program': 'CHƯƠNG TRÌNH GỬI',
  'saving_title_term_deposit_online': 'Tiền gửi có kỳ hạn Online',
  'saving_title_method_of_receiving_interest': 'Phương thức nhận lãi',
  'saving_title_period': 'Kỳ hạn',
  'saving_title_interest_rate': 'Lãi suất(%/năm)',
  'saving_title_text_feet_1': 'Biểu lãi suất VND áp dụng cho Khách hàng doanh nghiệp vừa và nhỏ.',
  'saving_title_text_feet_2': 'Lãi được tính trên số ngày thực tế và cơ sở tính lãi là 365 ngày',
  'saving_title_text_feet_3':
      'Lãi suất các loại ngoại tệ khác hoặc các kỳ hạn không niêm yết, đề nghị Quý khách hàng liên hệ trực tiếp với điểm giao dịch gần nhất để biết chi tiết.',

  // list_otp_intro
  'otp_intro_model_1':
      'Ứng dụng tạo mã xác thực một lần (OTP) theo quy định bắt buộc của Ngân hàng nhà nước khi giao dịch trên kênh ngân hàng điện tử.',
  'otp_intro_model_2': 'OTP được mã hóa trong quá trình gửi tới thiết bị của KH.',
  'otp_intro_model_3': 'Khách hàng cần cung cấp mã PIN mới lấy được mã xác thực giao dịch (OTP).',
  'otp_intro_model_4': 'Với ứng dụng Smart OTP, không cần song điện thoại vẫn thực hiện được giao dịch.',

  // smart_otp_intro_screen
  'smart_otp_intro_title_start_use': 'Bắt đầu sử dụng',

  // smart_otp_screen
  'smart_otp_code': 'Mã OTP',
  'smart_otp_auto_update_later': 'Sẽ tự cập nhật sau',
  'smart_otp_minus': 'giây',
  'smart_otp_approval_code': 'Mã phê duyệt:',
  'smart_otp_message_warning': '''<font style="color: red; font-weight: 500">Cảnh báo:</font></div></br>
      <font color="gray" style="line-height: 16pt">Ai yêu cầu cung cấp mã 6 số trên đều là lừa đảo. Không chia sẻ  mã  6 số trên cho bất kỳ ai, kể cả người tự xưng là nhân viên ngân hàng hay công an để tránh <font style="font-weight:500">MẤT TIỀN!</font></font>''',
  'smart_otp_normal': 'Cơ bản',
  'smart_otp_advanced': 'Nâng cao',
  'sotp_active':
      '''<div style="line-height: 18pt; font-size: 12pt"><strong style="font-weight: 600; font-size:13pt">Hướng dẫn các bước kích hoạt VPBank Smart OTP</strong><br/>
          <font style="color: green; font-weight: 600; font-size: 12pt">Bước 1:</font> Nhận mã kích hoạt ứng dụng VPBank Smart OTP qua SMS hoặc email mà Quý khách đã đăng ký<br>
<font style="color: green; font-weight: 600; font-size: 12pt">Bước 2:</font> Nhập mã kích hoạt tại màn hình này</div>''',

  // term screen
  'term_title_confirm': 'TÔI ĐỒNG Ý',
  'title_confirm': 'ĐỒNG Ý',

  // transfer_to_account_screen
  'transfer_to_account_title_goto_account_number': 'Chuyển đến số tài khoản',
  'transfer_to_account_number': 'Đến số tài khoản',
  'transfer_to_card_number': 'Đến số thẻ',
  'transfer_to_account_title_source_account': 'Tài khoản nguồn',
  'transfer_to_account_title_beneficiary_information': 'Thông tin người thụ hưởng',
  'transfer_input': 'Chuyển tiền nhanh 247',

  //transfer_screen
  'transfer_title_choose_transfer_method': 'Chọn phương thức chuyển tiền',
  'description_transfer': 'Nội dung chuyển tiền',
  'can_not_find_account': 'Không tìm thấy tài khoản, hãy thử lại',

  // find_atm_screen
  'find_atm_title_direction': 'Dẫn đường',
  'find_atm_title_branch': 'Chi nhánh',
  'find_atm_title_atm_machine': 'Máy rút tiền ATM',
  'find_atm_title_atm_deposit': 'Máy gửi tiền/rút tiền ATM',
  'find_atm_title_transaction_branch': 'Chi nhánh giao dịch',

  // container_item
  'container_item_continue': 'Tiếp tục',

  // data_hard_core
  'data_hard_core_bank': 'Ngân hàng thụ hưởng',
  'data_hard_core_count_money': 'Số tiền chuyển',
  'data_hard_core_note': 'Ghi chú (tuỳ chọn)',
  'data_hard_core_start_date': 'Ngày bắt đầu',
  'data_hard_core_frequency': 'Tần suất',
  'data_hard_core_card': 'Thẻ',
  'data_hard_core_loan': 'Tiền vay',
  'data_hard_core_commerce': 'Tài trợ thương mại',
  'data_hard_core_guarantee': 'Bảo lãnh',
  'data_hard_core_ld': 'LC & Nhờ thu',
  'data_hard_core_discount': 'Chiết khấu',
  'data_hard_core_transfer_money_vpbank': 'Chuyển tiền trong VPBank',
  'data_hard_core_transfer_247': 'Chuyển tiền nhanh 247',
  'data_hard_core_interbank_money_transfer': 'Chuyển tiền liên ngân hàng',

  // language
  'title_select_language': 'Lựa chọn ngôn ngữ',
  'title_language_vi': 'Tiếng Việt',
  'title_language_en': 'Tiếng Anh',

  // dialog
  'dialog_title_delete': 'Xoá tài khoản?',
  'dialog_message_delete': 'Bạn có chắc chắn muốn xoá tài khoản này không?',
  'dialog_button_skip': 'Bỏ qua',
  'dialog_button_cancel': 'HỦY',
  'dialog_button_delete': 'Xoá',
  'dialog_button_close': 'ĐÓNG',
  'dialog_message_system_is_maintenance': 'Mong quý khách hàng thông cảm và vui lòng trở lại sau. Xin cảm ơn!',
  'dialog_title_system_is_maintenance': 'Hệ thống đang bảo trì',
  'dialog_title_notification': 'Thông báo',
  'dialog_login_with_pin': 'Đăng nhập bằng mã PIN đã được kích hoạt trên thiết bị khác.',
  'dialog_login_with_touch_ID': 'Đăng nhập bằng Touch ID đã được kích hoạt trên thiết bị khác.',
  'dialog_login_with_face_ID': 'Đăng nhập bằng Face ID đã được kích hoạt trên thiết bị khác.',
  'dialog_message_login_fail': 'Đăng nhập thất bại. Vui lòng kiểm tra kết nối và thử lại',
  'dialog_message_login_session_expired': 'Phiên đăng nhập của bạn đã hết. Vui lòng đăng nhập lại để tiếp tục.',
  'dialog_title_forgot_password': 'Quên mật khẩu?',
  'dialog_message_forgot_password':
      'Quý khách vui lòng liên hệ <b style="color: #00b74f">1900545415</b> để được cấp lại mật khẩu VPBank Online',
  'dialog_message_input_password': 'Vui lòng nhập mật khẩu để tiếp tục đăng nhập vào ứng dụng',
  'dialog_message_ask_logout': 'Bạn có chắc chắn muốn đăng xuất không?',

  //transfer
  'beneficiary_info': 'Thông tin người thụ hưởng',
  'account_number': 'Số tài khoản',
  'beneficiary_name': 'Tên người thụ hưởng',
  'receive_name': 'Tên người nhận',
  'save_beneficiary': 'Lưu người thụ hưởng',
  'save_remember_name': 'Tên gọi nhớ',
  'transfer_amount': 'Số tiền chuyển',
  'transfer_content': 'Nội dung chuyển tiền',
  'fee_account': 'Tài khoản thu phí',
  'to_account_number': 'Đến số tài khoản',
  'to_card_number': 'Đến số thẻ',
  'enter_amount': 'Nhập số tiền',
  'enter_info': 'Nhập thông tin',
  'card_number': 'Số thẻ',
  'the_money_must_be_bigger_than_zero': 'Số tiền chuyển phải lớn hơn 0',
  'account_number_sekleton': 'STK - %number',
  'choose_source_account': 'Chọn tài khoản nguồn',
  'free_amount': 'Miễn phí',
  'number_of_money': 'Số tiền bằng chữ',
  'fee_type': 'Loại phí',
  'fee_amount': 'Phí chuyển khoản',
  'content': 'Nội dung',
  'time': 'Thời gian',
  'wait_approve': 'Chờ phê duyệt',
  'back': 'Quay lại',
  'send': 'Gửi',

  //Search
  'pick_bank': 'Chọn ngân hàng',
  'pick_bank_place': 'Tỉnh/Thành phố',
  'pick_beneficiary': 'Người thụ hưởng',

  //Account Service
  'as_requset_send_statement_success': 'Yêu cầu gửi sao kê thành công',
  'as_back_to_list_account': 'Quay về danh sách tài khoản',
  'as_list_account': 'Danh sách tài khoản',
  'as_period': 'Khoảng thời gian',
  'as_for_amount': 'Theo số tiền',
  'as_for_content_transaction': 'Theo nội dung chuyển tiền',
  'as_input_content_transaction': 'Nhập nội dung chuyển tiền cần tìm',
  'as_file_format': 'Định dạng file báo cáo',
  'as_choose_time_transaction': 'Chọn thời điểm lập để đảm bảo tối đa 1.000 giao dịch/1 lần sao kê',
  'as_list_result': 'Liệt kê kết quả',
  'as_send_statement': 'Gửi sao kê',
  'as_list_transaction': 'Danh sách giao dịch',
  'as_send_statement_email': 'Gửi sao kê về Email',
  'as_fill_full_time_search': 'Vui lòng nhập đầy đủ khoảng thời gian tìm kiếm',
  'as_find_time_invalid': 'Thời gian tìm kiếm không hợp lệ. Vui lòng nhập đúng khoảng thời gian tìm kiếm',
  'as_find_time_invalid_new':
      'Khoảng thời gian in sao kê không chính xác(ngày bắt đầu không thể lớn hơn ngày kết thúc in sao kê)',
  'as_find_time_out_of_date': 'Chỉ có thể liệt kê giao dịch trong vòng %mouth tháng',
  'transaction_information': 'Thông tin giao dịch',
  'transaction_list': 'Danh sách giao dịch',
  'account_tools': 'Công cụ tài khoản',
  'online_statement': 'Sao kê online',
  'send_email_offline_statement': 'Gửi sao kê về Email',
  'as_surplus': 'Số dư',
  'as_available_balances': 'Số dư khả dụng',
  'as_id_number': 'Số ĐKKD/CMND',
  'title_address': 'Địa chỉ',
  'title_account_type': 'Loại tài khoản',
  'title_open_branch': 'Chi nhánh mở',
  'title_open_date': 'Ngày mở',
  'title_error_no_data': 'Không có dữ liệu',
  'title_beneficiary_name': 'Tên người thụ hưởng',
  'title_out_of_request_transaction':
      'Số lượng giao dịch vượt quá giới hạn hiển thị. Quý khách sử dụng tính năng Gửi sao kê về Email để tiếp tục dịch vụ',
  'title_deposits': 'Số tiền gửi',
  'title_open_expried_date': 'Ngày gửi',
  'title_expried_date': 'Ngày đến hạn',
  'title_due_information': 'Thông tin đáo hạn',
  'title_finalization_account': 'Tài khoản tất toán',
  'title_type_deposits': 'Loại tiền gửi',
  'title_deposits_branch': 'Chi nhánh gửi tiền',
  'title_balance_fluctuations_content': 'Biến động số dư / Nội dung',
  'title_balance_after_transactions': 'Số dư sau giao dịch',

  // Bottom sheet
  'one_week': '1 tuần',
  'two_week': '2 tuần',
  'one_mouth': '1 tháng',
  'elective': 'Tự chọn',

  // Exchange rate screen
  'ers_exchange_header': 'Quy đổi',
  'ers_exchange_convert': 'Quy đổi',
  'ers_exchange_from_currency': 'Từ',
  'ers_exchange_to_currency': 'Sang',
  'ers_exchange_rate_info': 'Tỷ giá',
  'ers_exchange_currency_list_title': 'Ngoại tệ',
  'ers_exchange_currency_list_header_name': 'Ngoại tệ',
  'ers_exchange_currency_list_header_buy': 'Mua CK',
  'ers_exchange_currency_list_header_sell': 'Bán',
  'ers_exchange_info': 'Tỷ giá đang có hiệu lực tại thời điểm Quý khách truy cập\nvà mang tính chất tham khảo',

  //URL
  'url_otp_term': 'https://vpbankonline.vpbank.com.vn/dieu-kien-giao-dich-vpbank-smart-otp-vn/',

  'charge_account': 'Tài khoản trả phí',
  'transfer_cost': 'Phí người chuyển trả %vat',
  'paid_recipients': 'Người nhận chịu phí %vat',
  'enter_card_number': 'Nhập số thẻ',
  'enter_account_number': 'Nhập số tài khoản',

  // Settings screen
  'sts_screen_title': 'Cài đặt',
  'sts_feedback_title': 'Đóng góp ý kiến',
  'sts_login_faceid': 'Đăng nhập bằng FaceID',
  'sts_login_finger': 'Đăng nhập bằng vân tay',
  'sts_login_pin': 'Đăng nhập bằng mã PIN',
  'sts_login_pin_change': 'Thay đổi mã PIN',
  'sts_password_change': 'Đổi mật khẩu',
  'sts_otp_method': 'Phương thức nhận OTP',
  'sts_smart_otp': 'Smart OTP',
  'sts_sotp_change_pin': 'Đổi mã PIN Smart OTP',
  'sts_sotp_reset': 'Cài đặt lại Smart OTP',
  'sts_sotp_resync': 'Đồng bộ lại Smart OTP',
  'sts_sotp_resynced': 'Đồng bộ thành công!',
  'sts_sotp_toc': 'Điều khoản và điều kiện sử dụng Smart OTP',
  'sts_notification': 'Thông báo',
  'sts_notification_balance_preview': 'Xem trước biến động số dư',
  'sts_notification_balance_preview_desc': '''<p style="line-height: 16pt; font-size: 13pt; color: #666667;">
      <font>Khi tính năng bật, Quý khách có thể xem thông báo biến đông số dư ngay tại màn hình đăng nhập<br>
      <font color="#ff6863">Lưu ý: Tính năng này có rủi ro lộ thông tin giao dịch</font></font></p>''',
  'sts_notification_transaction': 'Các tài khoản nhận thông báo',
  'sts_notification_transaction_pending': 'Giao dịch chờ duyệt',
  'sts_notification_transaction_step1': 'Giao dịch duyệt bước 1',
  'sts_notification_transaction_waiting': 'Giao dịch chờ xác nhận',
  'sts_notification_transaction_error': 'Giao dịch lỗi',
  'sts_notification_other': 'Thông báo khác',
  'sts_notification_other_desc': 'Khác: Thông báo khuyến mại, chính sách từ ngân hàng',

  //Notification
  "notification": "Thông báo",
  "all": "Tất cả",
  "balance_change": "Biến động số dư",
  "transaction_pending": "Giao dịch chờ",
  "end_dow": "Ưu đãi",
  // 'message_content_noti' : 'Tài khoản %account, có biến động số dư %balance, với nội dung: %content',
  'message_content_noti':
      '''<div style="line-height: 18pt; font-size: 12pt">Tài khoản <strong style="font-weight: 600; font-size:13pt">%account</strong>
          <br>%title <strong style="font-weight: 600; font-size:13pt;color:%color">%balance</strong>, nội dung: %content</div>''',
  'message_bill_noti':
  '''<div style="line-height: 18pt; font-size: 12pt">Tài khoản <strong style="font-weight: 600; font-size:13pt">%account</strong>
          <br>%title <strong style="font-weight: 600; font-size:13pt;color:%color">%balance</strong> / Loại giao dịch : thanh toán hóa đơn</div>''',
  // Change OTP Method screen
  'cotps_screen_title': 'Phương thức nhận OTP',
  'cotps_sms': 'Nhận qua SMS',
  'cotps_sms_desc': 'Đến số điện thoại',
  'cotps_email': 'Nhận qua Email',
  'cotps_email_desc': 'Đến địa chỉ',
  'cotps_sotp': 'Smart OTP',
  'cotps_confirm': 'Xác nhận',

  // Change password screen
  'cpws_screen_title': 'Đổi mật khẩu',
  'cpws_old_password': 'Mật khẩu hiện tại',
  'cpws_new_password': 'Mật khẩu mới',
  'cpws_new_password_repeat': 'Nhập lại mật khẩu mới',
  'cpws_confirm': 'Đổi mật khẩu',

  // Transaction query screen
  'tqs_screen_title': 'Truy vấn giao dịch',
  'tqs_find_by_transaction': 'Tìm theo giao dịch',
  'tqs_transaction_id': 'Mã giao dịch',
  'tqs_input_transaction_id': 'Nhập mã giao dịch',
  'tqs_journal_entry': 'Số bút toán',
  'tqs_input_journal_entry': 'Nhập số bút toán',
  'tqs_time_range': 'Khoảng thời gian',
  'tqs_find_by_time_range': 'Khoảng thời gian lập',
  'tqs_from_date': 'Từ ngày',
  'tqs_to_date': 'Đến ngày',
  'tqs_find_by_amount': 'Theo số tiền',
  'tqs_from_amount': 'Từ số tiền',
  'tqs_to_amount': 'Đến số tiền',
  'tqs_input_amount': 'Nhập số tiền',
  'tqs_amount_currency': 'Loại tiền',
  'tqs_find_by_memo': 'Theo nội dung chuyển tiền',
  'tqs_input_memo': 'Nhập nội dung chuyển tiền cần tìm',
  'tqs_input_memo_content': 'Nhập nội dung',
  'tqs_inquiry': 'Truy vấn ngay',
  'no_ben_list': 'Bạn chưa lưu người thụ hưởng',

  //TransactionManager
  'transaction_management': 'Quản lý giao dịch',
  'selected': 'Chọn',
  'selected_all': 'Tất cả',
  'un_selected_all': 'Bỏ chọn',
  'close_filter': 'Đóng',
  'wait_processing': 'Chờ xử lý',
  'ben_account': 'Tài khoản thụ hưởng',
  'no_city_list': 'Chưa có dữ liệu Tỉnh/Thành phố',
  'no_branch_list': 'Không có dữ liệu chi nhánh',
  'selected1': 'Đã chọn',
  'transaction': 'giao dịch',
  'cancel': 'Từ chối',
  'approve': 'Phê duyệt',
  'cancel_transaction': 'Hủy giao dịch',
  'invalid_from_to_amount': 'Lỗi. Số tiền chặn sau phải lớn hơn số tiền chặn trước',
  'invalid_from_to_date': 'Lỗi . Ngày kết thúc phải lớn hơn ngày bắt đầu',
  'transaction_service_type': 'Loại giao dịch',
  'no_transaction_follow_filtter': 'Không có giao dịch chờ duyệt nào ứng với bộ lọc trên',
  'no_transaction_wait_approve': 'Bạn không có giao dịch chờ duyệt',
  'apply': 'Áp dụng',
  "error_no_reason": 'Thất bại, có lỗi xảy ra!',
  'choose': 'Chọn',
  'debit_acct': 'Tk',

  // Transaction approve
  'tas_screen_title_single': 'Chờ duyệt chuyển tiền',
  'tas_screen_title_multi': 'Chờ duyệt chuyển tiền',
  'tas_reject_dialog_title': 'Xác nhận từ chối giao dịch',
  'tas_cancel_dialog_title': 'Xác nhận hủy bỏ giao dịch',
  'tas_reject_dialog_message_label': 'Nhập lý do',
  'tas_reject_dialog_cancel': 'Hủy',
  'tas_reject_dialog_confirm': 'Xác nhận',
  'tas_rejected_toast': 'Đã từ chối giao dịch',
  'tas_canceled_toast': 'Đã hủy giao dịch',

  'tas_approving_transaction': 'giao dịch',
  'tas_action_title': 'Bạn đang %action',
  'tas_action_total_amount': 'Tổng số tiền %action',
  'tas_action_trans_list': 'Danh sách giao dịch',
  'tas_action_cancel': 'hủy',
  'tas_action_reject': 'từ chối',
  'tas_action_approve': 'phê duyệt',

  'tas_approving_transaction_detail_title': 'Chi tiết giao dịch',

  'tas_td_debit_account': 'Tài khoản nguồn',
  'tas_td_ben_info': 'Thông tin người thụ hưởng',
  'tas_td_ben_bank': 'Ngân hàng thụ hưởng',
  'tas_td_ben_city': 'Tỉnh/Thành phố',
  'tas_td_ben_branch': 'Chi nhánh',
  'tas_td_amount': 'Số tiền chuyển',
  'tas_td_amount_in_words': 'Số tiền bằng chữ',
  'tas_td_charge_account': 'Tài khoản trả phí',
  'tas_td_exchange_rate': 'Tỷ giá',
  'tas_td_exchange_rate_notice':
      'Tỷ giá chính thức được xác định tại thời điểm người phê duyệt cuối cùng phê duyệt giao dịch',
  'tas_td_debit_amount': 'Số tiền trích nợ',
  'tas_td_converted_amount': 'Số tiền chuyển quy đổi tạm tính',
  'tas_td_charge_amount': 'Phí',
  'tas_td_memo': 'Nội dung thanh toán',
  'tas_td_appr_time': 'Thời gian duyệt',
  'tas_td_reject_cause': 'Lý do từ chối',
  'tas_reason_required': 'Vui lòng điền lý do',
  'tas_td_confirm_success': 'Xác nhận thành công',
  'tas_td_success': 'Thành công',

  // Transaction inquiry
  'tis_report_title': 'THÔNG TIN GIAO DỊCH',
  'tis_transaction_detail': 'Chi tiết giao dịch',
  'tis_accounting_entry': 'Số bút toán',
  'tis_transaction_code': 'Mã giao dịch',
  'tis_debit_account': 'Tài khoản nguồn',
  'tis_ben_info': 'Thông tin người thụ hưởng',
  'tis_amount': 'Số tiền chuyển',
  'tis_amount_in_words': 'Số tiền bằng chữ',
  'tis_memo': 'Ghi chú',
  'tis_charge': 'Phí',
  'tis_charge_account': 'Tài khoản trả phí',
  'tis_timestamp': 'Thời gian',
  'tis_go_back': 'QUAY LẠI',
  'tis_share': 'GỬI',

  'tis_range_one_week': '1 tuần',
  'tis_range_two_week': '2 tuần',
  'tis_range_one_month': '1 tháng',
  'tis_range_custom': 'Tự chọn',
  'tis_inquiry_error_general': 'Đã có lỗi xảy ra. Vui lòng thử lại sau!',
  'tis_no_result': 'Không có dữ liệu phù hợp với tiêu chí đã chọn!',

  'tis_balance_change': 'Số tiền:',
  'tis_end_of_list': 'Hết danh sách',
  'tis_list_screen_title': 'Danh sách giao dịch',
  'tis_detail_screen_title': 'Chi tiết giao dịch',
  'tis_payroll_detail_screen_title': 'Thanh toán lương',
  'tis_transaction_type': 'Loại giao dịch:',
  'tis_tp_payroll': 'Thanh toán lương',
  'tis_tp_transfer': 'Chuyển tiền',

  // auth
  'auth_biometric_not_available': 'Tính năng đăng nhập bằng sinh trắc học không khả dụng',
  'auth_not_setup_biometrics': 'Bạn chưa cài đặt sinh trắc học',
  'auth_account_locked_incorrect_otp': 'Tài khoản bị khóa do nhập sai OTP nhiều lần',
  'auth_biometric_login_setup_success': 'Cài đặt đăng nhập bằng sinh trắc học thành công',
  'auth_pin_login_setup_success': 'Cài đặt đăng nhập bằng mã PIN thành công',
  'auth_title_error': 'Có lỗi trong quá trình xác thực. Vui lòng thử lại sau',

  //smart otp
  'smart_otp_error_active_code': 'Có lỗi xảy ra trong quá trình gửi mã kích hoạt. Vui lòng thử lại',
  'smart_otp_no_smart_otp': 'Chưa có tài khoản Smart OTP nào được kích hoạt.',
  'smart_otp_active':
      'Tài khoản này chưa kích hoạt Smart OTP hoặc đã kích hoạt trên thiết bị khác. Bạn có muốn kích hoạt không? Đăng nhập để kích hoạt',
  'smart_otp_cancel_active': 'Bạn có muốn huỷ kích hoạt Smart OTP tài khoản này không?',
  'smart_otp_use_question': 'Bạn có muốn tiếp tục sử dụng SmartOTP không?',
  'smart_otp_qr_code_incorrect': 'Mã QR Code không đúng',
  'smart_otp_verify_code': 'Mã phê duyệt',
  'smart_otp_error_not_get_otp': 'Lỗi không lấy lại được OTP',
  'resend_otp_success': 'Gửi lại OTP thành công',

  //Time
  'month': 'tháng',
  'title_gotit': 'OK, TÔI ĐÃ HIỂU',
  'gotit': 'Đã hiểu',

  // transfer
  'title_bank': 'Ngân hàng',
  'title_select_city': 'Chọn tỉnh/thành phố',
  'title_select_brach': 'Chọn chi nhánh',
  'title_sender': 'Người gửi',
  'title_search_bank': 'Tìm ngân hàng',
  'title_vietnam_dong': 'Việt Nam đồng',

  // widget
  'title_note': 'Ghi chú: ',
  'title_select_date': 'Chọn ngày',
  'title_done': 'Xong',
  'title_input_amount_min': 'Nhập số tiền nhỏ nhất',
  'title_input_amount_max': 'Nhập số tiền lớn nhất',
  'title_type_amount': 'Loại tiền tệ',
  'title_month': 'Tháng %month',
  'title_register': 'ĐĂNG KÝ',
  'title_change_pin_success': 'Thay đổi mã PIN Smart OTP thành công',
  'title_success': 'Thành công',
  'title_sync_smart_otp': 'Đồng bộ thời gian Smart OTP',

  // ERROR
  'updating': 'Đang cập nhật',
  'year': '%value%/năm',
  'error_title_no_internet': 'Không có kết nối Internet',
  'title_cancel': 'Thoát',
  'error_title_enter_full_info': 'Vui lòng nhập đầy đủ thông tin!',
  'error_title_an_unknown': 'Lỗi không xác định!',
  'error_title_change_password_success': 'Đổi mật khẩu thành công!',
  'error_title_password_correct_format': 'Mật khẩu chưa đúng định dạng!',
  'error_title_password_incorrect': 'Mật khẩu không khớp!',
  'error_title_password':
      'Mật khẩu phải đảm bảo\n• Có ít nhất 8 ký tự\n• Có ít nhất một ký tự chữ cái viết thường (a-z)\n• Có ít nhất một ký tự chữ cái viết hoa (A-Z)\n• Có ít nhất một ký tự chữ số (0-9)\n• Có ít nhất một ký tự đặc biệt (@#\$%^&+=)\n• Không chứa các chuỗi 4 ký tự liên tiếp trên bàn phím (asdf, ASDF, 1234)\n• Không chứa khoảng trắng',

  // validator
  'title_out_of_character': 'Quá số ký tự quy định',
  'title_not_length_of_character': 'Chưa đủ số ký tự quy định',
  'title_email_format': 'Định dạng email cần theo chuẩn @abc.def',

  'title_vat_include': ' (Đã gồm VAT)',

  //==========================================================================
  //Connection
  'connection_time_out': 'Có lỗi xảy ra, vui lòng kiểm tra kết nối và thử lại!',

  //interest rate
  'other_amount': 'Số tiền gửi bất kỳ',
  'amount0to500m': 'Số tiền gửi nhỏ hơn 500 triệu',
  'amount500mto5b': 'Số tiền gửi từ 500 triệu đến dưới 5 tỷ',
  'amountBigger5b': 'Số tiền gửi từ 5 tỷ trở lên',
  'interest_end_of_period': 'Lĩnh lãi cuối kỳ',
  'interest_periodically': 'Lĩnh lãi định kỳ',
  'interest_prepaid': 'Lĩnh lãi trả trước',
  'interest_monthly': 'Định kỳ hàng tháng',
  'interest_quarterly': 'Định kỳ hàng quý',
  'interest_every_6_months': 'Định kỳ hàng 6 tháng',
  'interest_yearly': 'Định kỳ hàng năm',

  //confirm password
  'confirm_input_password': 'Vui lòng nhập mật khẩu để tiếp tục',
  'confirm_pass_title': 'Xác thực mật khẩu',
  'confirm_pass_note': '''<div style="line-height: 18pt; font-size: 13pt;"><strong>Lưu ý:</strong><br>
          <font style="color: green; font-weight: 600;">- </font>Xác nhận thay đổi bằng mật khẩu<br>
          <font style="color: green; font-weight: 600;">- </font>Tài khoản của bạn sẽ bị vô hiệu hóa khi bạn nhập sai mật khẩu 5 lần</div>''',

  //notification
  'title_setting_notification': 'Cài đặt thông báo',
  'title_preview': 'Xem trước biến động số dư',
  'content_preview':
      '''<div style="line-height: 16pt; font-size: 12pt">Khi tính năng bật, Quý khách có thể xem thông báo biến đông số dư ngay tại màn hình đăng nhập</br>
          <font style="color: green; font-weight: 600; font-size: 12pt">Lưu ý:</font> Tính năng này có rủi ro lộ thông tin giao dịch</div>''',
  'title_account_get_noti': 'Tài khoản nhận thông báo',
  'title_on_off': 'Bật/tắt',
  'title_account': 'Tài khoản',
  'title_wai_confirm': 'Chờ duyệt',

  'see_more': 'Xem thêm',
  'version': 'Phiên bản',
  'no_permission_for_feature': "Bạn không có quyền truy cập tính năng này!",
  'select_payroll_method': 'Chọn phương thức thanh toán lương',
  'can_not_save': 'Lưu không thành công',
  'config': "Thiết lập",
  'sotp_remove_activation': 'Đã xoá kích hoạt Smart OTP.',
  'trans_info_title': 'THÔNG TIN GIAO DỊCH',
  'trans_approve_successful': 'Duyệt/Xác nhận giao dịch thành công',
  'trans_approve_message':
      'Giao dịch đã được đưa vào hàng chờ để xử lý. Người dùng có thể kiểm tra trạng thái giao dịch tại danh mục Truy vấn',
  'trans_back_main': 'Về quản lý giao dịch',

  'message_no_notification': 'Chưa có thông báo!',
  'title_internal_payroll': 'Thanh toán lương nội bộ VPBank',
  'title_domestic_payroll': 'Thanh toán lương liên Ngân hàng',
  'title_not_permission_setting_balance':
      'Bạn không có quyền xem trước biến động số dư. Vui lòng vào cài đặt để bật tính năng xem trước biến động số dư',
  'title_day': 'ngày',
  'sotp_synced_success': 'Đã đồng bộ thành công',
  'sotp_remove_all_token': 'Xoá tất cả kích hoạt Smart OTP trên thiết bị này',
  'sotp_remove_all_token_msg': 'Bạn có chắc chắn muốn xoá tất cả kích hoạt Smart OTP trên thiết bị này không?',
  'sotp_remove_all_token_success_msg': 'Đã xoá tất cả kích hoạt Smart OTP trên thiết bị này.',
  'title_future_develop': 'Tính năng này đang trong quá trình phát triển!',
  'sotp_account_disable':
      'Smart OTP của bạn đã bị vô hiệu hoá do nhập sai quá số lần quy định. Vui lòng kích hoạt lại để tiếp sử dụng',
  'feedback_message':
      'Để cải tiến VPBank NEOBiz chúng tôi rất mong sự đóng góp ý kiến của bạn. Tham gia khảo sát ngay?',

  'login_to_see_notify': '%message. Bạn cần đăng nhập tài khoản %account để xem chi tiết',
  'see': 'Xem',
  'retry': 'Thử lại',

  ////phase 2-------------------------------------

  // Tiền gửi
  'existing_deposits': 'Tiền gửi hiện hữu',
  'open_online_deposits': 'Mở tiền gửi online',
  'user_vps_deposits': 'Tiền gửi NĐT - VPS',
  'user_normal_deposits': 'Tiền gửi thường',
  'deposit_type': 'Loại tiền gửi',
  'receive_interest_method': 'Phương thức nhận lãi',
  'open_now': 'Mở ngay',
  'interest_value': 'Lãi suất',
  'expert_profit': 'Lãi dự tính',
  'deposits': 'Số tiền gửi',
  'period': 'Kỳ hạn',
  'minimum': 'Tối thiểu 10 000 000 VND',
  'effective_date': 'Ngày hiệu lực',
  'expiration date': 'Ngày hết hạn',
  'evoucher_code': 'Mã Evoucher',
  'due_processing_method': 'Phương thức xử lý đến hạn',
  'account_receive_profit': 'Tài khoản nhận gốc, lãi khi đến hạn',
  'cif_refer': 'CIF người giới thiệu',
  'not_require': 'Không bắt buộc',
  'enter_evoucher': 'Nhập mã Evoucher',
  'note': 'Chú ý: ',
  'deposits_term_1': 'Nhấn vào nút "Tiếp tục", Quý khách đã đồng ý với',
  'trading_condition': 'Điều kiện giao dịch',
  'deposits_term_2': 'chung về tiền gửi có kỳ hạn bằng phương tiện điện tử',
  'select_period': 'Chọn kỳ hạn',
  'note_confirm_deposits':
      'Ngày hiệu lực, ngày đáo hạn và lãi suất áp dụng chính thức phụ thuộc vào ngày duyệt giao dịch thành công',
  'listed_interest_rate': 'Lãi suất niêm yết',
  'profit_interest_rate': 'Lãi suất ưu đãi',
  'max_interest_rate': 'Lãi suất không được vượt quá lãi suất NHNN %rate %',
  'get_rollover_err_msg': 'Lấy kỳ hạn thất bại',
  'notice_minimum_saving_amount': 'Số tiền gửi tối thiểu 10 000 000 VND',

  // ---------------------------------------------

  'listed_interest': 'Lãi suất niêm yết',

  // Current deposits
  'cds_title': 'TIỀN GỬI HIỆN HỮU',
  'cds_filter': 'Bộ lọc',
  'cds_online_deposits': 'Giao dịch Online',
  'cds_offline_deposits': 'Mở tại quầy',

// Current deposits - Detail
  'cdds_title': 'Giao dịch chờ duyệt',
  'cdds_account': 'Tài khoản nguồn',
  'cdds_amount': 'Số tiền gửi',
  'cdds_amount_in_words': 'Số tiền bằng chữ',
  'cdds_period': 'Kỳ hạn',
  'cdds_effective_date': 'Ngày hiệu lực',
  'cdds_maturity_date': 'Ngày đến hạn',
  'cdds_interest_method': 'Phương thức nhận lãi',
  'cdds_settlement_method': 'Phương thức xử lý đến hạn',
  'cdds_interest_rate': 'Lãi suất',
  'cdds_settlement_account': 'Tài khoản nhận gốc lãi khi đến hạn',
  'cdds_referral_cif': 'CIF người giới thiệu',
  'cdds_note': 'Ghi chú',
  'cdds_reject_reason': 'Lý do từ chối',
  'cdds_final_settlement': 'Tất toán',
  'cdds_final_settlement_title': 'Tất toán tiền gửi',
  'cdds_final_settlement_confirm_title': 'Xác nhận thông tin',
  'cdds_interest_in_term': 'Lãi suất trong hạn',
  'cdds_interest_early': 'Lãi suất tất toán trước hạn',
  'cdds_continue': 'Tiếp tục',
  'cdds_saving_notice': '''
  <span>Chú ý:</span> Ngày hiệu lực, ngày đáo hạn và lãi suất áp dụng chính thức phụ thuộc vào ngày duyệt giao dịch thành công
  ''',
  'cdds_online_notice': '''
  <span>Chú ý:</span> Quý khách tất toán hợp đồng tiền gửi có kỳ hạn online trước hạn chỉ được hưởng lãi suất không kỳ hạn theo quy định của VPBank
  ''',
  'cdds_offline_notice': '''
  <font style="color: green; font-weight: 600; font-size: 12pt">Chú ý:</font> Quý khách có nhu cầu tất toán hợp đồng tiền gửi có kỳ hạn trước hạn xin vui lòng thực hiện giao dịch trực tiếp tại quầy
  ''',

// Deposit item
  'di_amount': '''<p>%id - <span>%amount</span></p>''',
  'di_interest': 'Lãi suất %r - Kỳ hạn: %p',
  'di_account': 'Tài khoản',
  'di_amount_detail': 'Số tiền',
  'sav_prod_type': 'Loại giao dịch',
  'sav_prod_type_az': 'Mở tiền gửi',
  'sav_prod_type_closeaz': 'Tất toán',
  'sav_interest': 'Lãi suất: %i%/năm',
  'sav_term': 'Kỳ hạn: %t',

  // Transaction item
  'ti_debit_acc': 'TK nguồn',
  'ti_debit_acc_full': 'Tài khoản nguồn',
  'ti_saving_acc': 'TKTG',
  'ti_saving_acc_full': 'Tài khoản tiền gửi',
  'ti_interest_rate_value': '%i%/năm',
  'ti_info_title': 'Thông tin giao dịch %type',

  // Deposit manage
  'dms_title': 'Chờ duyệt',
  'dms_title_open_az': 'Chờ duyệt tiền gửi',
  'dms_title_close_az': 'Chờ duyệt tất toán',
  'dms_waiting_for_approval': 'Chờ duyệt',
  'dms_rejected': 'Bị từ chối',
  'dms_info': 'Thông tin giao dịch tiền gửi',
  'dms_reject_dialog_title': 'Thông báo',
  'dms_reject_dialog_content': 'Yêu cầu hủy giao dịch thành công',
  'dms_reject_dialog_button': 'Quay về danh sách tiền gửi',
  'dmcds_title': 'Phê duyệt thành công',
  'dmcds_back': 'Quay về danh sách chờ duyệt',

  // Close Az screens
  'caz_info_screen_title': 'Thông tin tiền gửi',
  'caz_init_screen_title': 'Tất toán tiền gửi',
  'caz_confirm_screen_title': 'Xác nhận thông tin',

// Filter
  'df_btn_open': 'Bộ lọc',
  'df_btn_close': 'Đóng',
  'df_period': 'Kỳ hạn',
  'df_period_dialog_title': 'Chọn kỳ hạn',
  'df_from_amount': 'Từ số tiền',
  'df_to_amount': 'Đến số tiền',
  'df_from_date': 'Từ ngày',
  'df_to_date': 'Đến ngày',
  'df_date_range_title': 'Chọn khoảng thời gian',
  'df_clear': 'Xóa',
  'df_apply': 'Áp dụng',
  'df_no_data': 'Không có giao dịch nào trong danh sách',
  'df_no_data_with_filter': 'Không có giao dịch nào đáp ứng điều kiện lọc',
  // transaction category
  'tc_transfer': 'Chuyển tiền',
  'tc_saving': 'Tiền gửi',
  'tc_payroll': 'TT lương',
  'tc_payroll_single': 'TT lương đơn lẻ',
  'tc_fx': 'GD FX',
  'tc_bill': 'TT Hóa đơn',
  ...payrollViVN,
  ...transactionStatusViVN,
  ...cardInfoViVn,
  ...cardHistoryViVn,
  ...loanViVN,
  ...taxManageViVN,
  ...billCheckerViVn,

  'transaction_noti_title': 'Giao dịch %value đã khởi tạo',
  'noti_transfer_content': 'Số tiền: %amount %ccy/ Nội dung: %content',
  'noti_saving_content': 'Số tiền: %amount %ccy/ Nội dung: %content',
  'noti_bill_content': 'Số tiền: %amount %ccy/ Loại giao dịch: Thanh toán hóa đơn',
  'skip_transaction_if_done': '(Vui lòng bỏ qua nếu giao dịch đã được xử lý)',

  //CARD
  'card': 'Thẻ',
  'card_debit': 'Thẻ ghi nợ',
  'card_credit': 'Thẻ tín dụng',
  'card_payment_credit_card': 'Thanh toán thẻ tín dụng',
  'card_payment_min': 'Thanh toán tối thiểu',
  'card_payment_all': 'Thanh toán toàn bộ',
  'card_payment_confirm_screen_title': 'Xác nhận thông tin',
  'account_payment': 'Tài khoản chuyển',
  'destination_card': 'Tới thẻ/ hợp đồng',
  'pick_payment_card': 'Chọn thẻ cần thanh toán',
  'export_file': 'Xuất file',
  'card_menu': 'Dịch vụ thẻ',
  'card_payment': 'Thanh toán thẻ',
  'card_get_contract_info_err': 'Lấy thông tin thẻ thất bại',

  //Tiền vay
  'loan': 'Tiền vay',
  'loan_balance': 'Dư nợ khoản vay',
  'see_detail': 'Xem chi tiết',
  'pick_statement_card': 'Chọn thẻ cần sao kê',
  'select_statement_period': 'Chọn kỳ sao kê',
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

  //Tài trợ thương mại
  'statement_lc': 'Sao kê giao dịch LC & nhờ thu',
  'statement_guarantee': 'Sao kê giao dịch bảo lãnh',
  'statement_ck': 'Sao kê giao dịch chiết khấu',
  'title_lc': 'LC & nhờ thu',
  'reference_number': 'Số tham chiếu',
  'enter_reference_number': 'Nhập số tham chiếu',
  'guarantee_number': 'Số bảo lãnh',
  'enter_guarantee_number': 'Nhập số bảo lãnh',
  'release_date': 'Ngày phát hành',
  'expire_date': 'Ngày đến hạn',
  'detail': 'Chi tiết',
  'title_bao_lanh': 'Bảo lãnh',
  'bao_lanh_number': 'Số bảo lãnh',
  'contract_number': 'Số hợp đồng',
  'enter_contract_number': 'Nhập số hợp đồng',
  'discount': 'Chiết khấu',
  'discount_date': 'Ngày chiết khấu',
  ...commerceViVn,

  //Thuế
  'tax_id': 'Mã số thuế',
  'register_tax': 'Đăng ký nộp thuế điện tử',
  'notice_tax_pending':
      'Mã số thuế <font style="color: green; font-weight: 600; font-size: 12pt">%s</font> của Quý khách đã được đăng ký tại ngân hàng và có trạng thái <font style="color: black; font-weight: 700; font-size: 12pt">Đang chờ duyệt</font>. Quý khách vui lòng kiểm tra lại',
  'notice_tax_reject':
      'Mã số thuế <font style="color: green; font-weight: 600; font-size: 12pt">%id</font> của Quý khách đã được đăng ký tại ngân hàng và có trạng thái <font style="color: black; font-weight: 700; font-size: 12pt">Bị từ chối</font> với lý do <font style="color: black; font-weight: 700; font-size: 12pt">%reason</font>. Quý khách vui lòng kiểm tra lại',
  'customer_info': 'Thông tin khách hàng',
  'tax_debit_account': 'Tài khoản nộp thuế',
  'fee_payment_account': 'Tài khoản thanh toán phí',
  'general_tax_info': 'II. Thông tin truy vấn từ Tổng cục Thuế',
  'tax_payer_name': 'Tên người nộp thuế',
  'email': 'Email',
  'phone_number': 'Số điện thoại',
  'career': 'Ngành nghề',
  'address': 'Địa chỉ',
  're_register': 'Đăng ký lại',
  'tax_condition': 'Cam kết đăng ký dịch vụ Nộp thuế điện tử',
  'notice_not_register_tct':
      'Mã số thuế <font style="color: green; font-weight: 600; font-size: 12pt">%id</font> chưa được đăng ký tại VPBank. Quý khách vui lòng kiểm tra lại',
  'back_to_main': 'QUAY LẠI MÀN HÌNH CHÍNH',
  'notice_tax_approved':
      'Mã số thuế <font style="color: green; font-weight: 600; font-size: 12pt">%id</font> của Quý khách đã được đăng ký nộp thuế điện tử tại VPBank. Quý khách vui lòng kiểm tra lại',
  'tax_menu_manage': 'Quản lý giao dịch đăng ký nộp thuế điện tử',
  'canceled': 'Giao dịch đã được hủy!',

  //FX
  'can_not_get_rate': 'Chưa lấy được tỉ giá',
  'fx_rate_note': 'Tỷ giá chính thức được xác định tại thời điểm người phê duyệt cuối cùng phê duyệt giao dịch',
  'fx_debit_amount': 'Số tiền trích nợ',
  'fx_estimate_conversion_amount': 'Số tiền chuyển quy đổi tạm tính',
  ...electricViVN,

  // JB/Root
  'root_notice': 'Để đảm bảo an toàn thông tin, VPBank NEOBiz không hoạt động trên các thiết bị đã jailbreak/root. Vui lòng sử dụng ứng dụng này trên các thiết bị chưa bị can thiệp hệ thống!',
  'root_close_app_btn': 'Đóng ứng dụng',
};
