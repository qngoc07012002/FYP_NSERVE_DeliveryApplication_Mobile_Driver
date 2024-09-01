import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar, name, and status toggle button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
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
            const SizedBox(height: 24.0),

            // Revenue section with charts
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenue Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Daily Revenue Chart
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Daily Revenue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16.0),
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
                                text: 'Total Revenue: \$400',
                                alignment: ChartAlignment.center,
                                textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Monthly Revenue Chart
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Monthly Revenue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16.0),
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
                                text: 'Total Revenue: \$2500',
                                alignment: ChartAlignment.center,
                                textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Yearly Revenue Chart
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Yearly Revenue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height: 200,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(),
                              series: <CartesianSeries>[
                                ColumnSeries<ChartData, String>(
                                  dataSource: yearlyData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  color: Colors.orange,
                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                ),
                              ],
                              title: ChartTitle(
                                text: 'Total Revenue: \$12000',
                                alignment: ChartAlignment.center,
                                textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
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
