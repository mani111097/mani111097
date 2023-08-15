import 'package:flutter/material.dart';

class PurchaseData extends ChangeNotifier {
  List purchaseList = [];
  double subtotal = 0.0;
  double shippingcharge = 0.0;
  double total = 0.0;
  String gsttype = "";
  double balance = 0.0;
  double taxtype = 0;
  List gstList = [];
  List igstList = [];
  double gsttotal = 0;
  double gst0 = 0, gst5 = 0, gst12 = 0, gst18 = 0, gst28 = 0;
  double igst0 = 0, igst5 = 0, igst12 = 0, igst18 = 0, igst28 = 0;

  void updatePurchase(List purchaselist) {
    purchaseList = purchaselist;
    notifyListeners();
  }

  void updateSubtotal(List purchaselist) {
    double subTotal = 0;
    for (int i = 0; i < purchaselist.length; i++) {
      subTotal = subTotal + double.parse(purchaselist[i]["amount"].toString());
    }
    subtotal = subTotal;
    notifyListeners();
    //print("subTotal $subtotal");
  }

  void updateTotal(
      double subTotal, double tax, double shippingcharges, double taxtype) {
    if (taxtype == 1.0) {
      total = subTotal + shippingcharge;
    } else {
      total = subTotal + tax + shippingcharge;
    }

    notifyListeners();
  }

  void updategstType(String gsttype) {
    print(gsttype);
    this.gsttype = gsttype;
    notifyListeners();
  }

  void updateshippingCharge(String charge) {
    shippingcharge = double.parse(charge);
    notifyListeners();
  }

  void updateBalance(String balance) {
    this.balance = double.parse(balance);
    notifyListeners();
  }

  void taxoption(double taxtype) {
    this.taxtype = taxtype;
    notifyListeners();
  }

  void gst(List purchaselist) {
    for (int i = 0; i < purchaselist.length; i++) {
      gst0 =
          int.parse(purchaselist[i]["tax"].toString()) == 0 ? gst0 + 1 : gst0;
      gst5 = int.parse(purchaselist[i]["tax"].toString()) == 5
          ? gst5 + double.parse(purchaselist[i]["amount"].toString())
          : gst5;
      gst12 = int.parse(purchaselist[i]["tax"].toString()) == 12
          ? gst12 + double.parse(purchaselist[i]["amount"].toString())
          : gst12;
      gst18 = int.parse(purchaselist[i]["tax"].toString()) == 18
          ? gst18 + double.parse(purchaselist[i]["amount"].toString())
          : gst18;
      gst28 = int.parse(purchaselist[i]["tax"].toString()) == 28
          ? gst28 + double.parse(purchaselist[i]["amount"].toString())
          : gst28;
    }

    print("tax $taxtype");

    if (taxtype == 0.0) {
      gsttotal =
          (gst5 * 0.05) + (gst12 * 0.12) + (gst18 * 0.18) + (gst28 * 0.28);
      gstList = [
        {"tax": "0", "amount": gst0.toString()},
        {"tax": "5", "amount": (gst5 * 0.05).toStringAsFixed(2)},
        {"tax": "12", "amount": (gst12 * 0.12).toStringAsFixed(2)},
        {"tax": "18", "amount": (gst18 * 0.18).toStringAsFixed(2)},
        {"tax": "28", "amount": (gst28 * 0.28).toStringAsFixed(2)},
      ];
    } else {
      gsttotal = (gst5 * 5 / (100 + 5)) +
          (gst12 * 12 / (100 + 12)) +
          (gst18 * 18 / (100 + 18)) +
          (gst28 * 28 / (100 + 28));
      gstList = [
        {"tax": "0", "amount": gst0.toString()},
        {"tax": "5", "amount": (gst5 * 5 / (100 + 5)).toStringAsFixed(2)},
        {"tax": "12", "amount": (gst12 * 12 / (100 + 12)).toStringAsFixed(2)},
        {"tax": "18", "amount": (gst18 * 18 / (100 + 18)).toStringAsFixed(2)},
        {"tax": "28", "amount": (gst28 * 28 / (100 + 28)).toStringAsFixed(2)},
      ];
    }

    //print("gstList $gstList");
    notifyListeners();
  }

  void cleargst() {
    gstList = [];
    igstList = [];
    gst0 = 0;
    gst5 = 0;
    gst12 = 0;
    gst18 = 0;
    gst28 = 0;
    igst0 = 0;
    igst5 = 0;
    igst12 = 0;
    igst18 = 0;
    igst28 = 0;
    gsttotal = 0;
    notifyListeners();
  }

  void igst(List purchaselist) {
    for (int i = 0; i < purchaselist.length; i++) {
      igst0 =
          int.parse(purchaselist[i]["tax"].toString()) == 0 ? igst0 + 1 : igst0;
      igst5 = int.parse(purchaselist[i]["tax"].toString()) == 5
          ? igst5 + double.parse(purchaselist[i]["amount"].toString())
          : igst5;
      igst12 = int.parse(purchaselist[i]["tax"].toString()) == 12
          ? igst12 + double.parse(purchaselist[i]["amount"].toString())
          : igst12;
      igst18 = int.parse(purchaselist[i]["tax"].toString()) == 18
          ? igst18 + double.parse(purchaselist[i]["amount"].toString())
          : igst18;
      igst28 = int.parse(purchaselist[i]["tax"].toString()) == 28
          ? igst28 + double.parse(purchaselist[i]["amount"].toString())
          : igst28;
    }

    if (taxtype == 0.0) {
      gsttotal =
          (igst5 * 0.05) + (igst12 * 0.12) + (igst18 * 0.18) + (igst28 * 0.28);
      igstList = [
        {"tax": "0", "amount": igst0.toString()},
        {"tax": "5", "amount": (igst5 * 0.05).toStringAsFixed(2)},
        {"tax": "12", "amount": (igst12 * 0.12).toStringAsFixed(2)},
        {"tax": "18", "amount": (igst18 * 0.18).toStringAsFixed(2)},
        {"tax": "28", "amount": (igst28 * 0.28).toStringAsFixed(2)},
      ];
    } else {
      gsttotal = (igst5 * 5 / (100 + 5)) +
          (igst12 * 12 / (100 + 12)) +
          (igst18 * 18 / (100 + 18)) +
          (igst28 * 28 / (100 + 28));
      igstList = [
        {"tax": "0", "amount": igst0.toString()},
        {"tax": "5", "amount": (igst5 * 5 / (100 + 5)).toStringAsFixed(2)},
        {"tax": "12", "amount": (igst12 * 12 / (100 + 12)).toStringAsFixed(2)},
        {"tax": "18", "amount": (igst18 * 18 / (100 + 18)).toStringAsFixed(2)},
        {"tax": "28", "amount": (igst28 * 28 / (100 + 28)).toStringAsFixed(2)},
      ];
    }

    notifyListeners();
  }

  void clearCache() {
    purchaseList = [];
    subtotal = 0.0;
    shippingcharge = 0.0;
    gsttype = "";
    gstList = [];
    igstList = [];
    gst0 = 0;
    gst5 = 0;
    gst12 = 0;
    gst18 = 0;
    gst28 = 0;
    igst0 = 0;
    igst5 = 0;
    igst12 = 0;
    igst18 = 0;
    igst28 = 0;
    gsttotal = 0;
    notifyListeners();
  }
}
