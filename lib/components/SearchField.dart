import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;

  const SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late ValueNotifier<bool> isEmptyNotifier;

  @override
  void initState() {
    super.initState();
    isEmptyNotifier = ValueNotifier(widget.controller.text.isEmpty);

    widget.controller.addListener(() {
      isEmptyNotifier.value = widget.controller.text.isEmpty;
    });

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        widget.controller.clear(); // Limpa o campo ao focar
        isEmptyNotifier.value = false;
      } else {
        isEmptyNotifier.value = widget.controller.text.isEmpty;
      }
    });
  }

  @override
  void dispose() {
    isEmptyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.focusNode.requestFocus(); // Foco ao clicar em qualquer parte do input
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            textAlign: TextAlign.left,
            cursorColor: Colors.grey,
            cursorHeight: 18,
            cursorWidth: 1.5,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (text) => widget.onChanged(),
          ),
          // Mostra o ícone e o texto apenas se o campo está vazio e não está focado
          ValueListenableBuilder<bool>(
            valueListenable: isEmptyNotifier,
            builder: (context, isEmpty, child) {
              return isEmpty && !widget.focusNode.hasFocus
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        const Icon(Icons.search, color: Colors.white54),
                        const SizedBox(width: 8),
                        Text(
                          'Nome do robô ou equipe',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontSize: 14,
                                color: Colors.white54,
                              ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
