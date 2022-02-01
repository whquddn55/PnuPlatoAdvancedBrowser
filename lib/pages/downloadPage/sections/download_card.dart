import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';

class DownloadCard extends StatelessWidget {
  final DownloadInformation downloadInformation;
  const DownloadCard({Key? key, required final this.downloadInformation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (downloadInformation.status == DownloadStatus.queueing) {
      return Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(downloadInformation.title),
          trailing: const Text('[대기 중]'),
        ),
      );
    } else {
      Widget indicator;
      Widget traiiling;
      if (downloadInformation.type == DownloadType.m3u8) {
        indicator = LinearProgressIndicator(value: (int.tryParse(downloadInformation.current) ?? 0) / (int.tryParse(downloadInformation.total) ?? 1));

        traiiling = Text('${downloadInformation.current} / ${downloadInformation.total}', textAlign: TextAlign.right);
      } else {
        indicator = ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
              stops: [
                0.1,
                0.3,
                0.4,
              ],
              begin: Alignment(-1.0, 0.0),
              end: Alignment(1.0, 0.0),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: const LinearProgressIndicator(),
        );

        traiiling = Text(downloadInformation.current, textAlign: TextAlign.right);
      }

      return Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 8,
                child: Column(
                  children: [
                    Text(downloadInformation.title),
                    const SizedBox(height: 20),
                    indicator,
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: traiiling,
              )
            ],
          ),
        ),
      );
    }
  }
}
