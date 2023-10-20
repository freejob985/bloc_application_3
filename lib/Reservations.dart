// ignore: file_names
import 'dart:core';

class Reservations {
  int? id;
  String? seat;
  String? Product;
  String? Quantity;
  String? Total;
  String? Check;
  String? TIME;
  String? Section;
  Reservations(
      {this.id,
      this.seat,
      this.Product,
      this.Quantity,
      this.Total,
      this.Check,
      this.TIME,
      this.Section});
  factory Reservations.fromJson(Map<String, dynamic> json) {
    return Reservations(
      id: json['Reservations']['id'],
      seat: json['Reservations']['name'],
      Product: json['Reservations']['image'],
      Quantity: json['Reservations']['email'],
      Total: json['Reservations']['email'],
      Check: json['Reservations']['email'],
      TIME: json['Reservations']['email'],
      Section: json['Reservations']['email'],
    );
  }
}
