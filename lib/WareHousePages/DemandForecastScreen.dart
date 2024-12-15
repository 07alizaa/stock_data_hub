import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DemandForecastScreen extends StatefulWidget {
  const DemandForecastScreen({super.key});

  @override
  _DemandForecastScreenState createState() => _DemandForecastScreenState();
}

class _DemandForecastScreenState extends State<DemandForecastScreen> {
  // Example demand data
  List<FlSpot> demandData = [
    FlSpot(1, 20),
    FlSpot(2, 50),
    FlSpot(3, 80),
    FlSpot(4, 70),
    FlSpot(5, 100),
    FlSpot(6, 60),
    FlSpot(7, 90),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demand Forecast'),
        backgroundColor: const Color(0xFF123D59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Demand Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey,
                          strokeWidth: 0.5,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey,
                          strokeWidth: 0.5,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 20,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              'Day ${value.toInt()}',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Colors.grey, width: 1),
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: demandData,
                        isCurved: true,
                        color: const Color(0xFF123D59),
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF123D59).withOpacity(0.2),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                radius: 3,
                                color: const Color(0xFF123D59),
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _simulateNewData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123D59),
                  ),
                  child: const Text('Simulate Data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('More Features Coming Soon!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123D59),
                  ),
                  child: const Text('More Features'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Simulate new demand data
  void _simulateNewData() {
    setState(() {
      demandData = List.generate(
        7,
            (index) => FlSpot(
          index + 1.0,
          (index * 10 + 20 + (index % 2 == 0 ? 15 : -10)).toDouble(),
        ),
      );
    });
  }
}
