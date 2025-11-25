// import 'package:flutter/material.dart';
// import 'package:flutter_animated_splash/flutter_animated_splash.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// void main() async{
//     await Firebase.initializeApp(); // make sure google-services.json / GoogleService-Info.plist is set up

//   runApp( Loginpage());
// }

// class Loginpage extends StatefulWidget {
//   const Loginpage({super.key});

//     @override

//   LoginpageState createState() => LoginpageState();
// }

// class LoginpageState extends State<Loginpage>{
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameCtl = TextEditingController();
//   final TextEditingController _passwordCtl = TextEditingController();
//   bool _loading = false;
//   Future<void> _registerUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _loading = true);
//     final username = _usernameCtl.text.trim();
//     final password = _passwordCtl.text;

//     try {
//       final users = FirebaseFirestore.instance.collection('users');

//       // optional: simple uniqueness check
//       final existing = await users.where('username', isEqualTo: username).limit(1).get();
//       if (existing.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username already taken.')));
//       } else {
//         await users.add({
//           'username': username,
//           'password': password, // plain text storage (insecure — for demo only)
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved successfully.')));
//         _usernameCtl.clear();
//         _passwordCtl.clear();
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
      
//       //  padding: const EdgeInsets.all(16.0),
  


//       home: Scaffold(
//         backgroundColor:  Color.fromRGBO(255, 255, 255, 1),

//       body: ListView(
//       children: [
//  Column(
     
     
//       mainAxisAlignment: MainAxisAlignment.center,
//         children: [
          
//         Container(
          
//             decoration: BoxDecoration(color: const Color.fromARGB(248, 255, 251, 251), borderRadius:BorderRadius.circular(30),boxShadow:[BoxShadow(color: const Color.fromARGB(194, 229, 233, 229),blurRadius: 1,spreadRadius: 2,offset: Offset(1, 1))]),
//              height: 689,
//              width: 460,
//             padding: EdgeInsets.all(35),
//             margin: EdgeInsets.all(20),
//             child: 
            
//             Column(
//             //     mainAxisAlignment: MainAxisAlignment.start,
                

//               children: [ 
//                   Image.asset('assets/images/motels.webp',height: 120, fit: BoxFit.cover),
//             Center(
//                 child: SingleChildScrollView(
//                   child: Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(mainAxisSize: MainAxisSize.min, children: [
//                           const Text('Register (plain password)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 12),
//                           TextFormField(
//                             controller: _usernameCtl,
//                             decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
//                             validator: (v) {
//                               if (v == null || v.trim().isEmpty) return 'Enter username';
//                               if (v.trim().length < 3) return 'Minimum 3 characters';
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 12),
//                           TextFormField(
//                             controller: _passwordCtl,
//                             decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()),
//                             obscureText: true,
//                             validator: (v) {
//                               if (v == null || v.isEmpty) return 'Enter password';
//                               if (v.length < 4) return 'Minimum 4 characters';
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton.icon(
//                               icon: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
//                               label: Text(_loading ? 'Saving...' : 'Save'),
//                               onPressed: _loading ? null : _registerUser,
//                             ),
//                           ),
//                         ]),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
               
//   Container(
//                    padding: EdgeInsets.all(0),
//                    margin: EdgeInsets.all(0),
//                    child: Row(
                     
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [

//                              Image.asset('assets/images/amazon.webp',height: 35, fit: BoxFit.contain),
//                             Image.asset('assets/images/facebook.webp',height: 35, fit: BoxFit.contain),
//                            Image.asset('assets/images/google.webp',height: 35, fit: BoxFit.contain),
                      


//                     ],//children
//                   ),//column
//                 ),//container




//               ],//children
//             ),
//           ),

//         ],//children
//     ),
//               ],
  
//       ),
//       ),
      
//     );
//   }}




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameCtl = TextEditingController();
  final TextEditingController _passwordCtl = TextEditingController();
  bool _loading = false;

  Future<void> _loginOrRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final username = _usernameCtl.text.trim();
    final password = _passwordCtl.text;

    try {
      final users = FirebaseFirestore.instance.collection('users');

      // 🔍 Check if user already exists
      final existing = await users
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        // ✅ Login success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        _goToHome();
      } else {
        // 🚀 Register new user
        await users.add({
          'username': username,
          'password': password,
          'createdAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully!')),
        );
        _goToHome();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print("❌ Firestore error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/motels.webp', height: 120),
                const SizedBox(height: 30),
                const Text(
                  'Login / Register',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordCtl,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.login),
                    label:
                        Text(_loading ? 'Please wait...' : 'Login / Register'),
                    onPressed: _loading ? null : _loginOrRegister,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
