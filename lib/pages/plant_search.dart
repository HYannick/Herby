import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PlantSearchPage extends StatefulWidget {
  PlantSearchPage();

  @override
  PlantSearchPageState createState() {
    return new PlantSearchPageState();
  }
}

class PlantSearchPageState extends State<PlantSearchPage> {
  final Color greenyColor = Color.fromRGBO(39, 200, 181, 1.0);
  List<Map> results = [
    {'imgURL': 'https://source.unsplash.com/200x202/?nature', 'name': 'Ecchi'},
    {'imgURL': 'https://source.unsplash.com/200x203/?nature', 'name': 'Yaoi'},
    {'imgURL': 'https://source.unsplash.com/200x204/?nature', 'name': 'Yuri'},
    {'imgURL': 'https://source.unsplash.com/200x205/?nature', 'name': 'Patate'},
    {'imgURL': 'https://source.unsplash.com/200x206/?nature', 'name': 'Patate'},
    {'imgURL': 'https://source.unsplash.com/200x207/?nature', 'name': 'Patate'},
    {'imgURL': 'https://source.unsplash.com/200x258/?nature', 'name': 'Patate'},
  ];
  String searchValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: <Widget>[
          _buildSearchField(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  // return the header
                  return _buildSearchField();
                }
                index -= 1;

                return _buildPlantItem(context, index, results);
              },
              itemCount: results.length,
            ),
          )
        ],
      ),
    );
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
        key: _formKey,
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
              onSaved: (String value) => searchValue = value),
        ),
      ),
    );
  }
}
