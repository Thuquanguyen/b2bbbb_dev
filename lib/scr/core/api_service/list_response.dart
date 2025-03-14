import 'package:b2b/scr/data/model/search/ben_bank_model.dart';
import 'package:b2b/scr/data/model/search/branch_model.dart';
import 'package:b2b/scr/data/model/search/city_model.dart';

class ListResponse<T> {
  ListResponse(dynamic json, T Function(dynamic itemJson) itemConverter) {
    if (json is List) {
      items = json.map(itemConverter).toList();
    } else if (json is Map) {
      items = json.values.map(itemConverter).toList();
    }
  }

  List<T> items = [];

  BenBankModel? getBenBankByNo(String no, bool returnDummy) {
    for (var b in items) {
      if (b is BenBankModel && b.bankNo == no) {
        return b;
      }
    }

    if (returnDummy) {
      return BenBankModel(bankNo: no, fullName: no, shortName: no);
    }
  }

  CityModel? getCityByCode(String code, bool returnDummy) {
    for (var c in items) {
      if (c is CityModel && c.cityCode == code) {
        return c;
      }
    }

    if (returnDummy) {
      return CityModel(cityCode: code, cityName: code);
    }
  }

  BranchModel? getBranchByCode(String code, bool returnDummy) {
    for (var b in items) {
      if (b is BranchModel && b.branchCode == code) {
        return b;
      }
    }

    if (returnDummy) {
      return BranchModel(branchCode: code, branchName: code);
    }
  }

  @override
  String toString() {
    return items.map((f) => f.toString()).toString();
  }
}
