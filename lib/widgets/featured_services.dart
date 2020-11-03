import 'package:felimma/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'featured_card.dart';

class FeaturedServices extends StatefulWidget {
  @override
  _FeaturedServicesState createState() => _FeaturedServicesState();
}

class _FeaturedServicesState extends State<FeaturedServices> {
  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);

    return Container(
        height: 230,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: serviceProvider.services.length,
            itemBuilder: (_, index) {
              return FeaturedCard(
                service: serviceProvider.services[index],
              );
            }));
  }
}
