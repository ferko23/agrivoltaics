import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:influxdb_client/api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dashboard_drawer.dart';
import 'dashboard_state.dart';
import 'dashboard_appbar.dart';

/*

Dashboard Page

*/
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardState(),
      child: const SafeArea(
        child: Scaffold(
          endDrawer: DashboardDrawer(),
          appBar: DashboardAppBar(),
          body: Dashboard()
        ),
      ),
    );
  }
}

/*

Dashboard

*/
class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Consumer<DashboardState>(
              builder: (context, dashboardState, child) {
                return FutureBuilder<Map<String, List<FluxRecord>>>(
                  // Async method called by FutureBuilder widget, whose results will eventually populate widget
                  future: dashboardState.getData(dashboardState.dateRangeSelection),

                  builder: (BuildContext context, AsyncSnapshot<Map<String, List<FluxRecord>>> snapshot) {
                    // Once the data snapshot is populated with above method results, render chart
                    if (snapshot.hasData) {
                      return SfCartesianChart(
                        // TODO: title chart
                        // title: ChartTitle(text: 'TODO: change me'),
                        legend: Legend(isVisible: true),
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.singleTap,
                          tooltipSettings: const InteractiveTooltip(
                            enable: true,
                            format: 'series.name\npoint.y | point.x',
                            borderWidth: 20
                          )
                        ),
                        primaryXAxis: CategoryAxis(),
                        series: <LineSeries<InfluxDatapoint, DateTime>>[
                          for (var data in snapshot.data!.entries)...[
                            LineSeries<InfluxDatapoint, DateTime>(
                              dataSource: InfluxData(data.value).data,
                              xValueMapper: (InfluxDatapoint d, _) => d.timeStamp,
                              yValueMapper: (InfluxDatapoint d, _) => d.value,
                              legendItemText: data.key,
                              name: data.key
                            )
                          ]
                        ],
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePinching: true
                        ),
                      );

                    // The results have not yet been returned. Indicate loading
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                );
              }
            )
          ),
        ),
      ],
    );
  }
}

class InfluxDatapoint {
  InfluxDatapoint(this.timeStamp, this.value);
  final DateTime timeStamp;
  final double value;
}

class InfluxData {
  InfluxData(this.records) {
    this.data = <InfluxDatapoint>[];
    for (var record in this.records) {
      this.data.add(InfluxDatapoint(DateTime.parse(record['_time']), record['_value']));
    }
  }
  final List<FluxRecord> records;
  late List<InfluxDatapoint> data;
}

class BarIndicator extends StatelessWidget {
  const BarIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: 40, height: 3,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}