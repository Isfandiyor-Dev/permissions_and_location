import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesson_72_permissions/controllers/travel_controller.dart';
import 'package:lesson_72_permissions/models/travel.dart';
import 'package:lesson_72_permissions/services/location_service.dart';
import 'package:lesson_72_permissions/views/widgets/add_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

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
            builder: (context) => AddDialog(
              isAddDialog: true,
            ),
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
                  childAspectRatio: 3 / 4.5),
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
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: Image.network(
                          travel.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              travel.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Link(
                              uri: Uri.parse(
                                  "https://www.google.com/maps/@${travel.latitude},${travel.longitude},10z?entry=ttu"),
                              builder: (BuildContext context,
                                  FollowLink? followLink) {
                                return GestureDetector(
                                  onTap: followLink,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.location_on_rounded),
                                      SizedBox(width: 5),
                                      Text("Location"),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // Text("lat: ${travel.latitude}"),
                            // Text("lon: ${travel.longitude}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AddDialog(
                                        isAddDialog: false,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<TravelController>(context,
                                            listen: false)
                                        .deleteTravel(travel.id);
                                  },
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
