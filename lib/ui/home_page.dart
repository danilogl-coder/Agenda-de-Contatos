import "dart:io";

import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import "../helpers/contac_helper.dart";
import "contact_page.dart";

enum OrderOption { orderaz, orderza }

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  initState() {
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOption>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOption>>[
              const PopupMenuItem<OrderOption>(
                child: Text("Orderna de A-Z"),
                value: OrderOption.orderaz,
              ),
              const PopupMenuItem<OrderOption>(
                child: Text("Orderna de Z-A"),
                value: OrderOption.orderza,
              )
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
        itemCount: contacts.length,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(children: [
            Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: _getDecorationImage(index),
                )),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contacts[index].name ?? "",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    contacts[index].email ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    contacts[index].phone ?? "",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  _getDecorationImage(index) {
    if (contacts[index].img != null) {
      return DecorationImage(
          image: FileImage(File(contacts[index].img)), fit: BoxFit.cover);
    } else {
      return AssetImage('images/logo.png');
    }
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              launchUrl(
                                  Uri.parse("tel:${contacts[index].phone}"));
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Ligar',
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactPage(contact: contacts[index]);
                            },
                            child: Text(
                              'Editar',
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                helper.deleteContact(contacts[index].id);
                                contacts.removeAt(index);
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              'Excluir',
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  _orderList(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        contacts.sort(
          (a, b) {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          },
        );
        break;
      case OrderOption.orderza:
        contacts.sort(
          (a, b) {
            return b.name.toLowerCase().compareTo(a.name.toLowerCase());
          },
        );
        break;
    }
    setState(() {});
  }
}
