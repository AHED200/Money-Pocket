class Goal{

  int? _id;
  late String _name;
  late double _goal;
  late double _currentGoal;
  late String _date;

  Goal(this._name, this._goal, this._currentGoal, this._date);
  Goal.withId(this._id, this._name, this._goal, this._currentGoal, this._date);

  int get id => _id!;

  String get name => _name;

  double get currentGoal => _currentGoal;

  set currentGoal(double value) {
    _currentGoal = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  double get goal => _goal;

  set goal(double value) {
    _goal = value;
  }

  set name(String value) {
    _name = value;
  }


  Goal.getMap(Map<String, dynamic> map){
    this._id=map['id'];
    this._name=map["name"];
    this._goal=map["goal"];
    this._currentGoal=map['currentGoal'];
    this._date=map["date"];
  }
  Map<String, dynamic> toMap(){
    var map=Map<String, dynamic>();
    map['id']=this._id;
    map["name"]=this._name;
    map["goal"]=this._goal;
    map['currentGoal']=this._currentGoal;
    map["date"]=this._date;
    return map;
  }

}