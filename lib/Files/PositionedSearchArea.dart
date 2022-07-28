import 'package:flutter/material.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Filtration/FilterPage.dart';
import 'package:governmentapp/Filtration/SearchSheet.dart';
import 'package:governmentapp/HexColors.dart';

class PositionedSearchArea extends StatefulWidget {
  const PositionedSearchArea({Key? key}) : super(key: key);

  @override
  State<PositionedSearchArea> createState() => _PositionedSearchAreaState();
}

class _PositionedSearchAreaState extends State<PositionedSearchArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).padding.top + 80,
      padding: EdgeInsets.only(
        left:5,
        bottom: 5,
        right: 5,
        top: MediaQuery.of(context).padding.top + 5,
      ),
      color: ColorFromHexCode("#3498DB"),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: 80,
        margin: const EdgeInsets.only(
          top: 5,
          left: 5,
          right: 5,
          bottom: 5,
        ),
        decoration: const BoxDecoration(
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                var ToSearches = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchSheet()));
                CurrentJob.CurrentSearchData.add(ToSearches);
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 130,
                height: MediaQuery.of(context).padding.top + 60,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  bottom: 10,
                  right: 20,
                ),
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
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FilterPage()));
              },
              child: Container(
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
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: ColorFromHexCode("#3498DB"),
              ),
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Icon(
                    Icons.favorite_outlined,
                    color: ColorFromHexCode("#F4F6F7")
                ),
              ),

            ),
          ],
        ),
      )
    );
  }
}
