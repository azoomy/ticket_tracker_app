import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:localstorage/localstorage.dart';

class HomeController extends GetxController {
  final LocalStorage storage = LocalStorage('ticket_tracker_app');
  Map tickets = {};
  TextEditingController columnTitleController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    tickets = storage.getItem('tickets');
    update();
  }

  void addColumn() {
    tickets[columnTitleController.text] = [];
    columnTitleController.clear();
    update();
  }

  void addTicket(listOfTickets) {
    List newTickets = listOfTickets;

    newTickets.add({"title": titleController.text});
    storage.setItem('tickets', newTickets);
    titleController.clear();
    update();
  }

  void deleteCategory(title) {
    tickets.remove(title);
    storage.setItem('tickets', tickets);
    update();
  }

  void dragAndDropFunction(data, title) {
    List receivedData = data as List;
    if (title != receivedData[0]) {
      String receivedDataTitle = receivedData[0];
      List toRemoveFromList = tickets[receivedDataTitle];
      List toAddToList = tickets[title];
      toRemoveFromList.remove(receivedData[1]);
      toAddToList.add(receivedData[1]);
      storage.setItem('tickets', tickets);
    }
  }

  void editColumnTitle(title) {
    Map<String, dynamic> updatedMap = {};

    tickets.forEach((key, value) {
      if (key == title) {
        updatedMap[columnTitleController.text] = value;
      } else {
        updatedMap[key] = value;
      }
    });
    tickets = updatedMap;
    storage.setItem('tickets', tickets);

    update();
  }
}
