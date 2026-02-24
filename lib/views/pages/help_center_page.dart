import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied: $text')));
  }

  void _showContactOptions(String contact, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              contact,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _copyToClipboard(contact, context);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Us', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: const Text('abdofareed133@gmail.com'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () =>
                        _showContactOptions('abdofareed133@gmail.com', context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone 1'),
                    subtitle: const Text('01556109661'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _showContactOptions('01556109661', context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone 2'),
                    subtitle: const Text('01020350414'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _showContactOptions('01020350414', context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _FaqItem(
              question: 'How do I track my order?',
              answer: 'You can track your order in the "My Orders" section.',
            ),
            _FaqItem(
              question: 'What is your return policy?',
              answer: 'We accept returns within 30 days of purchase.',
            ),
            _FaqItem(
              question: 'Do you offer free shipping?',
              answer: 'Free shipping is available for orders above 500 EGP.',
            ),
            _FaqItem(
              question: 'How do I reset my password?',
              answer: 'Use the "Forgot Password" option on the login page.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.question),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
