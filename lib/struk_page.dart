import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Ganti barcode dengan QR

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = [
      {
        'name': 'Produk A',
        'price': 15000,
        'quantity': 2,
        'imageUrl': 'https://via.placeholder.com/40',
      },
      {
        'name': 'Produk B',
        'price': 30000,
        'quantity': 1,
        'imageUrl': 'https://via.placeholder.com/40',
      },
      {
        'name': 'Produk C',
        'price': 5000,
        'quantity': 5,
        'imageUrl': 'https://via.placeholder.com/40',
      },
    ];

    int total = 0;
    for (var item in cartItems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckoutPage(cartItems: cartItems, total: total),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final int total;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _showQrCode = false;
  late String transactionCode;

  @override
  void initState() {
    super.initState();
    transactionCode = DateTime.now().millisecondsSinceEpoch.toString();
  }

  String formatCurrency(int value) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Struk Pembayaran'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi toko
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'BarShop',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Text('Jl. abc Alamat No. 123', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text('Kota ABC, 12345', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 16),
                  Divider(thickness: 1, color: Colors.grey[300]),
                ],
              ),
            ),

            // Tabel produk
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(2.5),
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.green.shade100),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Nama Produk', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Harga', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Jumlah', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...widget.cartItems.map((item) {
                      final price = item['price'] as int;
                      final quantity = item['quantity'] as int;
                      final totalItem = price * quantity;

                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            child: Row(
                              children: [
                                if (item['imageUrl'] != null)
                                  Image.network(item['imageUrl'], width: 40, height: 40, fit: BoxFit.cover),
                                const SizedBox(width: 8),
                                Expanded(child: Text(item['name'])),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(formatCurrency(price), textAlign: TextAlign.right),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(quantity.toString(), textAlign: TextAlign.center),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(formatCurrency(totalItem), textAlign: TextAlign.right),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Divider(thickness: 1, color: Colors.grey[300]),

            // Total
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    formatCurrency(widget.total),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Tampilkan QRIS
            if (!_showQrCode)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showQrCode = true;
                    });
                  },
                  child: const Text('Tampilkan QRIS'),
                ),
              ),

            const SizedBox(height: 16),

            // QR Code hanya jika tombol diklik
            if (_showQrCode)
              Center(
                child: QrImageView(
                  data: '000201010212...081517031754...6304ABCD',
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),

            const SizedBox(height: 24),

            // Tombol selesai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Transaksi Berhasil'),
                      content: const Text('Pembelian Anda telah berhasil. Terima kasih!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Selesai', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
