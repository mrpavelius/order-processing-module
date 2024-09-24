import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          fontFamily: 'Manrope',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  final List<String> entries = <String>[
    'А564РП Щебень',
    'Б564РП Песок',
    'В564РП Гипс',
    'Г564РП Камень',
    'Д564РП Глина',
    'Е564РП Щебень',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'В очереди:',
              textScaler: TextScaler.linear(2),
            ),
            SizedBox(
                height: 180,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(2),
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        margin: const EdgeInsets.all(4),
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(entries[index].split(' ')[0])),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(entries[index].split(' ')[1]))
                          ],
                        ),
                      );
                    })),
            Text('В работе:', textScaler: TextScaler.linear(2)),
            Card(
                child: Center(
              child: Column(
                children: [
                  Text('Макарчук И.К.', textScaler: TextScaler.linear(1.5)),
                  Text('А564РП', textScaler: TextScaler.linear(1.5)),
                  Text('Щебень АТ-5455', textScaler: TextScaler.linear(1.5)),
                  Text('750 кг', textScaler: TextScaler.linear(1.5)),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 450.0,
                    height: 70.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.black,
                                )),
                            Text('Принял')
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow),
                                child: Icon(
                                  Icons.skip_next,
                                  color: Colors.black,
                                )),
                            Text('Пропустить')
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal),
                                child: Icon(
                                  Icons.archive_outlined,
                                  color: Colors.black,
                                )),
                            Text('Загрузил')
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.black,
                                )),
                            Text('Удалить')
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.edit_note),
        ),
        bottomNavigationBar: NavigationBar(destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Список задач',
          ),
        ]));
  }
}
