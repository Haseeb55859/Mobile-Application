import 'package:flutter/material.dart';

class MaximumBid extends StatefulWidget {
  const MaximumBid({super.key});

  @override
  State<MaximumBid> createState() => _MaximumBidState();
}

class _MaximumBidState extends State<MaximumBid> {
  int _currentBid = 100; // starting bid (you can change it)

  void _increaseBid() {
    setState(() {
      _currentBid += 50; // increment by $50
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIP&SAP'),
        
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  color: Colors.yellow,
                  height: 40.0,
                  width: 40.0,
                ),

                Padding(padding: EdgeInsets.all(16.0),),
                Expanded(child:Container(
                   color: Colors.amber,
                   height: 40.0,
                   width: 40.0,
                ) ,
                ),
                Padding(padding: EdgeInsets.all(16.0),),
                Container(
                  color: Colors.brown,
                  height: 40.0,
                  width: 40.0,
                )
              ],
            ),
               Padding(padding: EdgeInsets.all(16.0),),
               Row2()
          ],          
        )),
        
      ))
    );
  }
}

class Row2 extends StatelessWidget {
  const Row2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
     children: [
       Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisSize: MainAxisSize.max,
         children: [
           Container(
             color: const Color.fromARGB(255, 112, 235, 12),
              height: 60.0,
              width: 60.0,
           ),
           Padding(padding: EdgeInsets.all(16.0),),
           Container(
             color: Colors.black,
             height: 40.0,
             width: 40.0,
    
           ),
           Padding(padding: EdgeInsets.all(16.0),),
           Container(
             color: Colors.blue,
             height: 20.0,
             width: 20.0,
           ),
           Divider(),
           Row(
             children: [
                      CircleAvatar(
                       backgroundColor: Colors.lightGreen,
                       radius: 200.0,
                       child: Stack(
                         children: [
                           Container(
                             height: 100.0,
                             width: 100.0,
                             color: Colors.yellow,
                           ),
                           Container(
                             height: 60.0,
                             width: 60.0,
                             color: Colors.amber,
    
                           ),
                           Container(
                             height: 40.0,
                             width: 40.0,
                             color: Colors.brown,
                           ),
                         ],
                       ),
                      )
             ],
           )
    
         ],
       )
     ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MaximumBid(),
  ));
}

