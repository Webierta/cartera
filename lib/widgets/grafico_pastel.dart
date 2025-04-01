import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/number_util.dart';

class GraficoPastel extends StatefulWidget {
  final double porcentajeCuentas;
  final double porcentajeDepositos;
  final double porcentajeFondos;
  final int? touchedIndex;
  const GraficoPastel({
    super.key,
    required this.porcentajeCuentas,
    required this.porcentajeDepositos,
    required this.porcentajeFondos,
    this.touchedIndex,
  });

  @override
  State<GraficoPastel> createState() => _GraficoPastelState();
}

class _GraficoPastelState extends State<GraficoPastel> {
  int touchedIndex = -1;

  @override
  void initState() {
    touchedIndex = widget.touchedIndex ?? -1;
    super.initState();
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: widget.porcentajeCuentas,
            title: NumberUtil.porcentage((widget.porcentajeCuentas)),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icons.account_balance_wallet,
              size: widgetSize,
              borderColor: Colors.blue,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: widget.porcentajeDepositos,
            title: NumberUtil.porcentage((widget.porcentajeDepositos)),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icons.savings,
              size: widgetSize,
              borderColor: Colors.green,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red,
            value: widget.porcentajeFondos,
            title: NumberUtil.porcentage((widget.porcentajeFondos)),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icons.assessment,
              size: widgetSize,
              borderColor: Colors.red,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Error();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections(),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.icon, {
    required this.size,
    required this.borderColor,
  });
  final IconData icon;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(icon),
      ),
    );
  }
}
