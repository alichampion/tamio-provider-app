import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/revenue_chart_data.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(enableDoubleTapZooming: true, enablePinching: true, enablePanning: true),
        enableAxisAnimation: true,
        legend: Legend(
          isVisible: true,
          isResponsive: true,
          position: LegendPosition.top,
          legendItemBuilder: (legendText, series, point, seriesIndex) {
            return Text('${languages.monthly} $legendText in ${appConfigurationStore.currencySymbol}', style: boldTextStyle()).paddingBottom(8);
          },
        ),
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        title: ChartTitle(
          textStyle: secondaryTextStyle(),
        ),
        backgroundColor: context.cardColor,
        primaryYAxis: NumericAxis(numberFormat: NumberFormat.compactCurrency(symbol: appConfigurationStore.currencySymbol, decimalDigits: 2), labelStyle: primaryTextStyle(size: 12)),
        primaryXAxis: CategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: primaryTextStyle(size: 12),
        ),
        crosshairBehavior: CrosshairBehavior(
          activationMode: ActivationMode.singleTap,
          lineType: CrosshairLineType.horizontal,
          enable: true,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
          hideDelay: 4000,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderWidth: 1.5,
          color: context.cardColor,
          textStyle: secondaryTextStyle(color: context.iconColor),
        ),
        series: <CartesianSeries>[
          SplineSeries<RevenueChartData, String>(
            name: languages.lblRevenue,
            dataSource: chartData,
            color: primaryColor,
            legendIconType: LegendIconType.diamond,
            splineType: SplineType.monotonic,
            yValueMapper: (RevenueChartData sales, _) => sales.revenue,
            xValueMapper: (RevenueChartData sales, _) => sales.month,
          ),
        ],
      ),
    );
  }
}