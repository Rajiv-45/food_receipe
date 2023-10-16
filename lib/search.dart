import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_receipe/reciepe_model.dart';
import 'package:food_receipe/recipe_view.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  String query;
  Search({super.key, required this.query});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String finalurl = "";
  bool isloading = true;
  TextEditingController searchController = TextEditingController();
  List reciptCatList = [
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    }
  ];
  List<ReceipeModel> receipelist = [];

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=bf6fe6d8&app_key=ee12fd2719a6528bab371ec048245d6a";
    var response = await http.get(Uri.parse(url));
    // print("Hi");
    Map data = jsonDecode(response.body);
    //print(data);
    //log(data.toString());
    setState(() {
      data["hits"].forEach((element) {
        ReceipeModel receipeModel = ReceipeModel();
        receipeModel = ReceipeModel.fromMap(element["recipe"]);
        receipelist.add(receipeModel);
        setState(() {
          isloading = false;
        });
        // log(receipelist.toString());
      });
      receipelist.forEach((Recipe) {
        print(Recipe.label);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff213A50), Color(0xff071938)])),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search(
                                          query: searchController.text)));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something!"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: isloading
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: receipelist.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (receipelist[index]
                                      .url
                                      .contains("http://")) {
                                    finalurl = receipelist[index]
                                        .url
                                        .toString()
                                        .replaceAll("http://", "https://");
                                  } else {
                                    finalurl = receipelist[index].url;
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecipeView(url: finalurl)));
                                },
                                child: Card(
                                  margin: EdgeInsets.all(20.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  elevation: 0.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          receipelist[index].image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      ),
                                      Positioned(
                                          left: 0,
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: Text(
                                                receipelist[index].label,
                                                // maxLines: 1,
                                                // overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                                //maxLines: 2,
                                              ))),
                                      Positioned(
                                          right: 0,
                                          height: 40,
                                          width: 80,
                                          child: Container(
                                            //color: Colors.amber,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                )),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department,
                                                    size: 20,
                                                  ),
                                                  Text(receipelist[index]
                                                      .Calories
                                                      .toString()
                                                      .substring(0, 6)),
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
