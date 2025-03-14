import 'package:b2b/commons.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/data/model/search/beneficiary_saved_model.dart';

import 'ben_bank_model.dart';
import 'branch_model.dart';
import 'city_model.dart';

class NormalDisplaySearchModel {
  final int index; // sẽ tương ứng vs index của list data gốc từ server
  String searchKey = '';
  final String? iconLeft;
  final String? title;
  final String? subTitle;
  final String? iconRight;

  NormalDisplaySearchModel({
    required this.index,
    this.iconLeft,
    this.title,
    this.subTitle,
    this.iconRight,
    this.searchKey = '',
  });

  static NormalDisplaySearchModel convertFromBeneficiary(BeneficiarySavedModel data, int index) {
    return NormalDisplaySearchModel(
        index: index,
        searchKey: data.benAlias ?? '',
        iconLeft: getLetterAvatar((data.benAlias ?? "").trim()),
        title: data.benAlias,
        subTitle: "${data.benBankName} - ${data.benAccount}");
  }

  static NormalDisplaySearchModel convertFromBenBank(BenBankModel data, int index) {
    return NormalDisplaySearchModel(
      index: index,
      searchKey: "${data.shortName} ${data.fullName}",
      iconLeft: data.getLogo(),
      title: "${data.shortName}",
    );
  }

  static NormalDisplaySearchModel convertFromLocation(CityModel data, int index) {
    return NormalDisplaySearchModel(
      index: index,
      searchKey: '${data.cityName} ${data.cityCode}',
      title: data.cityName,
    );
  }

  static NormalDisplaySearchModel convertFromBranch(BranchModel data, int index) {
    return NormalDisplaySearchModel(
      index: index,
      searchKey: '${data.branchName} ${data.branchCode}}',
      title: data.branchName,
    );
  }
}
