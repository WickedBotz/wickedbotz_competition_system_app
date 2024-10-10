class LineFollowersModel {
  final int lf_id;
  final int lf_team_id;
  final String lf_name;
  final String lf_photo;

  LineFollowersModel(
      {required this.lf_id,
      required this.lf_team_id,
      required this.lf_name,
      required this.lf_photo});

  factory LineFollowersModel.fromMap(Map<String, dynamic> map){
    return LineFollowersModel(
        lf_id: map['id'],
        lf_team_id: map['team_id'],
        lf_name: map['name'],
        lf_photo: map['photo']
    );
  }
}
