import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question':
            'Is there a kilometer limit for the bike rental, and are there any extra charges if I exceed it?',
        'answer': '100 kms per day and extra ones mentioned in the list only.'
      },
      {
        'question':
            'Can I pick up the bike from one location and drop it off at another? If yes, what are the conditions?',
        'answer':
            'Pickup and drop we can manage by our delivery crew at cost starting 200 each side.'
      },
      {
        'question':
            'What are the payment methods accepted for bookings and deposits?',
        'answer': 'UPI and cash.'
      },
      {
        'question':
            'Do I need to bring my own helmet, or will one be provided?',
        'answer':
            'We give 2 helmets complementary just the premium once are chargeable starting Rs 50/day'
      },
      {
        'question': 'Can I extend my trip duration?',
        'answer':
            '100 % cancellation free only security deposit is to be refunded',
      },
      {
        'question':
            'Can I upgrade my booked bike to a different model if it’s available?',
        'answer':
            'Yes when you visit you can change if the fleet is free for your booking period by paying the upgrade cost only.',
      },
      {
        'question':
            'What documents do I need to bring while picking up the bike?',
        'answer': 'aadhar card and Driver\'s licence',
      },
      {
        'question':
            'What should I do if the bike breaks down during the ride? Is roadside assistance available?',
        'answer':
            'new models certainly have RSA by the manufacturer company. And rest we talk care if it\'s our limit of 20-30 kms radius.',
      },
      {
        'question': 'Are there any age restrictions for renting a bike?',
        'answer': 'You need to have a licence to drive, age is just a number',
      }
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        children: faqs
            .map((faq) => FAQItem(
                  question: faq['question']!,
                  answer: faq['answer']!,
                ))
            .toList(),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).canvasColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            tileColor: Theme.of(context).canvasColor,
            title: Text(
              widget.question,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      widget.answer,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
