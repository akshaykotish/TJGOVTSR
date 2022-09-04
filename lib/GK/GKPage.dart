import 'package:flutter/material.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:url_launcher/url_launcher.dart';

class GKPage extends StatefulWidget {
  GKPage({required this.gkTodayData});

  GKTodayData gkTodayData;

  @override
  State<GKPage> createState() => _GKPageState();
}

class _GKPageState extends State<GKPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(widget.gkTodayData.URL)) {
        await launch(widget.gkTodayData.URL);
        }
        else {
        print("Can't launch ${widget.gkTodayData.URL}");
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.black,
              child: Image.network(widget.gkTodayData.Image, fit: BoxFit.fill,),
            ),
            Container(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Text(widget.gkTodayData.Heading, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, ),))
            ,
      Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
      child: Text(widget.gkTodayData.Date, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, ),)),
      Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
      child: Text(widget.gkTodayData.Content.length > 300 ? widget.gkTodayData.Content.substring(0, 300) + "..." : widget.gkTodayData.Content, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, ),)),
          ],
        ),
      ),
    );
  }
}
