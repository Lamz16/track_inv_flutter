import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:track_inv_flutter/components/card_long_item_last_update.dart';
import 'package:track_inv_flutter/components/home_btn_io.dart';
import 'package:track_inv_flutter/components/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> transactionData = [];
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String? selectedSupplier;
  String? selectedCustomer;
  String? selectedBarang;
  String jumlahStok = '';

  @override
  void initState() {
    super.initState();
    _getLastUpdateTransactions();
  }

  Future<void> _getLastUpdateTransactions() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('data_transaksi');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      print('Data Firebase Transaksi ${snapshot.value}');
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        transactionData = data.entries.map((entry) {
          final value = Map<String, dynamic>.from(entry.value);
          return {
            'idTransaction': value['idTransaksi']?.toString() ?? '',
            'typeTransaction': value['jenisTran']?.toString() ?? '',
            'nominalOfTran': value['nominal']?.toString() ?? '',
            'item': value['namaBarang']?.toString() ?? '',
            'partnerName': value['namaPartner']?.toString() ?? '',
            'dateOfTrans': value['tglTran']?.toString() ?? '',
          };
        }).where((transaction) {
          return transaction['dateOfTrans'] == todayDate;
        }).toList();
      });
    } else {
      print('No data available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Track Inv",
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeCard(
                  countItem: '12',
                  icUrl: 'assets/images/ic_stok_tersedia.png',
                  typeOf: 'Stok tersedia',
                ),
                HomeCard(
                  countItem: '50',
                  icUrl: 'assets/images/ic_item_menipis.png',
                  typeOf: 'Stok menipis',
                ),
                HomeCard(
                  countItem: '5',
                  icUrl: 'assets/images/ic_item_habis.png',
                  typeOf: 'Stok habis',
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeBtnIo(
                  urlImg: 'assets/images/ic_stok_in.png',
                  text: 'Stok Masuk',
                  onTap: () => _showDropdownDialogTransMasuk(context),
                ),
                const SizedBox(width: 16.0),
                HomeBtnIo(
                  urlImg: 'assets/images/ic_stok_out.png',
                  text: 'Stok Keluar',
                  onTap: () => _showDropdownDialogTransKeluar(context),
                ),
              ],
            ),
            const SizedBox(height: 36.0),
            const Text(
              "Last Update",
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: transactionData.isEmpty
                  ? const Center(
                      child: Text('No transactions available'),
                    )
                  : ListView.builder(
                      itemCount: transactionData.length,
                      itemBuilder: (context, index) {
                        var transaction = transactionData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: CardLongItemLastUpdate(
                            typeTransaction: transaction['typeTransaction']!,
                            nominalOfTran: transaction['nominalOfTran']!,
                            item: transaction['item']!,
                            partnerName: transaction['partnerName']!,
                            dateOfTrans: transaction['dateOfTrans']!,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDropdownDialogTransMasuk(BuildContext context) async {
    DatabaseReference supplierRef =
        FirebaseDatabase.instance.ref('data_supplier');
    DataSnapshot supplierSnapshot = await supplierRef.get();

    List<String> supplierNames = [];
    if (supplierSnapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(supplierSnapshot.value as Map);
      supplierNames = data.values.map((value) {
        return value['namaSupp']?.toString() ?? '';
      }).toList();
    }

    DatabaseReference barangRef = FirebaseDatabase.instance.ref('data_barang');
    DataSnapshot barangSnapshot = await barangRef.get();

    Map<String, dynamic> barangData = {};
    List<String> barangNames = [];
    if (barangSnapshot.exists) {
      barangData = Map<String, dynamic>.from(barangSnapshot.value as Map);
      barangNames = barangData.values.map((value) {
        return value['namaBarang']?.toString() ?? '';
      }).toList();
    }

    String? tempSelectedSupplier = selectedSupplier;
    String? tempSelectedBarang = selectedBarang;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pilih Supplier dan Barang'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempSelectedSupplier,
                    hint: const Text('Pilih nama supplier'),
                    isExpanded: true,
                    items: supplierNames.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tempSelectedSupplier = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButton<String>(
                    value: tempSelectedBarang,
                    hint: const Text('Pilih nama barang'),
                    isExpanded: true,
                    items: barangNames.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tempSelectedBarang = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Stok',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        jumlahStok = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (tempSelectedSupplier != null &&
                        tempSelectedBarang != null &&
                        jumlahStok.isNotEmpty) {
                      int jumlah = int.parse(jumlahStok);
                      int nominal = jumlah *
                          int.parse(barangData.entries
                              .firstWhere(
                                (entry) =>
                                    entry.value['namaBarang'] ==
                                    tempSelectedBarang,
                                orElse: () => MapEntry('', {}),
                              )
                              .value['buy']);

                      // Panggil fungsi saveTransaction
                      await saveTransaction("Masuk", tempSelectedBarang!,
                          tempSelectedSupplier!, jumlah, nominal);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Transaksi berhasil disimpan")),
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> saveTransaction(String jenisTran, String namaBarang,
      String namaPartner, int jumlah, int nominal) async {
    DatabaseReference transRef =
        FirebaseDatabase.instance.ref('data_transaksi').push();
    String idTransaksi = transRef.key!;

    // Simpan transaksi
    await transRef.set({
      "idTransaksi": idTransaksi,
      "jenisTran": jenisTran,
      "jumlah": jumlah.toString(),
      "namaBarang": namaBarang,
      "namaPartner": namaPartner,
      "nominal": nominal.toString(),
      "tglTran": DateFormat('dd-MM-yyyy').format(DateTime.now()),
    });

    // Update stok barang di data_barang
    DatabaseReference barangRef = FirebaseDatabase.instance.ref('data_barang');
    DataSnapshot snapshot = await barangRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> barangData =
          Map<String, dynamic>.from(snapshot.value as Map);
      String? barangKey = barangData.entries
          .firstWhere(
            (entry) => entry.value['namaBarang'] == namaBarang,
            orElse: () => MapEntry('', {}),
          )
          .key;

      if (barangKey.isNotEmpty) {
        if (jenisTran == 'Masuk') {
          int currentStok =
              int.parse(barangData[barangKey]['stokBarang'].toString());
          await barangRef
              .child('$barangKey/stokBarang')
              .set(currentStok + jumlah);
        } else {
          int currentStok =
              int.parse(barangData[barangKey]['stokBarang'].toString());
          if (currentStok > jumlah) {
            await barangRef
                .child('$barangKey/stokBarang')
                .set(currentStok - jumlah);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Jumlah stok yang tersedia kurang')),
            );
          }
        }
      }
    }

    await _getLastUpdateTransactions();

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaksi berhasil disimpan")),
    );

  }

  Future<void> _showDropdownDialogTransKeluar(BuildContext context) async {
    DatabaseReference supplierRef =
        FirebaseDatabase.instance.ref('data_customer');
    DataSnapshot supplierSnapshot = await supplierRef.get();

    List<String> supplierNames = [];
    if (supplierSnapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(supplierSnapshot.value as Map);
      supplierNames = data.values.map((value) {
        return value['namaCs']?.toString() ?? '';
      }).toList();
    }

    DatabaseReference barangRef = FirebaseDatabase.instance.ref('data_barang');
    DataSnapshot barangSnapshot = await barangRef.get();

    Map<String, dynamic> barangData = {};
    List<String> barangNames = [];
    if (barangSnapshot.exists) {
      barangData = Map<String, dynamic>.from(barangSnapshot.value as Map);
      barangNames = barangData.values.map((value) {
        return value['namaBarang']?.toString() ?? '';
      }).toList();
    }

    String? tempSelectedCustomer = selectedCustomer;
    String? tempSelectedBarang = selectedBarang;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pilih Customer dan Barang'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: tempSelectedCustomer,
                    hint: const Text('Pilih nama customer'),
                    isExpanded: true,
                    items: supplierNames.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tempSelectedCustomer = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButton<String>(
                    value: tempSelectedBarang,
                    hint: const Text('Pilih nama barang'),
                    isExpanded: true,
                    items: barangNames.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tempSelectedBarang = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Stok',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        jumlahStok = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (tempSelectedCustomer != null &&
                        tempSelectedBarang != null &&
                        jumlahStok.isNotEmpty) {
                      int jumlah = int.parse(jumlahStok);
                      int nominal = jumlah *
                          int.parse(barangData.entries
                              .firstWhere(
                                (entry) =>
                            entry.value['namaBarang'] ==
                                tempSelectedBarang,
                            orElse: () => MapEntry('', {}),
                          )
                              .value['sell']);

                      // Panggil fungsi saveTransaction
                      await saveTransaction("Keluar", tempSelectedBarang!,
                          tempSelectedCustomer!, jumlah, nominal);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Transaksi berhasil disimpan")),
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
