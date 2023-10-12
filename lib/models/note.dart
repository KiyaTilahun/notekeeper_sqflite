class Note {
  late int _id;
  late String _title;
  String? _description;
  late String _date;
  late int _priority;

  Note(this._title, this._date, this._priority, this._description);
  Note.withId(
      this._id, this._title, this._date, this._priority, this._description);
  int get id => _id;
  String get title => _title;
  String get description => _description!;
  int get priority => _priority;
  String get date => _date;
  set title(String newtitle) {
    if (newtitle.length <= 255) {
      this._title = newtitle;
    }
  }

  set description(String newdesc) {
    if (newdesc.length <= 255) {
      // ignore: unnecessary_this
      this._description = newdesc;
    }
  }

  set priority(int newpriority) {
    if (newpriority >= 1 && newpriority <= 2) {
      // ignore: unnecessary_this
      this._priority = newpriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['desciprtion'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
 
}
