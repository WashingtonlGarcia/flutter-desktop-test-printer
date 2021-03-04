import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> handlePrinter() async {
    try {
      final String host = "192.168.15.105";
      final CapabilityProfile profile = await CapabilityProfile.load();
      final NetworkPrinter printerManager =
          NetworkPrinter(PaperSize.mm80, profile);
      final PosPrintResult res = await printerManager.connect(host, port: 9100);
      if (res == PosPrintResult.success) {
        await testReceipt(printerManager: printerManager);
        printerManager.disconnect(delayMs: 3600);
      } else {
        throw 'Não foi possivel conectar a impressora!!';
      }
    } catch (err) {
      handleShowSnackBar(err: err);
    }
  }

  void handleShowSnackBar({String err}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
      content: Text(err.toString()),
    ));
  }

  Future<void> testReceipt({@required NetworkPrinter printerManager}) async {
    try {
      printerManager.text(
          'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
      printerManager.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
          styles: PosStyles(codeTable: 'CP1252'));
      printerManager.text('Special 2: blåbærgrød',
          styles: PosStyles(codeTable: 'CP1252'));
      printerManager.text('Bold text', styles: PosStyles(bold: true));
      printerManager.text('Reverse text', styles: PosStyles(reverse: true));
      printerManager.text('Underlined text',
          styles: PosStyles(underline: true), linesAfter: 1);
      printerManager.text('Align left',
          styles: PosStyles(align: PosAlign.left));
      printerManager.text('Align center',
          styles: PosStyles(align: PosAlign.center));
      printerManager.text('Align right',
          styles: PosStyles(align: PosAlign.right), linesAfter: 1);
      printerManager.text('Text size 200%',
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      printerManager.feed(2);
      printerManager.cut();
    } catch (err) {
      handleShowSnackBar(err: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestor'),
      ),
      body: Center(
        child: TextButton(
          child: Text('TESTAR'),
          onPressed: () async => handlePrinter(),
        ),
      ),
    );
  }
}
