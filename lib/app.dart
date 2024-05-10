import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final String flavor;

  const App({
    required this.flavor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusNest',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(flavor),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => FirebaseFirestore.instance
              .collection('testing')
              .add({'timestamp': Timestamp.fromDate(DateTime.now())}),
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('testing').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final docData = snapshot.data.docs[index].data();
                    final dateTime =
                        (docData['timestamp'] as Timestamp).toDate();
                    return ListTile(
                      title: Text(dateTime.toString()),
                    );
                  });
            }),
      ),
    );
  }
}
