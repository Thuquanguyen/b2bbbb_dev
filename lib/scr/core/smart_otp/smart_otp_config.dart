part of 'smart_otp_manager.dart';

const SOTP_PREFIX = 'B2B_';
const SOTP_APP_ID = '5';
const _KEYPASS_SERVER_URL_DEV = 'https://test-etoken.vpbank.com.vn/keypass.wsmobile/';
const _KEYPASS_SERVER_URL_PRO = 'https://kpwsmobile.vpbank.com.vn/keypass.wsmobile/';

class SmartOTPResult {
  const SmartOTPResult({required this.code, required this.message});

  final int code;
  final NameModel message;

  bool isSuccess() {
    return code == 0;
  }
}

String getKeyPassUrl() =>
    AppEnvironmentManager.environment == AppEnvironment.Dev ? _KEYPASS_SERVER_URL_DEV : _KEYPASS_SERVER_URL_PRO;

List<SmartOTPResult> buildResult() => [
      SmartOTPResult(
        code: 0,
        message: NameModel(
          valueVi: 'Thành công',
          valueEn: 'Successful',
        ),
      ),
      SmartOTPResult(
        code: 21,
        message: NameModel(
          valueVi: 'Sai mã PIN',
          valueEn: 'PIN incorrect',
        ),
      ),
      SmartOTPResult(
        code: 28,
        message: NameModel(
          valueVi: 'Lỗi kết nối: Kết nối đến server bị timeout',
          valueEn: 'Error: Connection timeout',
        ),
      ),
      SmartOTPResult(
        code: 56,
        message: NameModel(
          valueVi: 'Lỗi kết nối: Không thể kết nối đến server',
          valueEn: 'Error: Connection timeout',
        ),
      ),
      SmartOTPResult(
        code: 89,
        message: NameModel(
          valueVi: 'Kích hoạt sai 5 lần liên tiếp',
          valueEn: 'Wrong activation five times in a row',
        ),
      ),
      SmartOTPResult(
        code: 90,
        message: NameModel(
          valueVi: 'Mã kích hoạt hết hạn',
          valueEn: 'Activation code is expired',
        ),
      ),
      SmartOTPResult(
        code: 91,
        message: NameModel(
          valueVi: 'Sai mã kích hoạt',
          valueEn: 'Activation code is incorrect',
        ),
      ),
      SmartOTPResult(
        code: 93,
        message: NameModel(
          valueVi: 'Không thành công',
          valueEn: 'Unsuccessful',
        ),
      ),
      SmartOTPResult(
        code: 97,
        message: NameModel(
          valueVi: 'Mã kích hoạt hết hạn hoặc đã sử dụng',
          valueEn: 'Activation code is expired or used',
        ),
      ),
    ];
