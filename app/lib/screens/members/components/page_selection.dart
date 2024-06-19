import 'package:flutter/material.dart';

class PageSelectionRow<T> extends StatelessWidget {
  final int page;
  final int itemsPerPage;
  final List<T> itemsList;
  final VoidCallback previousPage;
  final VoidCallback nextPage;

  const PageSelectionRow({
    Key? key,
    required this.page,
    required this.itemsPerPage,
    required this.itemsList,
    required this.previousPage,
    required this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: page > 0 ? previousPage : null,
          child: const Text('Previous'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: (page + 1) * itemsPerPage < itemsList.length ? nextPage : null,
          child: const Text('Next'),
        ),
      ],
    );
  }
}
