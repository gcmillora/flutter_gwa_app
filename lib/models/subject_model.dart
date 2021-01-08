class Subject {
  int id;
  String title;
  String unit;
  String grade;

  Subject({this.title, this.unit, this.grade});
  Subject.withId({this.title, this.unit, this.grade, this.id});
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['unit'] = unit;
    map['grade'] = grade;
    return map;
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject.withId(
        id: map['id'],
        title: map['title'],
        grade: map['grade'],
        unit: map['unit']);
  }
}
