import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Модуль обработки заказов',
      theme: ThemeData(
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
      case 1:
        page = OrdersPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: page,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createNewOrder();
          },
          child: Icon(Icons.edit_note),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Главная',
            ),
            NavigationDestination(
              icon: Icon(Icons.checklist),
              label: 'Список задач',
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ));
  }

  void _createNewOrder() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewOrderPage(),
        ));
  }
}

class HomePage extends StatelessWidget {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Text(
            'В очереди: ${entries.length}',
            textScaler: TextScaler.linear(2),
          ),
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
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
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
        )))
      ],
    );
  }
}

class OrdersPage extends StatelessWidget {
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
    return SafeArea(
        child: ListView.builder(
            padding: const EdgeInsets.all(2),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
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
            }));
  }
}

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              Text('Введите данные новой заявки:',
                  textScaler: TextScaler.linear(1.5)),
              TextFormField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'ФИО',
              )),
              TextFormField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Номер автомобиля',
              )),
              TextFormField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Название груза',
              )),
              TextFormField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Вес',
              )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: ElevatedButton(
                      onPressed: () {}, child: Text('Сохранить')))
            ],
          )),
    );
  }
}
