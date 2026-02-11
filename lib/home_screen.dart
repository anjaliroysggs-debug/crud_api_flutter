import 'package:flutter/material.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ApiService apiService = ApiService();
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await apiService.getProducts();
    setState(() {
      products = data;
      isLoading = false;
    });
  }

   // ================= DIALOG =================
  void showProductDialog({dynamic product}) {

    TextEditingController titleController =
    TextEditingController(text: product?['title'] ?? "");

    TextEditingController descController =
    TextEditingController(text: product?['description'] ?? "");

    TextEditingController imageController =
    TextEditingController(text: product?['thumbnail'] ?? "");

    showDialog(

      context: context,
      builder: (_) => AlertDialog(
          backgroundColor: const Color(0xffF5F6FA),
        title: Text(product == null ? "Add Product" : "Edit Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ✅ Image Preview
              if (imageController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.network(
                    imageController.text,
                    height: 100,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, size: 80),
                  ),
                ),

              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {

              if (product == null) {
                final newProduct = await apiService.addProduct(
                    titleController.text,
                    descController.text,
                    imageController.text);

                setState(() {
                  products.insert(0, newProduct);
                });

              } else {
                final updatedProduct = await apiService.updateProduct(
                    product['id'],
                    titleController.text,
                    descController.text,
                    imageController.text);

                int index = products.indexWhere(
                        (element) => element['id'] == product['id']);

                if (index != -1) {
                  setState(() {
                    products[index] = updatedProduct;
                  });
                }
              }

              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void deleteProduct(int id) async {
    await apiService.deleteProduct(id);

    setState(() {
      products.removeWhere((element) => element['id'] == id);
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "🛍 Product Manager",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff6A11CB),
                Color(0xff2575FC),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductDialog(),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: products.length,
        itemBuilder: (context, index) {

          final product = products[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product['thumbnail'] ?? "",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['title'] ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product['description'] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          showProductDialog(product: product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          deleteProduct(product['id']),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
