
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:scheduler/model/schedule.dart';
import 'package:scheduler/screen/add_schedule_screen.dart';
import 'package:scheduler/sqlite_db.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget{

  _HomeScreenState __homeScreenState;

  @override
  State<StatefulWidget> createState() {
    __homeScreenState = _HomeScreenState();
    return __homeScreenState;
  }

  getState() => __homeScreenState;
}

class _HomeScreenState extends State<HomeScreen>{

  Future<List<Schedule>> _scheduleList;
  int _todayScheduleTotal = 0;
  int _doneScheduleTotal = 0;
  int _todoScheduleTotal = 0;
  int _overDueScheduleTotal = 0;
  int _selectedStatusCard = 0;
  DateTime _selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('yyyy/MM/dd');
  DateFormat textDateFormat = DateFormat('EEE, yyyy/MM/dd');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  refresh(){
    SQLiteDb.instance.getTodayScheduleCount().then((value){
      setState(() => _todayScheduleTotal = value);
    });
    SQLiteDb.instance.getDoneScheduleCount().then((value){
      setState(() => _doneScheduleTotal = value);
    });
    SQLiteDb.instance.getToDoScheduleCount().then((value){
      setState(() => _todoScheduleTotal = value);
    });
    SQLiteDb.instance.getOverDueScheduleCount().then((value){
      setState(() => _overDueScheduleTotal = value);
    });
    setState((){ _scheduleList = SQLiteDb.instance.getTodayScheduleList();});
  }

