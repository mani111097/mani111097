import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasitu_login/module/sharedpreference.dart';

class CustomerName {
  final String name;
  final Map json;

  const CustomerName({required this.name, required this.json});

  static CustomerName fromJson(Map<String, dynamic> json) =>
      CustomerName(name: json['companyName'], json: json);
}

class CustomerApi {
  static Future<List<CustomerName>> getCustomerSuggestions(String query) async {
    final PrefService _prefService = PrefService();
    String id = await _prefService.readId().then((value) => value);
    List customerList = [];
    print(id);

    await FirebaseFirestore.instance
        .collection("Customers")
        .where('uid', isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        customerList.add(element.data());
      });
    });
    print(customerList);
    return customerList
        .map((json) => CustomerName.fromJson(json))
        .where((element) {
      final namelower = element.name.toLowerCase();
      final querylower = query.toLowerCase();

      return namelower.contains(querylower);
    }).toList();
  }
}
