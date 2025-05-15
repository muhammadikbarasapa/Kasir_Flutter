import 'package:flutter/material.dart';
import 'struk_page.dart';


class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final TextEditingController _searchController = TextEditingController();
  int _cartItemCount = 0;
  String _selectedCategory = 'Semua';
  final List<Map<String, dynamic>> _cartItems = [];

  // Sample product data
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Susu Cokelat',
      'category': 'Minuman',
      'price': 10000,
      'stock': 50,
      'image': 'assets/images/susu_Coklat.jpeg',
      'color': const Color(0xFF6D4C41),
    },
    {
      'name': 'Kopi Hitam',
      'category': 'Minuman',
      'price': 8000,
      'stock': 30,
      'image': 'assets/images/kopihitam.jpg',
      'color': const Color(0xFF3E2723),
    },
    {
      'name': 'Teh Manis',
      'category': 'Minuman',
      'price': 5000,
      'stock': 40,
      'image': 'assets/images/tehmanis.jpg',
      'color': const Color(0xFF795548),
    },
    {
      'name': 'Roti Bakar',
      'category': 'Makanan',
      'price': 12000,
      'stock': 25,
      'image': 'assets/images/rotibakar.jpg',
      'color': const Color(0xFFE65100),
    },
    {
      'name': 'Nasi Goreng',
      'category': 'Makanan',
      'price': 15000,
      'stock': 20,
      'image': 'assets/images/nasigoreng.jpg',
      'color': const Color(0xFFF57C00),
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'Semua') {
      return _products;
    }
    return _products.where((product) => product['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(),
            
            // Search and Categories
            _buildSearchAndFilterSection(),
            
            // Product List
            Expanded(
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : _buildProductGrid(),
            ),
          ],
        ),
      ),
      
      // Floating Cart Button
      floatingActionButton: _buildFloatingCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cashier App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[200],
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Icon(
              Icons.person,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari produk...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Categories
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 8),
                _buildCategoryChip('Semua', Icons.all_inclusive),
                _buildCategoryChip('Minuman', Icons.local_drink),
                _buildCategoryChip('Makanan', Icons.fastfood),
                _buildCategoryChip('Snack', Icons.cookie),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.blue),
            const SizedBox(width: 6),
            Text(category),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: Colors.blue[600],
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.blue[600],
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _addToCart(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: product['color'].withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: AssetImage(product['image']),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product['category'],
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Stok: ${product['stock']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Text(
                        'Rp ${product['price'].toString().replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (match) => '${match[1]}.',
                            )}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue[800],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _addToCart(product),
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: FloatingActionButton.extended(
          onPressed: _cartItemCount > 0 ? showCartDialog : null,
          backgroundColor: _cartItemCount > 0 ? Colors.blue[800] : Colors.grey[400],
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          icon: Badge(
            isLabelVisible: _cartItemCount > 0,
            label: Text(_cartItemCount.toString()),
            child: const Icon(Icons.shopping_cart),
          ),
          label: const Text(
            'Lihat Keranjang',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
  setState(() {
    // Cari index produk di list _products berdasarkan nama
    final productIndex = _products.indexWhere((p) => p['name'] == product['name']);
    if (productIndex == -1) return; // safety check jika produk tidak ditemukan

    // Cek stok produk
    if (_products[productIndex]['stock'] > 0) {
      // Kurangi stok di produk
      _products[productIndex]['stock']--;

      // Tambah total item di keranjang
      _cartItemCount++;

      // Cek apakah produk sudah ada di keranjang
      final existingIndex = _cartItems.indexWhere((item) => item['name'] == product['name']);
      if (existingIndex >= 0) {
        // Jika ada, tambah quantity
        _cartItems[existingIndex]['quantity']++;
      } else {
        // Jika belum ada, tambah produk baru dengan quantity 1
        _cartItems.add({
          ...product,
          'quantity': 1,
        });
      }
    } else {
      // Jika stok habis, tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok ${product['name']} habis!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return; // jangan lanjutkan ke snackbar bawah
    }
  });

  // Tampilkan snackbar kalau berhasil tambah
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${product['name']} ditambahkan ke keranjang'),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 1),
    ),
  );
}


  void showCartDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Title
              const Text(
                'Keranjang Belanja',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Cart Items
              if (_cartItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Keranjang belanja kosong',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _cartItems.length,
                    separatorBuilder: (context, index) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Row(
                        children: [
                          // Product Image
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: item['color'].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(item['image']),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${item['price'].toString().replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (match) => '${match[1]}.',
                                      )}',
                                  style: TextStyle(color: Colors.grey[100]),
                                ),
                              ],
                            ),
                          ),
                          
                          // Quantity Controls
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (item['quantity'] > 1) {
                                      item['quantity']--;
                                      _cartItemCount--;
                                    } else {
                                      _cartItems.removeAt(index);
                                      _cartItemCount--;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove),
                                padding: EdgeInsets.zero,
                              ),
                              Text(item['quantity'].toString()),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    item['quantity']++;
                                    _cartItemCount++;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              
              // Total and Checkout
              if (_cartItems.isNotEmpty) ...[
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Rp ${_calculateTotal().toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (match) => '${match[1]}.',
                          )}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup modal

                      final receiptItems = List<Map<String, dynamic>>.from(_cartItems);
                      final total = _calculateTotal();

                      // Navigasi ke halaman CheckoutPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            cartItems: receiptItems,
                            total: total,
                          ),
                        ),
                      );

                      // Kosongkan keranjang setelah checkout
                      setState(() {
                        _cartItems.clear();
                        _cartItemCount = 0;
                      });
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  int _calculateTotal() {
    return _cartItems.fold<int>(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );
  }
}