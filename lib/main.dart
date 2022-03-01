import 'package:calcat/DatabaseHandler.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'model/Item.dart';

void main() {
  
  runApp(const MaterialApp(
    title: 'Katsu',
    home: DaApp()
  ));
}

class DaApp extends StatefulWidget {
  const DaApp({ Key? key }) : super(key: key);

  @override
  State<DaApp> createState() => _DaAppState();
}

var cattos = [];

class _DaAppState extends State<DaApp> {

  int totalCount = 0;
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();

    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      // await addItems();
      // setState(() {
      //   print('Done Load!');
      // });

      // totalCount = await handler.totalCount();
      // setState(() {
      //   print('Total count is $totalCount');
      // });

      // totalCount = await getTotalCount();
      getTotalCount();
    });
  }

  void getTotalCount() async {
    totalCount = await handler.totalCount(); 
    setState(() {
  
    });
  }

  // Future<int> addItems() async {
  //   Item firstItem = Item(content: "Content 1");
  //   Item secondItem = Item(content: "Content 2");
  //   List<Item> listOfItems = [firstItem, secondItem];
  //   return await handler.insertContents(listOfItems);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: const Text(
              'Flutter Test'
            )
          ),
          body: Column(
            children: [
              Text('Total is $totalCount'),
              Expanded(
                child: FutureBuilder(
                  future: handler.retrieveItems(),
                  builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: const Icon(Icons.delete_forever),
                            ),
                            key: ValueKey<int>(snapshot.data![index].id!),
                            onDismissed: (DismissDirection direction) async {
                              await handler.deleteItem(snapshot.data![index].id!);
                              setState(() {
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            child: Card(
                                child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              title: Text(snapshot.data![index].content)
                            )),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ) 
              )
          ]),
          floatingActionButton: InkWell(
            splashColor: Colors.red,
            onLongPress: () async {
              await handler.deleteAll();
              setState(() {
                getTotalCount();
              });
            },
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                totalCount++;
                Item item = Item(content: 'Content $totalCount', isCheck: 0);
                await handler.insertContent(item);
                setState(() {
                  getTotalCount();
                });
              },
            ),
          ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.indigo,
  //         title: const Text(
  //           'Flutter Test'
  //         )
  //       ),
  //       body: ListView.builder(
  //               padding: const EdgeInsets.all(8),
  //               itemCount: cattos.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return ListTile(
  //                   title: Text('Entry ${cattos.elementAt(index)}'),
  //                   onTap: () => {
  //                     print("Click on ${cattos.elementAt(index)}")
  //                   },
  //                 );
  //               }
  //             ),
  //       floatingActionButton: FloatingActionButton(
  //         child: const Icon(Icons.add),
  //         onPressed: () {
  //           setState(() {
  //             int count = cattos.length + 1;
  //             cattos.insert(0, 'Catto $count');
  //             print('list $cattos');
  //           });
  //         },
  //       ),
  //     );
  // }
  // https://docs.flutter.dev/cookbook/persistence/sqlite
}