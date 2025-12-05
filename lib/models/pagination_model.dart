import 'package:nb_utils/nb_utils.dart';

class Pagination {
  var currentPage;
  var totalPages;
  var totalItems;

  Pagination({this.totalPages, this.totalItems, this.currentPage});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalPages: json['totalPages'] != null ? json['totalPages'].toString().toInt() : null,
      totalItems: json['total_items'] != null ? json['total_items'].toString().toInt() : null,
      currentPage: json['currentPage'] != null ? json['currentPage'].toString().toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['totalPages'] = totalPages;
    data['total_items'] = totalItems;
    data['currentPage'] = currentPage;
    return data;
  }
}