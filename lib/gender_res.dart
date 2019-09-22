
class GenderRes{
  final String name;
  final String gender;
  final double probability;
  final int count;

  GenderRes({this.name,this.gender,this.probability,this.count});

  factory GenderRes.fromJson(Map<String,dynamic> json){
    return GenderRes(
      name: json['name'],
      gender: json['gender'],
      probability:  (json['probability'] * 1.0),
      count: json['count']
    );
  }

  @override
  String toString() {
    return 'GenderRes{name: $name, gender: $gender, probability: $probability, count: $count}';
  }
}