import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ez/screens/view/models/Search_model.dart';
import 'package:ez/screens/view/models/allProduct_modal.dart';
import 'package:ez/screens/view/models/categories_model.dart';
import 'package:ez/screens/view/newUI/home1.dart';
import 'package:ez/screens/view/newUI/productDetails.dart';
import 'package:ez/screens/view/newUI/sub_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez/constant/global.dart';
import 'package:http/http.dart' as http;

import '../../../models/GetLocationCityModel.dart';
import 'detail.dart';

// ignore: must_be_immutable
class SearchProduct extends StatefulWidget {
  bool? back;

  SearchProduct({this.back});

  @override
  _ServiceTabState createState() => _ServiceTabState();
}

class _ServiceTabState extends State<SearchProduct> {
  SearchModel? allProduct;
  TextEditingController controller = new TextEditingController();
  TextEditingController searchcController = new TextEditingController();
  String? selectedCountry;
  dynamic selectedState;

  List<String> countries = ['India', 'USA', 'Other'];
  Map<String, List<String>> statesByCountry = {
    'India': ['Delhi', 'Maharashtra', 'Karnataka'],
    'USA': ['New York', 'California', 'Texas'],
    'Other': ['Country1', 'Country2', 'Country3'],
  };

  @override
  void initState() {
    super.initState();
    getAllProduct();
    _getCollection();
    getLocationCity();
  }

  AllCateModel? collectionModal;

  _getCollection() async {
    print("working here");
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print(baseUrl.toString());

    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print("checking data here ${userData}");
    if (mounted) {
      setState(() {
        collectionModal = AllCateModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  getAllProduct() async {
    var uri = Uri.parse('${baseUrl()}/search');
    var request = new http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'text': controller.text,
    });

    var response = await request.send();
    print(request);
    print("ololo ${baseUrl()}/search and ${request.fields}");
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        allProduct = SearchModel.fromJson(userData);
      });
    }

