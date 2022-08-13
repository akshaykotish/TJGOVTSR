import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Filtration/FilterPage.dart';
import 'package:governmentapp/Filtration/SearchSheet.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 20,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      JobDisplayManagement.isloadingjobs = true;
                      JobDisplayManagement.jobstoshow.clear();
                      var ToSearches = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchSheet()));
                      print("ToSearches: " + ToSearches.toString());
                      CurrentJob.CurrentSearchData.add(ToSearches);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("./assets/icons/search.png"),
                            )
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Text("Look at the jobs..", style: TextStyle(fontSize: 20, color: Colors.grey[400], fontWeight: FontWeight.bold, fontFamily: "Poppins"),),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseDepartment()));
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("./assets/icons/filter-results-button.png"),
                            )
                        ),
                      ),
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
