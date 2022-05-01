import 'package:flutter/material.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Filtration/SearchSheet.dart';
import 'package:governmentapp/HexColors.dart';

class SearchArea extends StatefulWidget {
  const SearchArea({Key? key}) : super(key: key);

  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorFromHexCode("#F4F6F7"),
      width: MediaQuery.of(context).size.width,
      height: 300,
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 50,
            child: Text("Where are you", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25, fontFamily: "Poppins", color: Colors.grey[800],),),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            child: Text("looking for a job?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 33, fontFamily: "Poppins", color: Colors.grey[900]),),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 100,
            margin: const EdgeInsets.only(
              top: 20,
              left: 0,
              right: 0,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: ColorFromHexCode("#F4F6F7"),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: .5,
                        blurRadius: .5,
                        offset: Offset(.5,.5),
                      ),
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: .5,
                        blurRadius: .5,
                        offset: -Offset(.5,.5),
                      ),
                    ],
                    color: ColorFromHexCode("#F4F6F7"),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 20,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      var ToSearches = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchSheet()));
                      print("ToSearches: " + ToSearches.toString());
                      CurrentJob.CurrentSearchData.add(ToSearches);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.search, color: Colors.grey[900], size: 30,),
                        SizedBox(width: 20,),
                        Text("Search for a job...", style: TextStyle(fontSize: 18, color: Colors.grey[800]),),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: ColorFromHexCode("#3498DB"),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.filter_list_outlined,
                      color: ColorFromHexCode("#F4F6F7"),
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
