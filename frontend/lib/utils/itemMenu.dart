import 'package:flutter/material.dart';

class ItemMenu {
  String label;
  Icon icon;
  ItemMenu(this.icon, this.label);
  ItemMenu.create(this.icon, this.label);
}

List<ItemMenu> menuOptions = [
  ItemMenu(
      Icon(
        Icons.article_outlined,
        color: Colors.grey,
      ),
      "Juegos"),
  ItemMenu(
      Icon(
        Icons.account_box_outlined,
        color: Colors.grey,
      ),
      "Puntaje")
];
