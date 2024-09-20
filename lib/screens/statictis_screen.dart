import 'package:deliveryapplication_mobile_driver/screens/message_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/order_screen.dart';
import 'package:deliveryapplication_mobile_driver/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Here you can handle navigation logic based on the selected index
      print('Selected index: $_selectedIndex');
    });
  }

  bool isOnline = false;

  // Sample data
  final List<ChartData> dailyData = [
    ChartData('Mon', 30),
    ChartData('Tue', 40),
    ChartData('Wed', 25),
    ChartData('Thu', 45),
    ChartData('Fri', 50),
    ChartData('Sat', 35),
    ChartData('Sun', 60),
  ];

  final List<ChartData> monthlyData = [
    ChartData('Jan', 200),
    ChartData('Feb', 220),
    ChartData('Mar', 250),
    ChartData('Apr', 300),
    ChartData('May', 280),
    ChartData('Jun', 350),
    ChartData('Jul', 400),
    ChartData('Aug', 370),
    ChartData('Sep', 420),
    ChartData('Oct', 450),
    ChartData('Nov', 460),
    ChartData('Dec', 490),
  ];

  final List<ChartData> yearlyData = [
    ChartData('2022', 5000),
    ChartData('2023', 6000),
    ChartData('2024', 7000),
  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reorder),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF39c5c8),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(), // The home page content
          OrderPage(),
          MessagePage(),
          ProfilePage(),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar, name, and status toggle button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 30),
            decoration: BoxDecoration(
              color: const Color(0xFF39c5c8), // Màu xanh chủ đạo
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20.0), // Bo tròn góc dưới
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFQv4gzmNtZTnbl7lQMMmV5JWDO2_fIO2luA&s',
                  ),
                  radius: 30,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isOnline ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isOnline = !isOnline;
                    });
                  },
                  child: Text(isOnline ? 'Go Offline' : 'Go Online'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF39c5c8),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Revenue and Orders section
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s Revenue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '\$150',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today\'s Orders',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '20 Orders',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          // Revenue section with charts
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Daily Revenue Chart
                Card(
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(),
                            series: <CartesianSeries>[
                              ColumnSeries<ChartData, String>(
                                dataSource: dailyData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                color: Colors.blue,
                                dataLabelSettings: DataLabelSettings(isVisible: true),
                              ),
                            ],
                            title: ChartTitle(
                              text: 'Daily Revenue: \$400',
                              alignment: ChartAlignment.center,
                              textStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Monthly Revenue Chart
                Card(
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(),
                            series: <CartesianSeries>[
                              LineSeries<ChartData, String>(
                                dataSource: monthlyData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                color: Colors.green,
                                dataLabelSettings: DataLabelSettings(isVisible: true),
                              ),
                            ],
                            title: ChartTitle(
                              text: 'Monthly Revenue: \$2500',
                              alignment: ChartAlignment.center,
                              textStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Yearly Revenue Chart
                Card(
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(),
                            series: <CartesianSeries>[
                              ColumnSeries<ChartData, String>(
                                dataSource: yearlyData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                color: Colors.red,
                                dataLabelSettings: DataLabelSettings(isVisible: true),
                              ),
                            ],
                            title: ChartTitle(
                              text: 'Yearly Revenue: \$18000',
                              alignment: ChartAlignment.center,
                              textStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}



void main() {
  runApp(const MaterialApp(
    home: DriverHomePage(),
  ));
}
