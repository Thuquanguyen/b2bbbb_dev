class ExportCardStatementResponse {
  String? data;
  String? fileName;

  ExportCardStatementResponse({this.data, this.fileName});

  static ExportCardStatementResponse fromJson(Map<String, dynamic> json) {
    return ExportCardStatementResponse(
      data: json['meta_data'] as String?,
      fileName: json['file_name'] as String?,
    );
  }
}
