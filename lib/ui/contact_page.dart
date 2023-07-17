import "dart:io";

import "package:flutter/material.dart";

import "../helpers/contac_helper.dart";
import "package:image_picker/image_picker.dart";

class ContactPage extends StatefulWidget {
  ContactPage({super.key, this.contact});

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      if (widget.contact == null) {
        _editContact = Contact();
      } else {
        _editContact = Contact.fromMap(widget.contact!.toMap());
        _nameController.text = _editContact.name;
        _emailController.text = _editContact.email;
        _phoneController.text = _editContact.phone;
      }
    }

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editContact.name ?? "Novo contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editContact.name != null && _editContact.name.isNotEmpty) {
                Navigator.pop(context, _editContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: _getDecorationImage(),
                      )),
                  onTap: () {
                    ImagePicker()
                        .pickImage(source: ImageSource.camera)
                        .then((file) {
                      if (file == null) {
                        return;
                      } else {
                        setState(() {
                          _editContact.img = file.path;
                        });
                      }
                    });
                  },
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus, //Criei um focus daora
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editContact.name = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "E-mail"),
                  onChanged: (text) {
                    _userEdited = true;

                    _editContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Phone"),
                  onChanged: (text) {
                    _userEdited = true;

                    _editContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => await _requestPop());
  }

  _getDecorationImage() {
    if (_editContact.img != null) {
      return DecorationImage(
          image: FileImage(File(_editContact.img)), fit: BoxFit.cover);
    } else {
      return AssetImage('images/logo.png');
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Sim"))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
