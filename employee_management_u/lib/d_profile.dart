import 'package:flutter/material.dart';

class DummyProfile extends StatefulWidget {
  const DummyProfile({super.key});

  @override
  State<DummyProfile> createState() => _DummyProfileState();
}

class _DummyProfileState extends State<DummyProfile> {
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
   appBar:  AppBar(
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_new),
    onPressed: () {
      // Handle back button press
    },
  ),
  title: Center(
    child: Text(
      'Profile',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),

  actions: [
    
    PopupMenuButton<String>(
      onSelected: (value) {
        // Handle item selection from the popup menu
        if (value == 'edit') {
          // Handle edit action
        } else if (value == 'delete') {
          // Handle delete action
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: Text('Edit'),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    ),
  ],
),

      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          
          child: Column(children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 70,
                  
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text("Shobha Kumari", style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
            // Text("shobha@gmail.com"),
            SizedBox(height: 20,),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Achievement",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      Icon(Icons.arrow_forward_ios)
                    ],),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
             Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Contact information",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      
                    ],),
                    Divider(color: Colors.grey[300],),
                    //  SizedBox(
                    //       height: 10,
                    //     ),
                        Text("Mobile number : "),
                         Divider(color: Colors.grey[300],),
                        Text("Email : "),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20,),
             Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text("General information",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      
                      
                    ],),
                    Divider(color: Colors.grey[300],),
                    Text('Job title : '),
                    Divider(color: Colors.grey[300],),
                          Text('Joining date : '),
                          Divider(color: Colors.grey[300],),
                        
                          Text(
                            'Company name : ',
                          ),
                          Divider(color: Colors.grey[300],),
                          Text(
                              "Employee id : "),
                              Divider(color: Colors.grey[300],),
                          Text("Department : "),
                          Divider(color: Colors.grey[300],),
                          Text(
                              "Employment status : "),
                              Divider(color: Colors.grey[300],),
                          Text("Maneger id : "),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
             Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Additional information",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold ),),
                      
                    ],),
                    Divider(color: Colors.grey[300],),
                    //  SizedBox(
                    //       height: 10,
                    //     ),
                        Text("Address : "),
                  ],
                ),
              ),
            ),
          ],),
        ),
      )),
    );
  }
}