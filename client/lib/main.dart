import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'api_service.dart';
import 'package:collection/collection.dart';

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
  Future<List<Order>>? _orders;
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _orders = ApiService.getOrders();
    });
  }

  void _updateOrderStatus(int orderId, String status) async {
    await ApiService.updateOrderStatus(orderId, status);
    await ApiService.skipOrder();
    _loadOrders(); // Обновляем заказы после изменения статуса
  }

  void _deleteOrder(int orderId) async {
    await ApiService.deleteOrder(orderId);
    await ApiService.skipOrder();
    _loadOrders(); // Обновляем заказы после удаления
  }

  void _skipOrder() async {
    await ApiService.skipOrder();
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: IndexedStack(
          index: selectedIndex,
          children: [
            HomePage(
              orders: _orders,
              onOrderStatusChange: _updateOrderStatus,
              onDeleteOrder: _deleteOrder,
              onSkipOrder: _skipOrder,
              onRefresh: _loadOrders,
            ),
            OrdersPage(),
          ],
        ),
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
              label: 'Выполненные заказы',
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
              if (selectedIndex == 0) {
                _loadOrders(); // Обновляем заказы при возврате на главную страницу
              }
            });
          }),
    );
  }

  void _createNewOrder() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => NewOrderPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );

    if (result == true) {
      _loadOrders(); // Обновляем заказы при возврате
    }
  }
}

class HomePage extends StatelessWidget {
  final Future<List<Order>>? orders;
  final Function(int, String) onOrderStatusChange;
  final Function(int) onDeleteOrder;
  final Function() onSkipOrder;
  final Function() onRefresh;

  HomePage({
    required this.orders,
    required this.onOrderStatusChange,
    required this.onDeleteOrder,
    required this.onSkipOrder,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: orders == null
                  ? CircularProgressIndicator()
                  : FutureBuilder<List<Order>>(
                      future: orders,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Ошибка: ${snapshot.error}',
                              textScaler: TextScaler.linear(1.5));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('Нет заказов',
                              textScaler: TextScaler.linear(1.5));
                        } else {
                          final orders = snapshot.data!
                              .where((order) => order.status != 'Загружен')
                              .toList();
                          return Text('В очереди: ${orders.length}',
                              textScaler: TextScaler.linear(1.5));
                        }
                      },
                    ),
            ),
            SizedBox(
              height: 180,
              child: orders == null
                  ? CircularProgressIndicator()
                  : FutureBuilder<List<Order>>(
                      future: orders,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Ошибка: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('Нет данных');
                        } else {
                          final orders = snapshot.data!
                              .where((order) => order.status != 'Загружен')
                              .toList();
                          orders.sort((a, b) => a.id.compareTo(b.id));
                          orders.sort((a, b) => a.status.length.compareTo(b.status.length));
                          return MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                shrinkWrap:
                                    true, // Позволяет корректно работать внутри ScrollView
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
                              ));
                        }
                      },
                    ),
            ),
            Text('В работе:', textScaler: TextScaler.linear(1.5)),
            orders == null
                ? CircularProgressIndicator()
                : FutureBuilder<List<Order>>(
                    future: orders,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Ошибка: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('Нет текущего заказа');
                      } else {
                        final orders = snapshot.data!;
                        final currentOrder = orders.firstWhereOrNull(
                          (order) =>
                              order.status == "Принят" ||
                              order.status == "Текущий",
                        );

                        if (currentOrder != null) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: currentOrder.status ==
                                                      'Принят'
                                                  ? null
                                                  : () {
                                                      onOrderStatusChange(
                                                          currentOrder.id,
                                                          'Принят');
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green),
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
                                              onPressed: currentOrder.status ==
                                                      'Принят'
                                                  ? null
                                                  : () {
                                                      onSkipOrder();
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.yellow),
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
                                              onPressed: () {
                                                onOrderStatusChange(
                                                    currentOrder.id,
                                                    'Загружен');
                                              },
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
                                              onPressed: currentOrder.status ==
                                                      'Принят'
                                                  ? null
                                                  : () {
                                                      onDeleteOrder(
                                                          currentOrder.id);
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
                        } else {
                          return Container();
                        }
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  final Future<List<Order>> entries = ApiService.getOrders();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: entries,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Ошибка: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Нет данных');
              } else {
                final orders = snapshot.data!
                    .where((order) => order.status == 'Загружен')
                    .toList();
                orders.sort((a, b) => a.id.compareTo(b.id));
                return ListView.builder(
                    padding: const EdgeInsets.all(2),
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
                                    child: Text(order.car_number)),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(order.cargo_name))
                              ],
                            ),
                          ));
                    });
              }
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
                        ApiService.createNewOrder({
                          "fio": fio.text,
                          "car_number": carNumber.text,
                          "cargo_name": cargoName.text,
                          "volume": volume.text,
                        });
                        Navigator.pop(context, true);
                      },
                      child: Text('Сохранить')))
            ],
          )),
    );
  }
}
