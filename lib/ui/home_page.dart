import "package:flutter/material.dart";

import "../helpers/contac_helper.dart";

class HomePage extends StatelessWidget {
  HomePage({super.key});

  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    Contact c = Contact();
    c.name = "Danilo";
    c.email = "Danilo@gmail.com";
    c.phone = "03249834";
    c.img = "img.txt";

    helper.saveContact(c);

    helper.getAllContacts().then((list) => print(list));
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
