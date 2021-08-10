import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

const HONG_BAO = "appusm@icici";

class DonationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding:
          const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
      children: <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width),
        Container(
            padding: const EdgeInsets.all(16),
            child: Text("Development is not easy, sponsor the developer.")),
        _ActionTile(
          text: "Show QR code to make UPI donation",
          onTap: () async {
            await showDialog(
                context: context, builder: (context) => _ReceiptDialog.upi());
            Navigator.pop(context);
          },
        ),
        _ActionTile(
          text: "Copy UPI id to make donation !",
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: HONG_BAO));
            final data = await Clipboard.getData(Clipboard.kTextPlain);
            if (data.text == HONG_BAO) {
              showSimpleNotification(
                  context,
                  Text(
                      "Virtual Payment address has been copied to the clipboard"));
            } else {
              await showDialog(
                  context: context,
                  builder: (context) => _SingleFieldDialog(text: HONG_BAO));
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _SingleFieldDialog extends StatelessWidget {
  final String text;

  const _SingleFieldDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: TextField(
          maxLines: 5,
          autofocus: true,
          controller: TextEditingController(text: text),
        ),
      ),
    );
  }
}

class _ReceiptDialog extends StatelessWidget {
  final String image;

  const _ReceiptDialog({Key key, this.image}) : super(key: key);

  const _ReceiptDialog.upi() : this(image: "assets/upi.png");

  static final borderRadius = BorderRadius.circular(5);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: ClipRRect(borderRadius: borderRadius, child: Image.asset(image)),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final VoidCallback onTap;

  final String text;

  const _ActionTile({Key key, @required this.onTap, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            SizedBox(width: 16),
            Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
