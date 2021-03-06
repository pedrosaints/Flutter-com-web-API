import 'package:bytebank_3/components/progress.dart';
import 'package:bytebank_3/database/dao/contact_dao.dart';
import 'package:bytebank_3/models/contact.dart';
import 'package:bytebank_3/screens/transaction_form.dart';
import 'package:flutter/material.dart';

import 'contact_form.dart';

class ContactsList extends StatefulWidget {

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {

  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: List(),
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){

            case ConnectionState.none:
              // TODO: Handle this case.
              // Para Startar o future
              break;
            case ConnectionState.waiting:
              return Progress();
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              // Stream
              break;
            case ConnectionState.done:
              // TODO: Handle this case.
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Contact contact = contacts[index];
                  return _ContactItem(
                    contact,
                    onClick: () {
                      _showTransactionForm(context,contact);
                    },
                  );
                },
                itemCount: contacts.length,
              );
              break;
          }

          return Text('Unkown error');

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          )
              .then((value) => {setState(() {})});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


void _showTransactionForm(BuildContext context, Contact contact) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TransactionForm(contact),
    ),
  );
}


class _ContactItem extends StatelessWidget {

  final Contact contact;
  final Function onClick;

  _ContactItem(
      this.contact, {
        @required this.onClick,
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24.0,),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0,),
        ),
      ),
    );
  }
}