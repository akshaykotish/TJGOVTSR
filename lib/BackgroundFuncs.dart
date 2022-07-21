//
//
// import 'package:workmanager/workmanager.dart';
//
// class BackgroundFuncs{
//   static void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) {
//       print("Native called background task: $inputData"); //simpleTask will be emitted here.
//       return Future.value(true);
//     });
//   }
//
//   static void Init(){
//     Workmanager().initialize(
//         callbackDispatcher, // The top level function, aka callbackDispatcher
//         isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
//     );
//     Workmanager().registerOneOffTask("1", "simpleTask");
//   }
//
//   static void Load() async {
//     if(true)
//       {
//           Init();
//       }
//   }
// }