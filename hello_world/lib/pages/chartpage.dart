import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hello_world/components/applicationbars.dart';

class MyChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: MyChart(),
    );
  }
}

class MyChart extends StatefulWidget {
  @override
  _MyChartState createState() => _MyChartState(_createSampleData(100), true);
}

class _MyChartState extends State<MyChart> {
  List<charts.Series> seriesList;
  final bool animate;
  double _sliderValue = 10.0;

  _MyChartState(this.seriesList, this.animate);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height/5*3,
          width: MediaQuery.of(context).size.width,
          child: charts.PieChart(
            seriesList,
            animate: animate,
          ),
        ),
          Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged: (newRating) {
                    setState(() {
                    _sliderValue = newRating;
                    seriesList = _createSampleData(_sliderValue.toInt());
                    } );
                  },
                  value: _sliderValue,
                ),
      ],
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}


 /// Create one series with sample hard coded data.
 List<charts.Series<LinearSales, int>> _createSampleData(int value) {
    final data = [
      new LinearSales(0, value),
      new LinearSales(1, 15),
      new LinearSales(2, 8),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }