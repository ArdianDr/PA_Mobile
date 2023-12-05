import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/provider/detail_page_prod.dart';


class BookingTripPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> trailDataList = context.read<DetailPageProvider>().trailDataList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Trip"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Destination: ${trailDataList.isNotEmpty ? trailDataList[0]['name'] : ''}"),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(labelText: 'Nama Pemesan'),
            ),
            const SizedBox(height: 10),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah Orang (Max 5)'),
            ),
            const SizedBox(height: 10),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Nomor HP'),
            ),
            const SizedBox(height: 10),
            Text("Total Harga: \$${trailDataList.isNotEmpty ? trailDataList[0]['price'] * 5 : 0}"), // Harga * Jumlah Orang
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika untuk melakukan booking trip
              },
              child: const Text("Book Trip"),
            ),
          ],
        ),
      ),
    );
  }
}
