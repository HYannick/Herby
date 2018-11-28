import 'package:flutter/material.dart';
import 'package:herby_app/theme.dart';
import 'package:transparent_image/transparent_image.dart';

class PlantSearchPage extends StatefulWidget {
  PlantSearchPage();

  @override
  PlantSearchPageState createState() {
    return new PlantSearchPageState();
  }
}

class PlantSearchPageState extends State<PlantSearchPage> {
  List<Map> results = [];
  String searchValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                backgroundColor: hWhite,
                expandedHeight: 100.0,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(50.0)),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/auth_background@2x.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: _buildSearchField()),
                  ],
                )),
              ),
              SliverList(
                  delegate: results.length == 0
                      ? SliverChildListDelegate([
                          SizedBox(
                            height: 300.0,
                          ),
                          Container(
                              height: 300.0,
                              child: Center(child: _buildEndListInfo()))
                        ])
                      : SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                          if (index == results.length - 1) {
                            return _buildEndListInfo();
                          }
                          return _buildPlantItem(context, index, results);
                        }, childCount: results.length))
            ],
          ),
        ));
  }

  Container _buildEndListInfo() {
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Cannot find it?',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w200),
        ),
        Text('Take a beautiful picture',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: hMainGreen)),
        Text(
          'And fill the database!',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w200),
        ),
        SizedBox(
          height: 50.0,
        )
      ],
    ));
  }

  Container _buildPlantItem(BuildContext context, index, results) {
    Map result = results[index];
    return Container(
      height: 80.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        elevation: 6.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: result['imgURL'],
                  width: 70.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  result['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(51, 51, 51, 0.1),
                    offset: Offset(4.0, 4.0),
                    spreadRadius: 1.0,
                    blurRadius: 5.0)
              ],
              borderRadius: BorderRadius.circular(40.0)),
          child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  hintText: 'What is your next plant? :D',
                  hintStyle: TextStyle(color: Colors.black38)),
              validator: (String value) {
                if (value.isEmpty || value.length <= 2) {
                  return 'Search text is required and should be 2+ characters long.';
                }
              },
              onFieldSubmitted: (String value) {
                searchValue = value;
                setState(() {
                  results = [
                    {
                      'imgURL': 'https://source.unsplash.com/200x202/?nature',
                      'name': 'Ecchi'
                    },
                    {
                      'imgURL': 'https://source.unsplash.com/200x203/?nature',
                      'name': 'Yaoi'
                    },
                    {
                      'imgURL': 'https://source.unsplash.com/200x204/?nature',
                      'name': 'Yuri'
                    },
                    {
                      'imgURL': 'https://source.unsplash.com/200x205/?nature',
                      'name': 'Patate'
                    },
                    {
                      'imgURL': 'https://source.unsplash.com/200x206/?nature',
                      'name': 'Patate'
                    },
                    {
                      'imgURL': 'https://source.unsplash.com/200x207/?nature',
                      'name': 'Patate'
                    },
                    {
                      'imgURL': 'https://source.unsplash.com/200x258/?nature',
                      'name': 'Patate'
                    },
                  ];
                });
              },
              onSaved: (String value) {
                print(value);
                searchValue = value;
              }),
        ),
      ),
    );
  }
}
