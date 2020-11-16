import 'package:felimma/models/service.dart';
import 'package:felimma/services/service.dart';
import 'package:flutter/material.dart';

class ServiceProvider with ChangeNotifier{
  ServiceServices _serviceServices = ServiceServices();
  List<ServiceModel> services = [];
  List<ServiceModel> servicesSearched = [];


  ServiceProvider.initialize(){
    loadServices();
  }

  loadServices()async{
    services = await _serviceServices.getServices();
    notifyListeners();
  }


  Future search({String serviceName})async{
    servicesSearched = await _serviceServices.searchServices(serviceName: serviceName);
    notifyListeners();
  }

}