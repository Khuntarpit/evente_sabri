import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  String? category;
  Timestamp? date;
  String? description;
  String? id;
  String? location;
  double? mapsLangLink;
  double? mapsLatLink;
  int? price;
  String? title;
  String? type;
  String? userDesc;
  String? userName;
  String? time;
  String? userProfile;
  String? image;
  int? ticket;
  int? count;
  int? joined;
  int? join;
  LatLng? latLng;
  Map<String, dynamic>? joinEvent;
  String? typePayment;


  Event(
      {this.category,
      this.date,
      this.description,
    this.joinEvent,
      this.id,
      this.location,
      this.time,
      this.mapsLangLink,
      this.mapsLatLink,
      this.typePayment,
      this.price,
      this.joined,
      this.title,
      this.type,
      this.userDesc,
      this.ticket,
      this.userName,this.join,
      this.image,
      this.count,
      this.latLng,
      this.userProfile});

  factory Event.fromFirestore(DocumentSnapshot snapshot){
    Map data = snapshot.data() as Map<dynamic, dynamic>;


    LatLng latLng = LatLng(double.parse(data['mapsLatLink'].toString()), double.parse(data['mapsLangLink'].toString()));
    return Event(
       category : data['category'],
    date  : data['date'],
    image: data['image'],
    description  : data['description'],
    id  : snapshot.id,
    latLng: latLng,
    count: data['count'],
    location  : data['location'],
    typePayment: data['typePayment'],
    time: data['time'],
    mapsLangLink  : data['mapsLangLink'],
    mapsLatLink  : data['mapsLatLink'],
    price  : data['price'],
    title  : data['title'],
    type  : data['type'],
    ticket: data['ticket'],
    joined: data['joined'],
    join: data['join'],
    userDesc  : data['userDesc'],
    userName  : data['userName'],
    userProfile  : data['userProfile'],
      joinEvent: data['joinEvent'] ?? {},
    );
  }
}

