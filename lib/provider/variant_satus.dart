
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_ecommerce_app/model/product_details.dart';

class VariantStatus  extends ChangeNotifier{

  bool active;
  int variantId;
  List<Variant> allVariant=[];

  setVariant(List<Variant> variant){
    allVariant = variant;
  }

  changeStatus(Variant vari){
    allVariant.forEach((element) {
      if (element.unit == vari.unit) {
        if (vari.variantId == element.variantId) {
          element.active = vari.active == true ? false : true;
          active = element.active;
        } else {
          element.active = false;
          active = element.active;
        }
      }
    });
    notifyListeners();
  }

 bool getVariant(){
   return active;
  }
}