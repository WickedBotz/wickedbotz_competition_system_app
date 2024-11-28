class CategoryTimeTrialModel {

  final String robot_name;
  final String team_name;
  final int robot_id;
  final int team_id;


  CategoryTimeTrialModel(
      {
        required this.robot_name,
        required this.team_name,
        required this.robot_id,
        required this.team_id
      });

  factory CategoryTimeTrialModel.fromMap(Map<String, dynamic> map) {

    return CategoryTimeTrialModel(
        robot_name: map['name'],
        team_name: map['team_name'],
        robot_id: map['id'],
        team_id: map['team_id']
    );
  }
}
