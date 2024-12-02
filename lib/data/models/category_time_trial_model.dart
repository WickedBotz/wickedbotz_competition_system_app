class CategoryTimeTrialModel {

  final String robot_name;
  final String team_name;
  final double time1;
  final double time2;
  final double time3;
  final int id;


  CategoryTimeTrialModel(
      {
        required this.robot_name,
        required this.team_name,
        required this.time1,
        required this.time2,
        required this.time3,
        required this.id
      });

  factory CategoryTimeTrialModel.fromMap(Map<String, dynamic> map) {

    return CategoryTimeTrialModel(
        robot_name: map['robot_name'],
        team_name: map['team_name'],
        time1: map['time1'] ?? 0.0,
        time2: map['time2'] ?? 0.0,
        time3: map['time3'] ?? 0.0,
        id: map['id']
    );
  }
}
