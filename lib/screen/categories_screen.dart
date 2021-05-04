import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/category.dart';
import 'package:many_vendor_ecommerce_app/provider/category_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/drawer_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/loader_screen.dart';
import 'package:many_vendor_ecommerce_app/screen/single_category_screen.dart';
import 'package:provider/provider.dart';

import '../Globals.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Data> categories = [];
  bool isLoading = true;

  getData() async {
    Category category =
        await Provider.of<CategoryProvider>(context, listen: false).hitApi();
    Provider.of<CategoryProvider>(context, listen: false).setData(category);

    setState(() {
      categories =
          Provider.of<CategoryProvider>(context, listen: false).getData();

      isLoading = false;
    });
  }

  @override
  void initState() {
    statusCheck(context);
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: customAppBar(context),
          drawer: Drawer(
            child: DrawerScreen(),
          ),
          body: isLoading
              ? LoaderScreen()
              : categories.length == 0
                  ? Empty()
                  : Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/background.png'),
                              fit: BoxFit.cover)),
                      child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              color: Colors.white,
                              child: ExpansionTile(
                                leading: Icon(
                                  FontAwesomeIcons.listUl,
                                  color: textBlackColor,
                                  size: 12,
                                ),
                                key: PageStorageKey<int>(1),
                                title: Text(
                                  Globals.arabic
                                      ? categories[index].nameAr
                                      : categories[index].name,
                                  style: menuStyle,
                                ),
                                children: parentCategory(
                                    categories[index].parent, context),
                              ),
                            );
                          }),
                    )),
    );
  }
}

List<Widget> parentCategory(List<Parent> parent, context) {
  List<Widget> parents = [];
  parent.forEach((element) {
    parents.add(Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10),
      child: ExpansionTile(
        leading: Icon(
          FontAwesomeIcons.angellist,
          size: 12,
          color: textBlackColor,
        ),
        key: PageStorageKey<int>(1),
        title: Text(
          Globals.arabic
              ? element.nameAr.toString() ?? element.name
              : element.name.toString(),
          style: menuStyle,
        ),
        children: childCategory(element.child, context),
      ),
    ));
  });
  return parents;
}

List<Widget> childCategory(List<Child> child, context) {
  List<Widget> childs = [];
  child.forEach((element) {
    childs.add(Container(
      color: Colors.white,
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleCategoryScreen(
                          trendingCategoryData: null,
                          id: element.id,
                        )));
          },
          title: Center(
            child: Text(
              Globals.arabic
                  ? element.nameAr.toString() ?? element.name.toString()
                  : element.name.toString(),
              style: menuStyle,
            ),
          )),
    ));
  });
  return childs;
}