  Future<bool> _optionItems(Schedule schedule){
    if(schedule.status != 'Done'){
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Choose An Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Ionicons.create_outline,
                  color: Colors.orange,
                ),
                title: Text('Edit'),
                onTap: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddScheduleScreen(schedule: schedule))
                  );
                  if(result != null && result){
                    Navigator.of(context).pop(true);
                    Flushbar(
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      message:  'Updated',
                      duration:  Duration(seconds: 2),
                      animationDuration: Duration(seconds: 1),
                      icon: Icon(Ionicons.checkmark_circle_outline, color: Colors.lightGreenAccent),
                    )..show(context);
                  }else{
                    Navigator.of(context).pop(false);
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Ionicons.trash_outline,
                  color: Colors.red,
                ),
                title: Text('Delete'),
                onTap: () async {
                  await SQLiteDb.instance.deleteSchedule(schedule.guid).then((value){
                    Navigator.of(context).pop(true);
                    Flushbar(
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      message:  'Deleted',
                      duration:  Duration(seconds: 2),
                      animationDuration: Duration(seconds: 1),
                      icon: Icon(Ionicons.checkmark_circle_outline, color: Colors.lightGreenAccent),
                    )..show(context);
                  });
                },
              ),
              ListTile(
                  leading: Icon(
                    Ionicons.checkmark_outline,
                    color: Colors.lightGreenAccent,
                  ),
                  title: Text('Mark As Done'),
                  onTap: () async {
                    await SQLiteDb.instance.doneSchedule(schedule.guid).then((value){
                      Navigator.of(context).pop(true);
                      Flushbar(
                        margin: EdgeInsets.all(8),
                        borderRadius: 8,
                        message:  'Congrats! You have completed one schedule',
                        duration:  Duration(seconds: 2),
                        animationDuration: Duration(seconds: 1),
                        icon: Icon(Ionicons.checkmark_circle_outline, color: Colors.lightGreenAccent),
                      )..show(context);
                    });
                  }
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text('DISMISS', style: TextStyle(color: Colors.grey)),
              ),
            )
          ],
        ),
      ) ?? false;
    }else{
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Choose An Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Ionicons.trash_outline,
                  color: Colors.red,
                ),
                title: Text('Delete'),
                onTap: () async {
                  await SQLiteDb.instance.deleteSchedule(schedule.guid).then((value){
                    Navigator.of(context).pop(true);
                    Flushbar(
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      message:  'Deleted',
                      duration:  Duration(seconds: 2),
                      animationDuration: Duration(seconds: 1),
                      icon: Icon(Ionicons.checkmark_circle_outline, color: Colors.lightGreenAccent),
                    )..show(context);
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text('DISMISS', style: TextStyle(color: Colors.grey)),
              ),
            )
          ],
        ),
      ) ?? false;
    }
  }

  Future<bool> _showDetails(Schedule schedule){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${schedule.title}'),
            Text('Category: ${schedule.category}'),
            Text('Date: ${schedule.date}'),
            Text('Start Time: ${schedule.startTime}'),
            Text('End Time: ${schedule.endTime}'),
            Text('Reminder: ${schedule.reminder}'),
            Text('Description: ${schedule.description}')
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text('DISMISS', style: TextStyle(color: Colors.grey)),
            ),
          )
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _homeScreenTopBanner(),
            _homeScreenContents(),
          ],
        ),
      ),
    );
  }

  Widget _homeScreenTopBanner(){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ],
                  tileMode: TileMode.repeated
              ),
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      10.0
                  )
              )
          ),
      ),
    );
  }

  Widget _homeScreenContents(){
    return Positioned(
        top: 0,
        left: 15,
        right: 15,
        bottom: 0,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _statusList(),
              _dateFilter(),
              _listViewSchedule()
            ],
          ),
        )
    );
  }

  Widget _statusList(){
    return Container(
      height: 70.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState((){
                  _selectedStatusCard = 0;
                  _scheduleList = SQLiteDb.instance.getTodayScheduleList();
                });
              },
              child: Card(
                color: _selectedStatusCard == 0 ? Colors.white.withOpacity(0.85) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _todayScheduleTotal.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Ionicons.today,
                            size: 12.0,
                            color: Colors.orange
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Today',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState((){
                  _selectedStatusCard = 1;
                  _scheduleList = SQLiteDb.instance.getToDoScheduleList();
                });
              },
              child: Card(
                color: _selectedStatusCard == 1 ? Colors.white.withOpacity(0.85) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _todoScheduleTotal.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Ionicons.receipt,
                            size: 12.0,
                            color: Colors.blue
                        ),
                        SizedBox(width: 2),
                        Text(
                          'To Do',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState((){
                  _selectedStatusCard = 2;
                  _scheduleList = SQLiteDb.instance.getDoneScheduleList();
                });
              },
              child: Card(
                color: _selectedStatusCard == 2 ? Colors.white.withOpacity(0.85) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _doneScheduleTotal.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Ionicons.checkmark,
                            size: 12.0,
                            color: Colors.green
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStatusCard = 3;
                  _scheduleList = SQLiteDb.instance.getOverDueScheduleList();
                });
              },
              child: Card(
                color: _selectedStatusCard == 3 ? Colors.white.withOpacity(0.85) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _overDueScheduleTotal.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Ionicons.timer,
                            size: 12.0,
                            color: Colors.red
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Overdue',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
  
  Widget _dateFilter(){
    return Container(
      child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  textDateFormat.format(_selectedDate),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
                flex: 1,
              ),
              Flexible(
                child: GestureDetector(
                  onTap: (){
                    showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2200)
                    ).then((value){
                      if(value != null){
                        setState(() {
                          _selectedDate = value;
                          _scheduleList = SQLiteDb.instance.getScheduleListByDate(value);
                        });
                      }
                    });
                  },
                  child: Icon(
                    Ionicons.calendar_outline,
                    color: Colors.white,
                  ),
                ),
                flex: 0,
              ),

            ],
          )
      ),
    );
  }
  
  Widget _listViewSchedule(){
    return Flexible(
      child: FutureBuilder<List<Schedule>>(
        future: _scheduleList,
        builder: (BuildContext context, AsyncSnapshot<List<Schedule>> snapshot){
          if(snapshot.connectionState == ConnectionState.done
              && snapshot.hasData
              && snapshot.data != null
              && snapshot.data.length > 0){
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  Schedule schedule = snapshot.data[index];
                  return GestureDetector(
                    onLongPress: () async {
                      await _showDetails(schedule);
                    },
                    onTap: () async {
                      await _optionItems(schedule).then((result){
                        if(result != null && result){
                          refresh();
                      }});
                    },
                    child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        schedule.title,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        schedule.category,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.grey,
                                            size: 12.0,
                                          ),
                                          flex: 0,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            child: Text(
                                              schedule.date,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0
                                              ),
                                            ),
                                            flex: 0
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Icon(
                                            Icons.access_time_outlined,
                                            color: Colors.grey,
                                            size: 12.0,
                                          ),
                                          flex: 0,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            child: Text(
                                              schedule.startTime + ' - ' + schedule.endTime,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0
                                              ),
                                            ),
                                            flex: 0
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _showStatus(schedule.status),
                                flex: 0,
                              )
                            ],
                          ),
                        )
                    ),
                  );
                }
            );
          } else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else{
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.document_text_outline,
                    color: Theme.of(context).accentColor,
                    size: 150.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'No Schedule',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).accentColor
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            );
          }
        },
      ),
    );
  }

  Widget _showStatus(String status){
    if(status == 'Done'){
      return Icon(
        Ionicons.checkmark,
        color: Colors.green,
      );
    }
    return Icon(
      Ionicons.receipt,
      color: Colors.blue,
    );
  }
}