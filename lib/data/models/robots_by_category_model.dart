class RobotsByCategoryModel {
  final int robot_id;
  final int robot_team_id;
  final String robot_name;
  //final String robot_photo;

  RobotsByCategoryModel(
      {required this.robot_id,
      required this.robot_team_id,
      required this.robot_name,
      //required this.robot_photo
      });

  factory RobotsByCategoryModel.fromMap(Map<String, dynamic> map){
    return RobotsByCategoryModel(
        robot_id: map['id'],
        robot_team_id: map['team_id'],
        robot_name: map['name'],
        //robot_photo: map['photo']
    );
  }
}
