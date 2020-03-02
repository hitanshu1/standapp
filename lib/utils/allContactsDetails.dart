import 'package:flutter/material.dart';
import 'package:standapp/components/contactCard.dart';

List<String> names = [
  "Aman",
  "Chandu",
  "Ajey",
  "Abhay",
  "Bro",
  "Champu",
  "Bobby",
  "Don John",
  "Zack",
  "Golu"
];
List<ContactCard> card = [];
List<String> sortName = [];
List<String> alpha = [];
sorting() {
  for (int i = 0; i < alphabet.length; i++) {
    names.forEach((name) {
      if (name.toLowerCase().startsWith(alphabet[i].toLowerCase())) {
        // if (i == 0) {
        //   card.add(ContactCard(name: name));
        // }
        // if (i > 0) {
        //   if ((card[i]
        //       .name
        //       .toLowerCase()
        //       .startsWith(alphabet[i].toLowerCase()))) {
        //     card.add(ContactCard(name: name));
        //   }
        // }

        card.add(ContactCard(name: name));

        if (!(alpha.contains(alphabet[i]))) {
          alpha.add(alphabet[i].toUpperCase());
        }
        print(name);
        print(alpha);
      }
    });
    print("yo ${card.length}");
    // return card;
  }
  return card;
}

List<String> alphabet = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
];
