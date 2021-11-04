
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:scheduler/length_limiting_textfield_fixed.dart';
import 'package:scheduler/model/schedule.dart';
import 'package:scheduler/sqlite_db.dart';
import 'package:smart_select/smart_select.dart';
import 'package:uuid/uuid.dart';
import 'package:scheduler/const.dart' as constants;

class AddScheduleScreen extends StatefulWidget {

  final Schedule schedule;

  AddScheduleScreen({this.schedule});

  @override
  State<StatefulWidget> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {

  String _selectedCategory = 'BUSINESS';
  bool _remindUser = false;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  //ssss

  List<S2Choice<String>> _categoryOptions = [
    S2Choice<String>(value: 'BUSINESS', title: 'BUSINESS'),
    S2Choice<String>(value: 'CLEANING', title: 'CLEANING'),
    S2Choice<String>(value: 'EAT', title: 'EAT'),
    S2Choice<String>(value: 'ENTERTAINMENT', title: 'ENTERTAINMENT'),
    S2Choice<String>(value: 'PERSONAL', title: 'PERSONAL'),
    S2Choice<String>(value: 'SPORT', title: 'SPORT'),
    S2Choice<String>(value: 'STUDY', title: 'STUDY'),
  ];

  Future<bool> _onBackPressed(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirm to discard?'),
        content: new Text('Changes will not be saved.'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Ionicons.close_outline,
                color: Colors.red,
              ),
              onPressed: () => Navigator.of(context).pop(false)
          ),
          IconButton(
              icon: Icon(
                Ionicons.checkmark_outline,
                color: Colors.lightGreenAccent,
              ),
              onPressed: () => Navigator.of(context).pop(true)
          )
        ],
      ),
    ) ?? false;
  }

  Future<void> _saveSchedule() async {
    if(_titleController.text.isNotEmpty
        && _dateController.text.isNotEmpty
        && _startTimeController.text.isNotEmpty
        && _endTimeController.text.isNotEmpty){
      if(widget.schedule != null){
        Schedule schedule = new Schedule(
            guid: widget.schedule.guid,
            title: _titleController.text,
            category: _selectedCategory,
            date: _dateController.text,
            startTime: _startTimeController.text,
            endTime: _endTimeController.text,
            reminder: _remindUser,
            description: _descController.text,
            status: widget.schedule.guid
        );
        await SQLiteDb.instance.updateSchedule(schedule).then((value){

          Navigator.pop(context, true);
        });
      }else{
        Schedule schedule = new Schedule(
            guid: Uuid().v1(),
            title: _titleController.text,
            category: _selectedCategory,
            date: _dateController.text,
            startTime: _startTimeController.text,
            endTime: _endTimeController.text,
            reminder: _remindUser,
            description: _descController.text,
            status: constants.ScheduleStatus.PENDING
        );
        await SQLiteDb.instance.insertSchedule(schedule).then((value) => Navigator.pop(context, true));
      }
    }else{
      Flushbar(
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        message:  'Please fill in all blank fields.',
        duration:  Duration(seconds: 2),
        animationDuration: Duration(seconds: 1),
        icon: Icon(Ionicons.warning_outline, color: Colors.yellowAccent),
      )..show(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.schedule != null){
      _titleController.text = widget.schedule.title;
      _selectedCategory = widget.schedule.category;
      _dateController.text = widget.schedule.date;
      _startTimeController.text = widget.schedule.startTime;
      _endTimeController.text = widget.schedule.endTime;
      _descController.text = widget.schedule.description;
      _remindUser = widget.schedule.reminder;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              'New Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.88,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor,
                        ],
                        tileMode: TileMode.repeated
                    )
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                          child: Theme(
                            data: ThemeData(
                                textSelectionTheme: TextSelectionThemeData(
                                  selectionColor: Theme.of(context).accentColor,
                                  selectionHandleColor: Theme.of(context).accentColor,
                                  cursorColor: Theme.of(context).accentColor,
                                )
                            ),
                            child: TextField(
                              controller: _titleController,
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              maxLines: 1,
                              inputFormatters: [
                                LengthLimitingTextFieldFormatterFixed(35)
                              ],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  labelText: 'Schedule Title',
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                            ),
                          )
                      ),
                      flex: 0,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.0, right: 15.0),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Colors.white,
                                width: 1.0
                            ),
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: SmartSelect.single(
                            tileBuilder: (context, state){
                              return S2Tile(
                                leading: Text(
                                  state.title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0
                                  ),
                                ),
                                title: Text(
                                  state.valueTitle,
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                trailing: Icon(
                                  Ionicons.chevron_forward_outline,
                                  color: Colors.white,
                                ),
                                onTap: state.showModal,
                                value: state.value,
                                hideValue: true,
                              );
                            },
                            title: 'Category',
                            value: _selectedCategory,
                            choiceItems: _categoryOptions,
                            modalType: S2ModalType.bottomSheet,
                            modalHeaderStyle: S2ModalHeaderStyle(
                                backgroundColor: Theme.of(context).primaryColor,
                                textStyle: TextStyle(
                                    color: Colors.white
                                ),
                                actionsIconTheme: IconThemeData(
                                  color: Colors.lightGreenAccent,
                                )
                            ),
                            modalConfirm: true,
                            choiceType: S2ChoiceType.chips,
                            onChange: (state) => setState(() => _selectedCategory = state.value)
                        ),
                      ),
                      flex: 0,
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)
                              )
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: DateTimeField(
                                    controller: _dateController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Date',
                                        suffixIcon: Icon(
                                            Ionicons.calendar
                                        )
                                    ),
                                    format: DateFormat('yyyy/MM/dd'),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          initialDate: currentValue ?? DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2200)
                                      );
                                    }
                                ),
                                flex: 0,
                              ),
                              SizedBox(height: 10.0),
                              Expanded(
                                child: Row(
                                    children: [
                                      Expanded(
                                        child: DateTimeField(
                                            controller: _startTimeController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Start Time',
                                                suffixIcon: Icon(
                                                    Ionicons.time_outline
                                                )
                                            ),
                                            format: DateFormat.Hm(),
                                            onShowPicker: (context, currentValue) async {
                                              final time = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                              );
                                              return DateTimeField.convert(time);
                                            }
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: DateTimeField(
                                            controller: _endTimeController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'End Time',
                                                suffixIcon: Icon(
                                                    Ionicons.time_outline
                                                )
                                            ),
                                            format: DateFormat.Hm(),
                                            onShowPicker: (context, currentValue) async {
                                              final time = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                              );
                                              return DateTimeField.convert(time);
                                            }
                                        ),
                                      )
                                    ]
                                ),
                                flex: 0,
                              ),
                              SizedBox(height: 10.0),
                              Expanded(
                                child: TextField(
                                  controller: _descController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      labelText: 'Description',
                                      labelStyle: TextStyle(
                                          color: Colors.grey
                                      )
                                  ),
                                ),
                                flex: 0,
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 0,
                                        child: Icon(
                                          Ionicons.alarm_outline
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Reminder',
                                          style: TextStyle(
                                            fontSize: 18.0
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Switch(
                                          activeColor: Theme.of(context).primaryColor,
                                          value: _remindUser,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _remindUser = value;
                                            });
                                            },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                flex: 0,
                              ),
                              Flexible(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ButtonTheme(
                                      minWidth: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        padding: EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                        child: Text(
                                          widget.schedule != null ? 'Update Schedule' : 'Create Schedule',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0
                                          ),
                                        ),
                                        onPressed: () => _saveSchedule()
                                      ),
                                    ),
                                  )
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                )
            ),
          ),
        )
    );
  }
}
