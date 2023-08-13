// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataItems {
  String id;
  String ho;
  String tenDem;
  String ten;
  String firstName;
  String middleName;
  String lastName;
  DataItems({
    required this.id,
    required this.ho,
    required this.tenDem,
    required this.ten,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory DataItems.fromJson(Map<String, dynamic> jsonData) {
    return DataItems(
      id: jsonData['id'],
      ho: jsonData['ho'],
      tenDem: jsonData['tenDem'],
      ten: jsonData['ten'],
      firstName: jsonData['firstName'],
      middleName: jsonData['middleName'],
      lastName: jsonData['lastName'],
    );
  }

  static Map<String, dynamic> toMap(DataItems item) => {
        'id': item.id,
        'ho': item.ho,
        'tenDem': item.tenDem,
        'ten': item.ten,
        'firstName': item.firstName,
        'middleName': item.middleName,
        'lastName': item.lastName,
      };

  static String encode(List<DataItems> item) => json.encode(
        item
            .map<Map<String, dynamic>>((item) => DataItems.toMap(item))
            .toList(),
      );

  static List<DataItems> decode(String item) =>
      (json.decode(item) as List<dynamic>)
          .map<DataItems>((item) => DataItems.fromJson(item))
          .toList();
}
