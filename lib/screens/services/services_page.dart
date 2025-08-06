import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        "title": "Hair Restoration & PRP",
        "desc": "Advanced platelet-rich plasma therapy for natural...",
        "price": "\$599",
        "duration": "90 minutes",
        "rating": "4.8",
        "reviews": "124",
        "popular": true,
        "image": "assets/images/hair.jpg"
      },
      {
        "title": "Hair Transplant (FUE)",
        "desc": "State-of-the-art follicular unit extraction for permanent h...",
        "price": "\$2,999",
        "duration": "4-6 hours",
        "rating": "4.9",
        "reviews": "89",
        "popular": false,
        "image": "assets/images/haircare.jpg"
      },
      {
        "title": "Microneedling with RF",
        "desc": "Radiofrequency microneedling for collagen...",
        "price": "\$299",
        "duration": "60 minutes",
        "rating": "4.8",
        "reviews": "112",
        "popular": false,
        "image": "assets/images/facial.jpg"
      },
      {
        "title": "Botox & Dysport",
        "desc": "Premium wrinkle relaxers for forehead, crow’s feet, and...",
        "price": "\$299",
        "duration": "30 minutes",
        "rating": "4.9",
        "reviews": "203",
        "popular": true,
        "image": "assets/images/laser.jpg"
      },
      {
        "title": "Dermal Fillers",
        "desc": "Hyaluronic acid fillers for lips, cheeks, and volume...",
        "price": "\$599",
        "duration": "45 minutes",
        "rating": "4.9",
        "reviews": "178",
        "popular": true,
        "image": "assets/images/skincare.jpg"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Services"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Premium medical aesthetics treatments",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Search treatments...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_list),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  CategoryChip(label: "All Services", selected: true),
                  SizedBox(width: 8),
                  CategoryChip(label: "Hair Treatments"),
                  SizedBox(width: 8),
                  CategoryChip(label: "Skin Care"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final s = services[index];
                  return ServiceCard(
                    title: s['title'] as String,
                    desc: s['desc'] as String,
                    price: s['price'] as String,
                    duration: s['duration'] as String,
                    rating: s['rating'] as String,
                    reviews: s['reviews'] as String,
                    isPopular: s['popular'] as bool,
                    imageAsset: s['image'] as String,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Records"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const CategoryChip({super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: selected ? Colors.blue : Colors.grey[200],
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title, desc, price, duration, rating, reviews, imageAsset;
  final bool isPopular;

  const ServiceCard({
    super.key,
    required this.title,
    required this.desc,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviews,
    required this.imageAsset,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.asset(
                  imageAsset,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              if (isPopular)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Popular",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("Starting from $price", style: const TextStyle(color: Colors.blue)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text("$rating  "),
                      Text("($reviews reviews)"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16),
                      const SizedBox(width: 4),
                      Text(duration),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
