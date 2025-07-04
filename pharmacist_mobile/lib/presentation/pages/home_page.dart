import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/presentation/widgets/medicine_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Love Care Pharmacy'),
        actions: [IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})],
      ),
      body: BlocProvider(
        create: (context) => MedicineBloc(context.read())..add(SearchMedicines('')),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage('https://via.placeholder.com/150')),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi, Welcome Back', style: TextStyle(color: Colors.green)),
                          Text('John Doe'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(hintText: 'Search...', prefixIcon: Icon(Icons.search)),
                    onChanged: (query) => context.read<MedicineBloc>().add(SearchMedicines(query)),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.teal,
              padding: EdgeInsets.all(10),
              child: Text('Love Care Pharmacy', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Antibiotics', 'Vitamins', 'Pain Relief', 'Cold & Flu']
                    .map((cat) => ElevatedButton(onPressed: () {}, child: Text(cat)))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Recent Purchases', style: TextStyle(fontSize: 18)),
            ),
            Expanded(
              child: BlocBuilder<MedicineBloc, MedicineState>(
                builder: (context, state) {
                  if (state is MedicineLoading) return CircularProgressIndicator();
                  if (state is MedicineError) return Text('Error: ${state.message}');
                  if (state is MedicineLoaded) {
                    return ListView.builder(
                      itemCount: state.medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = state.medicines[index];
                        return MedicineWidget(medicine: medicine);
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}