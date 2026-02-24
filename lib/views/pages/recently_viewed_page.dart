import 'package:flutter/material.dart';

class RecentlyViewedPage extends StatelessWidget {
  const RecentlyViewedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, this would pull from a database/cache
    final recentlyViewed = <Map<String, String>>[
      {
        'name': 'Wireless Headphones',
        'price': '299 EGP',
        'image': 'assets/placeholder.png',
      },
      {
        'name': 'Smartphone Case',
        'price': '49 EGP',
        'image': 'assets/placeholder.png',
      },
      {
        'name': 'USB-C Cable',
        'price': '29 EGP',
        'image': 'assets/placeholder.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Recently Viewed')),
      body: recentlyViewed.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Recently Viewed Items',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start browsing to see your history',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: recentlyViewed.length,
              itemBuilder: (context, index) {
                final item = recentlyViewed[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                    ),
                    title: Text(item['name']!),
                    subtitle: Text(item['price']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item removed from history'),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${item['name']}')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
