import 'package:intl/intl.dart';

class CompetitionsModel {
  final int comp_id;
  final int comp_adress_id;
  final String comp_name;
  final String comp_date;
  


  CompetitionsModel(
      {required this.comp_id,
        required this.comp_adress_id,
        required this.comp_name,
        required this.comp_date});

  factory CompetitionsModel.fromMap(Map<String, dynamic> map) {
    DateTime? parsedDate;
    if (map['date'] != null) {
      parsedDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(map['date']);
    }

    return CompetitionsModel(
      comp_id: map['id'],
      comp_adress_id: map['adreass_id'],
      comp_name: map['name'],
      comp_date: DateFormat('dd/MM/yyyy').format(parsedDate!)
    );
  }
}