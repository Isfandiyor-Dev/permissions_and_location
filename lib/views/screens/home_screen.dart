import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesson_72_permissions/controllers/travel_controller.dart';
import 'package:lesson_72_permissions/models/travel.dart';
import 'package:lesson_72_permissions/services/location_service.dart';
import 'package:lesson_72_permissions/views/widgets/add_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await LocationService.getCurrentLcoation();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final myLocation = LocationService.currentLocation;

    print(myLocation);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        centerTitle: true,
        title: const Text("Travel"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.scrim,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const AddDialog(),
          );
        },
        child: const Icon(Icons.add_location_alt),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Provider.of<TravelController>(context).getTravels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Travellar yo'q"),
            );
          }

          var travels = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(15),
            child: GridView.builder(
              itemCount: travels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 3 / 4),
              itemBuilder: (context, index) {
                Travel travel = Travel.fromQuery(travels[index]);
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryFixedDim,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Container(color: Colors.blueGrey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(travel.title),
                            Text(
                                "lat: ${travel.latitude}, lon: ${travel.longitude}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[900],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
