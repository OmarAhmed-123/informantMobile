import 'package:flutter/material.dart';

//number 12 in the pdf
class MoreInfoList extends StatelessWidget {
  const MoreInfoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6, // Placeholder for 6 items in the list
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            tileColor: Colors.grey[800],
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '3/29/2024',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'blah blah...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '0.0\$',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
