class CategoryMatchModel {

  final String robot_1_name;
  final String robot_2_name;
  final String team_1_name;
  final String team_2_name;
  final int match_id;
  final int robot_1_id;
  final int robot_2_id;


  CategoryMatchModel(
      {
        required this.robot_1_name,
        required this.robot_2_name,
        required this.team_2_name,
        required this.team_1_name,
        required this.match_id,
        required this.robot_1_id,
        required this.robot_2_id,
      });

  factory CategoryMatchModel.fromMap(Map<String, dynamic> map) {

    return CategoryMatchModel(
        robot_1_name: map['robot_1_name'],
        robot_2_name: map['robot_2_name'],
        team_1_name: map['team_1_name'],
        team_2_name: map['team_2_name'],
        match_id: map['id'],
        robot_1_id: map['robot_1'],
        robot_2_id: map['robot_2'],
    );
  }
}
