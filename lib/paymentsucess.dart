import 'package:flutter/material.dart';

void main() {
  runApp( PaymentSucess());
}

class PaymentSucess extends StatefulWidget {
  const PaymentSucess({super.key});

  @override
  PaymentSucessState createState() => PaymentSucessState();
}
  class PaymentSucessState extends State<PaymentSucess>{
    @override

  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
                backgroundColor:  Color.fromRGBO(234, 236, 234, 1),

        body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
           
            
  
    Column(
     
     
      mainAxisAlignment: MainAxisAlignment.center,   
      crossAxisAlignment: CrossAxisAlignment.center,
      children:[


        Container(
          
            decoration: BoxDecoration(color: const Color.fromARGB(248, 255, 251, 251), borderRadius:BorderRadius.circular(30),boxShadow:[BoxShadow(color: const Color.fromARGB(194, 229, 233, 229),blurRadius: 1,spreadRadius: 1,offset: Offset(1, 1))]),
             height: 340,
             width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(15.5),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,


              children: [ 
                  Image.asset('assets/images/suc3.png',height: 100, fit: BoxFit.cover),




Container(
          
            
            padding: EdgeInsets.all(44),
            margin: EdgeInsets.all(1),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,


              children: [ 

                  Text("PAYMENT SUCCESS",style: TextStyle(fontSize: 20,color:const Color.fromARGB(255, 6, 7, 6),fontWeight: FontWeight.bold),),
                  Text(" AND",style: TextStyle(fontSize: 20,color:const Color.fromARGB(255, 17, 20, 18),fontWeight: FontWeight.bold), ),
                  Text("ORDER PLACED",style: TextStyle(fontSize: 20,color:const Color.fromARGB(255, 6, 7, 6),fontWeight: FontWeight.bold),),


              ],//children
              
            ),
            
        ),
   
           

 Container(
          
            decoration: BoxDecoration(color: const Color.fromARGB(248, 14, 122, 255), borderRadius:BorderRadius.circular(30),boxShadow:[BoxShadow(color: const Color.fromARGB(194, 229, 233, 229),blurRadius: 1,spreadRadius: 2,offset: Offset(1, 1))]),
             height: 33,
             width: 160,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(5),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,   


              children: [ 

                Text("GO CART",style: TextStyle(fontSize: 22,color:const Color.fromARGB(255, 6, 7, 6),fontWeight: FontWeight.bold), ),




              ],//children
              
            ),
            
        ),
   





              ],//children
              
            ),
            
        ),

 
    

       
      ],//children  
    ),
   ],//children
               
            
    ),
      ),
    );    
         
  }
}
