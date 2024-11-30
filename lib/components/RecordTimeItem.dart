import 'package:flutter/material.dart';

class RecordedTimeItem extends StatefulWidget {
  final String time;
  final VoidCallback onEdit;
  final bool isValid;

  const RecordedTimeItem({
    Key? key,
    required this.time,
    required this.onEdit,
    this.isValid = false, // Padrão: não validado
  }) : super(key: key);

  @override
  _RecordedTimeItemState createState() => _RecordedTimeItemState();
}

class _RecordedTimeItemState extends State<RecordedTimeItem> {
  late bool isValid;

  @override
  void initState() {
    super.initState();
    isValid = widget.isValid; // Inicializa com o valor passado no construtor
  }

  void toggleValidation() {
    setState(() {
      isValid = !isValid; // Alterna o estado de validação
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      width: 280.0,
      height: 65, // Define a largura fixa do componente
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Exibição do tempo
          Text(
            'Tempo: ${widget.time}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // Ícones de ação
          Row(
            mainAxisSize: MainAxisSize.min, // Ajusta para ocupar apenas o necessário
            children: [
              GestureDetector(
                onTap: widget.onEdit,
                child: const Icon(Icons.edit, color: Colors.orangeAccent, size: 20),
              ),
              const SizedBox(width: 4), // Reduzido para um pequeno espaçamento
              GestureDetector(
                onTap: toggleValidation,
                child: Icon(
                  Icons.check_circle,
                  color: isValid ? Colors.green : Colors.red,
                  size: 20, // Ajusta o tamanho do ícone
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
