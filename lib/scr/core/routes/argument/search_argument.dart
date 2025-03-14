import 'package:b2b/scr/presentation/screens/normal_search_screen.dart';

class SearchArgument {
  final Function(Object?) searchCallBack;
  final SearchType searchType;
  final int? transferTypeCode;
  final String? bankCode;
  final String? cityCode;

  SearchArgument(
      {required this.searchCallBack, required this.searchType, this.transferTypeCode, this.bankCode, this.cityCode});
}
