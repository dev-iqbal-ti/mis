import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bd_visit_controller.dart';
import 'bd_visit_create_screen.dart';

class BDVisitListScreen extends StatelessWidget {
  final controller = Get.put(BDVisitController());

  BDVisitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BD Visits")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => BDVisitCreateScreen()),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.visits.isEmpty) {
          return const Center(child: Text("No Visits Found"));
        }

        return ListView.builder(
          itemCount: controller.visits.length,
          itemBuilder: (context, index) {
            final visit = controller.visits[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(visit.clientName),
                subtitle: Text(visit.purpose),
                trailing: Text(visit.departureDate.toString().split(' ')[0]),
              ),
            );
          },
        );
      }),
    );
  }
}
