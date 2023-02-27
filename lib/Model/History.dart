class History{

  int? _id;
  late int _goalId;
  late String _date;
  late double _deposit;

  History(this._goalId, this._date, this._deposit);
  History.withId(this._id, this._goalId, this._date, this._deposit);

  double get deposit => _deposit;

  set deposit(double value) {
    _deposit = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int get goalId => _goalId;

  set goalId(int value) {
    _goalId = value;
  }

  int get id => _id!;


  History.getMap(Map<String, dynamic> map){
    this._id=map['id'];
    this._goalId=map['goalId'];
    this._date=map['date'];
    this._deposit=map['deposit'];
  }
  Map<String, dynamic> toMap(){
    var map=Map<String, dynamic>();
    map['id']=this._id;
    map['goalId']=this._goalId;
    map['date']=this._date;
    map['deposit']=this._deposit;
    return map;
  }
}