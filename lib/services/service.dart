import 'package:felimma/models/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceServices {
  String collection = "services";
  Firestore _firestore = Firestore.instance;

  Future<List<ServiceModel>> getServices() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<ServiceModel> services = [];
        for (DocumentSnapshot service in result.documents) {
          services.add(ServiceModel.fromSnapshot(service));
        }
        return services;
      });


  Future<List<ServiceModel>> searchServices({String serviceName}) {
    // code to convert the first character to uppercase
    String searchKey = serviceName[0].toUpperCase() + serviceName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
      List<ServiceModel> services = [];
      for (DocumentSnapshot service in result.documents) {
        services.add(ServiceModel.fromSnapshot(service));
      }
      return services;
    });
  }
}
