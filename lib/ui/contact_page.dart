import "package:flutter/material.dart";

import "../helpers/contac_helper.dart";

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, required this.contact});

  final Contact contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editContact;

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      if (widget.contact == null) {
        _editContact = Contact();
      } else {
        _editContact = Contact.fromMap(widget.contact.toMap());
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editContact.name ?? "Novo contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }
}
