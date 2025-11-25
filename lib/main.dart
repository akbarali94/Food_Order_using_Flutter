// import 'package:flutter/material.dart';

// import 'package:flutter_animated_splash/flutter_animated_splash.dart';

// import 'package:carousel_slider/carousel_slider.dart';

// import 'home.dart';
// import 'search.dart';
// import 'cart.dart';
// import 'profile.dart';
// import 'login.dart';

// void main() {
//   runApp(MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

  
//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       home: AnimatedSplash(
//         type: Transition.fade,
//         curve: Curves.fastEaseInToSlowEaseOut,
//         navigator: NavBarPage(),
//         backgroundColor: Colors.black,
//         durationInSeconds: 1,
//         child: Image.asset(
//           'assets/images/Motel_Court.gif',
//           width: 500,   // adjust this as needed
//           height: 500,  // adjust this as needed
//           fit: BoxFit.cover, // optional - scales the image to fit
//         ),
//       ),
//     );
//   }
// }

//    class NavBarPage extends StatefulWidget{
//   const NavBarPage({super.key});

//   @override
//   _NavBarPageState createState() => _NavBarPageState();
// }

// class _NavBarPageState extends State<NavBarPage>{

//   int pageIndex = 0;

//   final pages=[Loginpage(),Home(),Search(),cart(),profile()];

//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
  
//          // appBar: AppBar(title: Text("FOOD DELIVERY APP "),backgroundColor: const Color.fromRGBO(255, 255, 255, 255),),
//           appBar: AppBar(
//           title: const Text("MOTEL COURT 🍕 "),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: () {},
//                hoverColor: Colors.amberAccent,
//             ),

//  IconButton(
//               icon: const Icon(Icons.shopping_cart_outlined),
//               onPressed: () {},
//                hoverColor: Colors.amberAccent,
//             ),

//           ],
//           ),
//       backgroundColor:  Color.fromARGB(255, 255, 255, 255),
      
  
//      body: (pages)[pageIndex],
      
    
//       bottomNavigationBar: BottomNav(context),
    

//     );
//   }



//   Container BottomNav(BuildContext context)
  
//   {
//     return Container(
//       decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 252),
//       borderRadius: BorderRadius.circular(20)),
//       margin: EdgeInsets.all(20),
//       height: 60,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
        
//         children: [
          
//           IconButton(onPressed: (){
//             setState(() {
//               pageIndex=0;
//             });
//           }, icon: pageIndex==0
//             ? Icon(
//               Icons.home_filled,
//               size: 30,
//             )
//             :Icon(
//               Icons.home_outlined,
//               size: 30,
//             )
//           ),



//           IconButton(onPressed: (){
//             setState(() {
//               pageIndex=1;
//             });
//           }, icon: pageIndex==1
//             ? Icon(
//               Icons.search_rounded,
//               size: 30,
//             )
//             :Icon(
//               Icons.search_outlined,
//               size: 30,
//             )
//           ),


// IconButton(onPressed: (){
//             setState(() {
//               pageIndex=2;
//             });
//           }, icon: pageIndex==2
//             ? Icon(
//               Icons.shopping_cart_rounded,
//               size: 30,
//             )
//             :Icon(
//               Icons.shopping_cart_outlined,
//               size: 30,
//             )
//           ),

// IconButton(onPressed: (){
//             setState(() {
//               pageIndex=3;
//             });
//           }, icon: pageIndex==3
//             ? Icon(
//               Icons.people_rounded,
//               size: 30,
//             )
//             :Icon(
//               Icons.people_outline,
//               size: 30,
//             )
//           ),

      
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Initialize Firebase once here
  print("🔥 Firebase initialized successfully");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
