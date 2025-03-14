import 'dart:async';
import 'dart:developer';

import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/otp/otp_resend_model.dart';
import 'package:b2b/scr/data/model/otp/verify_otp_data_model.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/otp/otp_model.dart';
import 'package:b2b/scr/data/repository/otp_repository.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({required this.otpRepository}) : super(const OtpState());

  final OtpRepositoryImpl otpRepository;

  @override
  Stream<OtpState> mapEventToState(
    OtpEvent event,
  ) async* {
    switch (event.runtimeType) {
      case OtpEventVerify:
        yield* _mapOtpVerifyState(event as OtpEventVerify, state);
        break;
      case OtpEventResend:
        yield* _mapOtpResendState(event as OtpEventResend, state);
        break;
      case OtpEventGetActivationCodeSmartOTP:
        yield* _mapGetActivationCodeSmartOTPState();
        break;
      case OtpEventVerifyMadeFund:
        yield* _mapOtpVerifyMadeFundState(
            event as OtpEventVerifyMadeFund, state);
        break;
      case OtpEventResendVerify:
        yield* _mapOtpResendVerifyState(event as OtpEventResendVerify, state);
        break;
    }
    // if (event is OtpEventVerify) {
    //   yield* _mapOtpVerifyState(event, state);
    // } else if (event is OtpEventResend) {
    //   yield* _mapOtpResendState(event, state);
    // } else if (event is OtpEventGetActivationCodeSmartOTP) {
    //   yield* _mapGetActivationCodeSmartOTPState();
    // } else if (event is OtpEventVerifyMadeFund) {
    //   yield* _mapOtpVerifyMadeFundState(event, state);
    // } else {
    //   log('otp_bloc no event');
    // }
  }

  Stream<OtpState> _mapGetActivationCodeSmartOTPState() async* {
    // throw the loading state
    yield const OtpState(
        otpGetActiveSOTPState:
            OtpVerifyMadeFundState(dataState: DataState.preload));
    try {
      log('_mapGetActivationCodeSmartOTPState');
      final responseData = await otpRepository.getActivationCodeStartOTP();
      OtpStatus verifyStatus;
      if (responseData.item.isSuccess()) {
        verifyStatus = OtpStatus.SUCCESS;
      } else {
        verifyStatus = OtpStatus.ERROR;
      }
      final state = OtpVerifyMadeFundState(
          dataState: DataState.data,
          status: verifyStatus,
          message: responseData.item.getMessage());
      yield OtpState(otpGetActiveSOTPState: state);
    } catch (e) {
      log('otp: catch error and return fail here' + e.toString());
      yield const OtpState(
          otpGetActiveSOTPState:
              OtpVerifyMadeFundState(dataState: DataState.error));
    }
  }

  Stream<OtpState> _mapOtpVerifyState(
      OtpEventVerify event, OtpState state) async* {
    // throw the loading state
    yield const OtpState(
        otpVerifyState: OtpAuthState(dataState: DataState.preload));
    try {
      log('event.otpCode ${event.otpCode}');
      final responseData = await otpRepository.verifyOtp(
          event.username, event.otpCode, event.otpSession);
      final code = responseData.item.result?.code;
      OtpStatus verifyStatus;
      if (code == '200') {
        verifyStatus = OtpStatus.SUCCESS;
      } else if (code == '403') {
        verifyStatus = OtpStatus.LOCKED;
      } else {
        verifyStatus = OtpStatus.ERROR;
      }
      yield OtpState(
        otpVerifyState: OtpAuthState(
          model: responseData.item,
          dataState: DataState.data,
          status: verifyStatus,
        ),
      );
    } catch (e) {
      log('otp: catch error and return fail here' + e.toString());
      yield const OtpState(
          otpVerifyState: OtpAuthState(dataState: DataState.error));
    }
  }

  Stream<OtpState> _mapOtpResendState(
      OtpEventResend event, OtpState state) async* {
    // throw the loading state
    yield const OtpState(
        otpResendState: OtpAuthState(dataState: DataState.preload));
    try {
      final responseData =
          await otpRepository.resendOtp(event.username, event.otpSession);
      final code = responseData.item.result?.code;
      OtpStatus resendStatus;
      if (code == '201' || code == '200') {
        resendStatus = OtpStatus.SUCCESS;
      } else {
        resendStatus = OtpStatus.ERROR;
      }
      yield OtpState(
        otpResendState: OtpAuthState(
          model: responseData.item,
          dataState: DataState.data,
          status: resendStatus,
        ),
      );
    } catch (e) {
      log('otp: catch error and return fail here' + e.toString());
      yield const OtpState(
          otpResendState: OtpAuthState(dataState: DataState.error));
    }
  }

  Stream<OtpState> _mapOtpVerifyMadeFundState(
      OtpEventVerifyMadeFund event, OtpState state) async* {
    // throw the loading state

    Logger.debug('_mapOtpVerifyMadeFundState');
    yield const OtpState(
        otpVerifyMadeFundState:
            OtpVerifyMadeFundState(dataState: DataState.preload));
    try {
      final responseData =
          await otpRepository.verifyMadeFund(event.toMap(), event.getUrl());
      final code = responseData.item.result?.code;
      OtpStatus resendStatus;
      if (responseData.item.result?.isSuccess() == true) {
        resendStatus = OtpStatus.SUCCESS;
      } else if (code == '405') {
        resendStatus = OtpStatus.LOGGED_OUT;
      } else if (code == '0') {
        resendStatus = OtpStatus.VERIFY_ERROR_00;
      } else if (code == '01') {
        resendStatus = OtpStatus.VERIFY_ERROR_01;
      } else {
        resendStatus = OtpStatus.ERROR;
      }
      yield OtpState(
        otpVerifyMadeFundState: OtpVerifyMadeFundState(
            model: responseData.item
                .toModel((json) => VerifyOtpDataModel.fromJson(json)),
            dataState: DataState.data,
            status: resendStatus,
            message: responseData.item.result?.getMessage()),
      );
    } catch (e) {
      log('otp: catch error and return fail here' + e.toString());
      yield const OtpState(
          otpVerifyMadeFundState:
              OtpVerifyMadeFundState(dataState: DataState.error));
    }
  }

  Stream<OtpState> _mapOtpResendVerifyState(
      OtpEventResendVerify event, OtpState state) async* {
    Logger.debug("start");
    yield const OtpState(
        otpResendVerifyState:
            OtpResendVerifyState(dataState: DataState.preload));
    try {
      final response = await otpRepository.resendVerifyOtp(
          event.otpTypeCode, event.transcode);
      final SingleResponse<OtpResendModel> resend =
          SingleResponse<OtpResendModel>(
        response.data,
        (itemJson) => OtpResendModel.fromJson(itemJson),
      );
      OtpStatus resendStatus = response.result?.isSuccess() == true
          ? OtpStatus.SUCCESS
          : OtpStatus.ERROR;

      yield OtpState(
        otpResendVerifyState: OtpResendVerifyState(
          dataState: DataState.data,
          status: resendStatus,
          model: resend.item,
          errMessage: response.result?.getMessage(),
        ),
      );
    } catch (e) {
      log('otp: catch error and return fail here' + e.toString());
      yield OtpState(
          otpResendVerifyState: OtpResendVerifyState(
              dataState: DataState.error,
              errMessage: AppTranslate.i18n.errorNoReasonStr.localized));
    }
  }
}
