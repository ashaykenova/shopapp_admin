import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../db/category.dart';
import '../db/brand.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory = "test";
  String _currentBrand;

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  @override
  void initState() {
    _getCategories();
//    _getBrands();
    getCategoriesDropDown();
    print(categoriesDropDown.length);
//    _currentCategory = categoriesDropDown[0].value;
  }

  getCategoriesDropDown() {
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        categoriesDropDown.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data()['category']),
              value: categories[i].data()['category'],
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(
          Icons.close,
          color: black,
        ),
        title: Text(
          "Add product",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 40, 14, 40),
                        child: Icon(Icons.add, color: grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 40, 14, 40),
                        child: Icon(Icons.add, color: grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 40, 14, 40),
                        child: Icon(Icons.add, color: grey),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Enter product name",
                textAlign: TextAlign.center,
                style: TextStyle(color: red, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: "Product name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "You must enter the product name";
                  } else if (value.length > 10) {
                    return "Product name can't have more than 10 letters";
                  }
                  return null;
                },
              ),
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontStyle: FontStyle.italic),
                  decoration: InputDecoration(border: OutlineInputBorder())),
              suggestionsCallback: (pattern) async {
                return await BackendService.getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.category),
                  title: Text(suggestion['name']),
                );
              },
              onSuggestionSelected: (suggestion) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductPage(product: suggestion)));
              },
            )
          ],
        ),
      ),
    );
  }

  void _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }
}

//void _getBrands() async{
//}
