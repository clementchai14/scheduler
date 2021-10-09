
import 'package:scheduler/const.dart' as constants;

class Schedule {
  String guid;
  String title;
  String category;
  String date;
  String startTime;
  String endTime;
  String description;
  bool reminder;
  String status;

  Schedule({
    this.guid,
    this.title,
    this.category,
    this.date,
    this.startTime,
    this.endTime,
    this.description,
    this.reminder,
    this.status,
  });

  factory Schedule.fromMap(Map<String, dynamic> json) => new Schedule(
    guid: json[constants.SQLiteConstants.KEY_GUID],
    title: json[constants.SQLiteConstants.KEY_TITLE],
    category: json[constants.SQLiteConstants.KEY_CATEGORY],
    date: json[constants.SQLiteConstants.KEY_DATE],
    startTime: json[constants.SQLiteConstants.KEY_START_TIME],
    endTime: json[constants.SQLiteConstants.KEY_END_TIME],
    description: json[constants.SQLiteConstants.KEY_DESCRIPTION],
    reminder: json[constants.SQLiteConstants.KEY_REMINDER] == 1,
    status: json[constants.SQLiteConstants.KEY_STATUS]
  );

  Map<String, dynamic> toMap() => {
    constants.SQLiteConstants.KEY_GUID : guid,
    constants.SQLiteConstants.KEY_TITLE : title,
    constants.SQLiteConstants.KEY_CATEGORY : category,
    constants.SQLiteConstants.KEY_DATE : date,
    constants.SQLiteConstants.KEY_START_TIME : startTime,
    constants.SQLiteConstants.KEY_END_TIME : endTime,
    constants.SQLiteConstants.KEY_DESCRIPTION : description,
    constants.SQLiteConstants.KEY_REMINDER : reminder ? 1 : 0,
    constants.SQLiteConstants.KEY_STATUS : status
  };
}