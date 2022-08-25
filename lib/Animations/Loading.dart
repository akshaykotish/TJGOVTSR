import 'package:flutter/material.dart';
import 'package:governmentapp/HexColors.dart';


class LoadingAnim extends StatefulWidget {
  const LoadingAnim({Key? key}) : super(key: key);

  @override
  State<LoadingAnim> createState() => _LoadingAnimState();
}

class _LoadingAnimState extends State<LoadingAnim> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SkeletonDeptCard(),
            SkeltonCard(),
            SkeltonCard(),
            SizedBox(height: 20,),
          ],
        ),
      );
  }
}

class SkeletonDeptCard extends StatelessWidget {
  const SkeletonDeptCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 20,
          right: 10
      ),
      width: MediaQuery.of(context).size.width - 50,
      alignment: Alignment.centerLeft,
      child: Skelton(width: MediaQuery.of(context).size.width/2 + 50, height: 24,),
    );
  }
}


class SkeltonCard extends StatelessWidget {
  const SkeltonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 30,
        top: 20,
        bottom: 20,
      ),
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: Colors.grey[200]?.withOpacity(0.4),
      ),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        children: <Widget>[
          Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(child: Skelton(height: 85, width: 85,))),
          const SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2 + 20,
                child: Skelton(width: MediaQuery.of(context).size.width/2 + 20, height: 22,),
              ),
              SizedBox(height: 10,),
              Skelton(height: 10, width: MediaQuery.of(context).size.width/2,),
              SizedBox(height: 10,),
              Skelton(height: 10, width: MediaQuery.of(context).size.width/2 - 20,),
            ],
          )
        ],
      ),
    );
  }
}



class Skelton extends StatefulWidget {
  const Skelton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  State<Skelton> createState() => _SkeltonState();
}

class _SkeltonState extends State<Skelton> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;

  @override
  void initState() {
    super.initState();
    //Colors.black.withOpacity(0.3)
    controller =  AnimationController(vsync: this, duration: Duration(seconds: 3));
    colorAnimation = ColorTween(begin: Colors.grey.withOpacity(0.3), end: ColorFromHexCode("#605E3F").withOpacity(0.6)).animate(controller);
    sizeAnimation = Tween<double>(begin: 100.0, end: 200.0).animate(controller);
    controller.forward();
    controller.addListener(() {setState(() {});});
    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
        {
          controller.reverse();
        }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: colorAnimation.value,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
