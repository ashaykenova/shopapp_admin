import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'add_product.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
                child: FlatButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.dashboard);
                    },
                    icon: Icon(Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive),
                    label: Text("Dashboard"))),
            Expanded(
                child: FlatButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.manage);
                    },
                    icon: Icon(
                      Icons.sort,
                      color: _selectedPage == Page.manage ? active : notActive,
                    ),
                    label: Text("Manage")))
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: _loadScreen(),
    );
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: [
            ListTile(
              subtitle: FlatButton.icon(
                  onPressed: null,
                  icon: Icon(
                    Icons.attach_money,
                    size: 30.0,
                    color: Colors.green,
                  ),
                  label: Text(
                    "12,000",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green),
                  )),
              title: Text(
                "Revenue",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
                child: GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                        child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.people_outline),
                          label:
                              Text("Users", style: TextStyle(fontSize: 9.0))),
                      subtitle: Text(
                        "7",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 50.0),
                      ),
                    ))),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.category),
                          label: Text(
                            "Categories",
                            style: TextStyle(fontSize: 9.0),
                          )),
                      subtitle: Text(
                        "23",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 50.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.category),
                          label: Text("Products",
                              style: TextStyle(fontSize: 9.0))),
                      subtitle: Text(
                        "120",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 50.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.category),
                          label: Text("Sold", style: TextStyle(fontSize: 9.0))),
                      subtitle: Text(
                        "13",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 50.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.category),
                          label:
                              Text("Orders", style: TextStyle(fontSize: 9.0))),
                      subtitle: Text(
                        "5",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: active, fontSize: 50.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Card(
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.category),
                          label:
                              Text("Return", style: TextStyle(fontSize: 9.0))),
                      subtitle: Text(
                        "0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: active,
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category List"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add brand"),
              onTap: () {
                _brandAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("Brand List"),
              onTap: () {
              },
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Category cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Add category",
          ),
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              if (categoryController.text != null) {
                _categoryService.createCategory(categoryController.text);
              }
              Fluttertoast.showToast(msg: 'Category created');
              Navigator.pop(context);
            },
            child: Text("Add")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Brand name cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Add Brand",
          ),
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              if (brandController.text != null) {
                _brandService.createBrand(brandController.text);
              }
              Fluttertoast.showToast(msg: 'Brand is created');
              Navigator.pop(context);
            },
            child: Text("Add")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
