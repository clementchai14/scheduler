
class ScheduleStatus{
  static const String DONE = 'Done';
  static const String PENDING = 'Pending';
}

enum ScheduleStatusEnum{
  All,
  Today,
  ToDo,
  Done,
  OverDue
}

class SQLiteConstants{
  static const String DB_SCHEDULE_TABLE = 'Schedule';
  static const String KEY_GUID = 'Guid';
  static const String KEY_DATE = 'Date';
  static const String KEY_START_TIME = 'StartTime';
  static const String KEY_END_TIME = 'EndTime';
  static const String KEY_TITLE = 'Title';
  static const String KEY_DESCRIPTION = 'Description';
  static const String KEY_REMINDER = 'Reminder';
  static const String KEY_CATEGORY = 'Category';
  static const String KEY_STATUS = 'Status';

  static const String CREATE_SCHEDULE_TABLE = 'CREATE TABLE ' + DB_SCHEDULE_TABLE + ' ('
      + KEY_GUID + ' TEXT PRIMARY KEY, '
      + KEY_TITLE + ' TEXT, '
      + KEY_CATEGORY + ' TEXT, '
      + KEY_DATE + ' TEXT, '
      + KEY_START_TIME + ' TEXT, '
      + KEY_END_TIME + ' TEXT, '
      + KEY_DESCRIPTION + ' TEXT, '
      + KEY_REMINDER + ' INTEGER, '
      + KEY_STATUS + ' TEXT);' ;
}

