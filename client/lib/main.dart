import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

void main() {
  runApp(MyApp());
}

Future<List<Order>> getOrders() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8080'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<Order> orders =
          jsonList.map((json) => Order.fromJson(json)).toList();
      return orders;
    } else {
      throw Exception(
          'Failed to load orders. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
    return [];
  }
}

void deleteOrder(int id) async {
  try {
    final response = await http
        .post(Uri.parse('http://localhost:8080/orders/delete_order?id=$id'));

    if (response.statusCode == 200) {
      print("Success!");
    } else {
      throw Exception(
          'Failed to delete order. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

void createNewOrder(Map<String, Object> body) async {
  try {
    final response = await http.post(
        Uri.parse('http://localhost:8080/orders/create_new_order'),
        body: json.encode(body));

    if (response.statusCode == 200) {
      print("Success!");
    } else {
      throw Exception(
          'Failed to save order. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
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
  final Future<List<Order>> entries = getOrders();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: FutureBuilder<List<Order>>(
                future: entries,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Ошибка: ${snapshot.error}',
                        textScaler: TextScaler.linear(1.5));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Нет заказов',
                        textScaler: TextScaler.linear(1.5));
                  } else {
                    final orders = snapshot.data!;
                    return Text('В очереди: ${orders.length}',
                        textScaler: TextScaler.linear(1.5));
                  }
                },
              ),
            ),
            SizedBox(
              height: 180,
              child: FutureBuilder<List<Order>>(
                future: entries,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Ошибка: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Нет данных');
                  } else {
                    final orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = orders[index];
                        return SizedBox(
                            height: 65,
                            child: Card(
                              margin: const EdgeInsets.all(4),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(order.car_number),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(order.cargo_name),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  }
                },
              ),
            ),
            Text('В работе:', textScaler: TextScaler.linear(1.5)),
            FutureBuilder<List<Order>>(
              future: entries,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Ошибка: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Нет текущего заказа');
                } else {
                  final orders = snapshot.data!;
                  // Ищем заказ со статусом "Текущий"
                  final currentOrder = orders.firstWhere(
                    (order) =>
                        order.status == "Принят" || order.status == "Текущий",
                  );

                  return Card(
                    child: Center(
                      child: Column(
                        children: [
                          Text(currentOrder.fio,
                              textScaler: TextScaler.linear(1.5)),
                          Text(currentOrder.car_number,
                              textScaler: TextScaler.linear(1.5)),
                          Text(currentOrder.cargo_name,
                              textScaler: TextScaler.linear(1.5)),
                          Text('${currentOrder.volume} кг',
                              textScaler: TextScaler.linear(1.5)),
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
                                      onPressed: () {
                                        getOrders();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text('Принял')
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: currentOrder.status == 'Принят'
                                          ? null
                                          : () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow),
                                      child: Icon(
                                        Icons.skip_next,
                                        color: Colors.black,
                                      ),
                                    ),
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
                                      ),
                                    ),
                                    Text('Загрузил')
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: currentOrder.status == 'Принят'
                                          ? null
                                          : () {
                                              deleteOrder(currentOrder.id);
                                            },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text('Удалить')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
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
              return SizedBox(
                  height: 65,
                  child: Card(
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
                  ));
            }));
  }
}

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fio = TextEditingController();
    final carNumber = TextEditingController();
    final cargoName = TextEditingController();
    final volume = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              Text('Введите данные новой заявки:',
                  textScaler: TextScaler.linear(1.5)),
              TextFormField(
                  controller: fio,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'ФИО',
                  )),
              TextFormField(
                  controller: carNumber,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Номер автомобиля',
                  )),
              TextFormField(
                  controller: cargoName,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Название груза',
                  )),
              TextFormField(
                  controller: volume,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Вес',
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: ElevatedButton(
                      onPressed: () {
                        createNewOrder({
                          "fio": fio.text,
                          "car_number": carNumber.text,
                          "cargo_name": cargoName.text,
                          "volume": volume.text,
                          "status": "В ожидании"
                        });
                      },
                      child: Text('Сохранить')))
            ],
          )),
    );
  }
}
