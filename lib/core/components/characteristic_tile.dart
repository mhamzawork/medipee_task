import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:medipee_task/core/components/description_tile.dart';

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;
  final VoidCallback? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
        required this.characteristic,
        required this.descriptorTiles,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: widget.characteristic.onValueReceived,
      initialData: widget.characteristic.lastValue,
      builder: (context, snapshot) {
        final List<int>? value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Characteristic'),
                Text('0x${widget.characteristic.characteristicUuid.toString().toUpperCase()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                Row(
                  children: [
                    if (widget.characteristic.properties.read)
                      TextButton(
                          child: Text("Read"),
                          onPressed: () {
                            widget.onReadPressed!();
                            setState(() {});
                          }),
                    if (widget.characteristic.properties.write)
                      TextButton(
                          child: Text(widget.characteristic.properties.writeWithoutResponse ? "WriteNoResp" : "Write"),
                          onPressed: () {
                            widget.onWritePressed!();
                            setState(() {});
                          }),
                    if (widget.characteristic.properties.notify || widget.characteristic.properties.indicate)
                      TextButton(
                          child: Text(widget.characteristic.isNotifying ? "Unsubscribe" : "Subscribe"),
                          onPressed: () {
                            widget.onNotificationPressed!();
                            setState(() {});
                          })
                  ],
                )
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          children: widget.descriptorTiles,
        );
      },
    );
  }
}