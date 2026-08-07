import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      body: Column(

        children: [

          Container(

            height: 220,

            width: double.infinity,

            decoration: const BoxDecoration(

              color: Color(0xffF8BBD0),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),

            ),

            child: SafeArea(

              child: Padding(

                padding: const EdgeInsets.all(20),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: const [

                        Icon(Icons.menu, size: 30),

                        CircleAvatar(

                          radius: 25,

                          backgroundColor: Colors.white,

                          child: Icon(Icons.person),

                        ),

                      ],

                    ),


                    const SizedBox(height: 30),


                    const Text(

                      "My Tasks",

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight: FontWeight.bold,

                      ),

                    ),


                    const SizedBox(height: 5),


                    const Text(

                      "Today you have tasks",

                      style: TextStyle(fontSize: 16),

                    ),

                  ],

                ),

              ),

            ),

          ),


          const SizedBox(height: 20),


          Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection("tasks")
        .snapshots(),
    builder: (context, snapshot) {

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text("No Tasks Yet"),
        );
      }

      var tasks = snapshot.data!.docs;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tasks.length,
        itemBuilder: (context, index) {

          var task = tasks[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.pink,
                size: 35,
              ),
              title: Text(task["title"]),
            ),
          );
        },
      );
    },
  ),
),
        ],

      ),


      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.pink,

        child: const Icon(Icons.add),


        onPressed: (){


          TextEditingController taskController =
              TextEditingController();



          showDialog(

            context: context,

            builder: (context){


              return AlertDialog(


                title: const Text("Add Task"),


                content: TextField(

                  controller: taskController,

                  decoration: const InputDecoration(

                    hintText: "Enter task",

                  ),

                ),



                actions: [


                  TextButton(

                    onPressed: () async {


                      if(taskController.text.isNotEmpty){


                        await FirebaseFirestore.instance

                            .collection("tasks")

                            .add({

                              "title": taskController.text,

                              "createdAt": DateTime.now(),

                            });



                      }


                      Navigator.pop(context);


                    },


                    child: const Text("Add"),

                  ),


                ],


              );


            },


          );


        },


      ),


    );

  }

}