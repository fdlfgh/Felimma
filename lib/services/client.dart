import 'package:felimma/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientServices {
  String collection = "client";
  Firestore _firestore = Firestore.instance;

  Future<List<ClientModel>> getClients() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<ClientModel> clients = [];
        for (DocumentSnapshot client in result.documents) {
          clients.add(ClientModel.fromSnapshot(client));
        }
        return clients;
      });


  Future<List<ClientModel>> searchClients({String clientName}) {
    // code to convert the first character to uppercase
    String searchKey = clientName[0].toUpperCase() + clientName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<ClientModel> clients = [];
      for (DocumentSnapshot client in result.documents) {
        clients.add(ClientModel.fromSnapshot(client));
      }
      return clients;
    });
  }
}
