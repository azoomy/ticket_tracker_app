import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:localstorage/localstorage.dart';
import 'package:get/instance_manager.dart';

import 'package:flutter/material.dart';
import 'package:ticket_tracker_app/controllers/home_screen_controller.dart';
import 'package:ticket_tracker_app/controllers/sign_in_controller.dart';
import 'package:ticket_tracker_app/routes/routes.dart';

final LocalStorage storage = LocalStorage('ticket_tracker_app');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getitemFromLocalStorage() {}
  SignInController signInController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    getitemFromLocalStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    Size size = MediaQuery.of(context).size;
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add Column'),
                    content: TextField(
                      controller: controller.columnTitleController,
                      decoration:
                          const InputDecoration(hintText: 'Enter Column Title'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.addColumn();
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Column(children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Ticket Tracker',
                      style: TextStyle(
                          letterSpacing: 0.1,
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Text('Welcome, User!'),
                TextButton(
                  onPressed: () {
                    signInController.handleLogout();
                  },
                  child: const Text('Logout'),
                ),
                controller.tickets.isEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.3,
                        ),
                        child: const Text(
                            'No categories, add new category to add a ticket'),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.tickets.length,
                        itemBuilder: (context, index) {
                          List keysList = controller.tickets.keys.toList();
                          return ColumnCategory(
                            size: size,
                            title: keysList[index].toString(),
                            tickets: controller.tickets[keysList[index]],
                            allTickets: controller.tickets,
                          );
                        },
                      ),
              ]),
            ),
          ),
        ),
      );
    });
  }
}

class ColumnCategory extends StatefulWidget {
  const ColumnCategory({
    super.key,
    required this.size,
    required this.title,
    required this.tickets,
    required this.allTickets,
  });

  final Size size;
  final String title;
  final List tickets;
  final Map allTickets;

  @override
  State<ColumnCategory> createState() => _ColumnCategoryState();
}

class _ColumnCategoryState extends State<ColumnCategory> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return DragTarget(
          onWillAccept: (d) {
            return true;
          },
          onLeave: (d) => print("LEAVE 2!"),
          onAccept: (data) {
            controller.dragAndDropFunction(data, widget.title);
          },
          builder: (context, accepted, rejected) {
            return Column(
              children: [
                SizedBox(
                  height: widget.size.height * 0.02,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: widget.size.height * 0.03,
                              fontWeight: FontWeight.w300),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Add Ticket'),
                                        content: TextField(
                                          controller:
                                              controller.titleController,
                                          decoration: const InputDecoration(
                                              hintText: 'Enter Title'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              controller
                                                  .addTicket(widget.tickets);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Add'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.columnTitleController.text =
                                    widget.title;
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Edit Column'),
                                        content: TextField(
                                            controller: controller
                                                .columnTitleController),
                                        actions: [
                                          TextButton(
                                              onPressed: () {},
                                              child: const Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                controller.editColumnTitle(
                                                    widget.title);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Edit'))
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Category?'),
                                          content: const Text(
                                              "By Continuing, all the tickets in this category will be lost."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                controller.deleteCategory(
                                                    widget.title);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                accepted.isEmpty
                    ? Container()
                    : Container(
                        height: widget.size.height * 0.07,
                        width: widget.size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.tickets.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        LongPressDraggable(
                          onDragStarted: () => print("DRAG START!"),
                          onDragCompleted: () {
                            setState(() {});
                          },
                          onDragEnd: (details) => print("DRAG ENDED!"),
                          onDraggableCanceled: (data, data2) =>
                              print("DRAG CANCELLED!"),
                          data: [widget.title, widget.tickets[index]],
                          feedback: Container(
                            height: widget.size.height * 0.07,
                            width: widget.size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Ticket(
                            size: widget.size,
                            title: widget.tickets[index]['title'],
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            );
          });
    });
  }
}

class Ticket extends StatelessWidget {
  const Ticket({
    super.key,
    required this.size,
    required this.title,
  });

  final Size size;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title)],
          ),
        ),
      ),
    );
  }
}