    print(responseData);
  }

  GetLocationCityModel? locationCityModel;

  getLocationCity() async {
    print("working here");
    var uri = Uri.parse('${baseUrl()}/get_location');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print(baseUrl.toString());

    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print("checking location data here $userData");
    if (mounted) {
      setState(() {
        locationCityModel = GetLocationCityModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  LocationData? locationValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10, right: 0, left: 0),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.green,
                borderRadius: new BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              height: 45,
              child: Center(
                child: TextField(
                  controller: controller,
                  onChanged: onSearchTextChanged,
                  autofocus: true,
                  style: TextStyle(color: Colors.grey),
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    hintText: "What are you looking for?",
                    contentPadding: EdgeInsets.only(top: 10.0),
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(
                      Icons.tv_outlined,
                      color: Colors.grey[600],
                      size: 25.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          centerTitle: false,
          elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: null,
          actions: <Widget>[
            // Container(
            //   width: 50,
            //   child: IconButton(
            //     padding: const EdgeInsets.all(0),
            //     icon: Text(
            //       "Cancel",
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 13,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         controller.clear();
            //         onSearchTextChanged("");
            //       });
            //       Navigator.pop(context);
            //     },
            //   ),
            // ),
            Container(width: 25),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            collectionModal == null
                ? SizedBox.shrink()
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, left: 15),
                              child: Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width / 1.2,
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child:
                                      // DropdownButtonHideUnderline(
                                      //   child: DropdownButton2<LocationData?>(
                                      //     hint: const Text('Choose Your Location',
                                      //       style: TextStyle(
                                      //           color: Colors.black,fontWeight: FontWeight.w500,fontSize:15
                                      //       ),
                                      //     ),
                                      //     value: locationValue,
                                      //     icon: const Padding(
                                      //       padding: EdgeInsets.only(left:0.0),
                                      //       child: Icon(Icons.keyboard_arrow_down_rounded,  color: Colors.black,size: 30,),
                                      //     ),
                                      //     style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                      //     underline: Padding(
                                      //       padding: const EdgeInsets.only(left: 0,right: 0),
                                      //       child: Container(
                                      //         // height: 2,
                                      //         color: Colors.white,
                                      //       ),
                                      //     ),
                                      //     onChanged: (LocationData? value) {
                                      //       setState(() {
                                      //         locationValue = value!;
                                      //         // _getCities("${stateValue!.id}");
                                      //         // stateName = stateValue!.name;
                                      //         // print("name herererb $stateName");
                                      //       });
                                      //     },
                                      //     items: locationCityModel?.data?.map((items) {
                                      //       return DropdownMenuItem(
                                      //         value: items,
                                      //         child: Container(
                                      //             child: Column(
                                      //               children: [
                                      //                 Text(items.name.toString(),
                                      //
                                      //
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //         ),
                                      //       );
                                      //     }).toList(),
                                      //   ),
                                      // ),
                                      DropdownButton<dynamic>(
                                    hint: const Text(
                                      'Choose Your Location',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    value: selectedState != null
                                        ? selectedState
                                        : null,
                                    icon: const Padding(
                                      padding: EdgeInsets.only(left: 0.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                    underline: Container(),
                                    onChanged: (newValue) {
                                      print(newValue);

                                      setState(() {
                                        selectedState = newValue;
                                      });
                                    },
                                    items: locationCityModel?.data
                                        ?.expand<dynamic>((country) {
                                      return [
                                        "${country.id}",
                                        DropdownMenuItem<dynamic>(
                                          value: country.name,
                                          child: Text(
                                            country.name ?? "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...country.cities?.map((state) {
                                              return DropdownMenuItem<dynamic>(
                                                value:
                                                    '${country.name} - ${state.name}',
                                                child: InkWell(
                                                  onTap: () {
                                                    print(state.name);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child:
                                                        Text(state.name ?? ""),
                                                  ),
                                                ),
                                              );
                                            })?.toList() ??
                                            [],
                                      ];
                                    }).map<DropdownMenuItem<dynamic>>(
                                            (dynamic value) {
                                      return DropdownMenuItem<dynamic>(
                                        value: value,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [value],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 12),
                        //   child: Text(
                        //     "Choose Your Location",
                        //     style: TextStyle(fontSize: 15),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 15),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width/1.2,
                        //     child: TextField(
                        //       controller: searchcController,
                        //       onChanged: onSearchTextChanged,
                        //       autofocus: true,
                        //       style: TextStyle(color: Colors.grey),
                        //       decoration: new InputDecoration(
                        //         border: new OutlineInputBorder(
                        //           borderSide: new BorderSide(color: Colors.grey),
                        //           borderRadius: const BorderRadius.all(
                        //             const Radius.circular(10.0),
                        //           ),
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: new BorderSide(color: Colors.grey),
                        //           borderRadius: const BorderRadius.all(
                        //             const Radius.circular(10.0),
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: new BorderSide(color: Colors.grey),
                        //           borderRadius: const BorderRadius.all(
                        //             const Radius.circular(10.0),
                        //           ),
                        //         ),
                        //         filled: true,
                        //         hintStyle:
                        //         new TextStyle(color: Colors.black, fontSize: 14),
                        //         hintText: "Choose Your Location",
                        //         contentPadding: EdgeInsets.only(top: 10.0),
                        //         fillColor: Colors.grey[200],
                        //         prefixIcon: Icon(
                        //           Icons.search,
                        //           color: Colors.grey[600],
                        //           size: 25.0,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10),
                        Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: collectionModal!.categories!.length > 4
                                  ? 4
                                  : collectionModal!.categories!.length,
                              itemBuilder: (c, i) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SubCategoryScreen(
                                                id: collectionModal!
                                                    .categories![i].id!,
                                                name: collectionModal!
                                                    .categories![i].cName!,
                                                image: collectionModal!
                                                    .categories![i].img,
                                                description: collectionModal!
                                                    .categories![i].description,
                                              )
                                          // ViewCategory(id: categories.id!, name: categories.cName!)
                                          ),
                                    );
                                  },
                                  child: Container(
                                    height: 20,
                                    margin: EdgeInsets.only(right: 10),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.6))),
                                    child: Text(
                                        "${collectionModal!.categories![i].cName}"),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
            Expanded(child: serviceWidget())
          ],
        ));
  }

  Widget serviceWidget() {
    return controller.text == ""
        ? Container(
            child: Center(
              child: Text("No result found"),
            ),
          )
        : allProduct == null
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : allProduct!.restaurants!.length > 0
                ? _searchResult.length != 0 ||
                        controller.text.trim().toLowerCase().isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          //physics: NeverScrollableScrollPhysics(),
                          primary: false,
                          padding: EdgeInsets.all(5),
                          itemCount: _searchResult.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 200 / 250,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return itemWidget(_searchResult[index]);
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          //physics: NeverScrollableScrollPhysics(),
                          primary: false,
                          padding: EdgeInsets.all(5),
                          itemCount: allProduct!.restaurants!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 200 / 250,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return itemWidget(allProduct!.restaurants![index]);
                          },
                        ),
                      )
                : Center(
                    child: Text(
                      "Don't have any product",
                      style: TextStyle(
                        color: appColorBlack,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
  }

  Widget itemWidget(Restaurants products) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(resId: products.resId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 180,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: Image.network(products.logo.toString()),
                        ),
                      ],
                    ),
                    Container(height: 5),
                    Text(
                      products.resName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: appColorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Icon(Icons.local_offer_outlined, size: 20),
                                Container(width: 5),
                                Text(
                                  "${products.base_currency}" + products.price!,
                                  style: TextStyle(
                                      color: backgroundblack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        /*Container(
                          decoration: BoxDecoration(
                              color: appColorOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: appColorWhite,
                              size: 20,
                            ),
                          ),
                        )*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    allProduct!.restaurants!.forEach((userDetail) {
      if (userDetail.resName != null) if (userDetail.resName!
          .toLowerCase()
          .contains(text.toLowerCase())) _searchResult.add(userDetail);
    });
    setState(() {});
  }
}

List _searchResult = [];
