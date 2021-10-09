
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:scheduler/custom_bottomappbar.dart';
import 'package:scheduler/screen/add_schedule_screen.dart';
import 'package:scheduler/screen/home_screen.dart';
import 'package:scheduler/screen/summary_screen.dart';
import 'package:scheduler/sqlite_db.dart';
import 'NotificationManager.dart';

NotificationManager notificationManager = new NotificationManager();

class Home extends StatefulWidget{

  @override
  State<StatefulWidget> createState()  => _HomeState();
}

class _HomeState extends State<Home>{

  PageController _pageController;
  var homePage = HomeScreen();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      _checkScheduleNotification
    );
    _pageController = new PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  void _checkScheduleNotification() async {
    SQLiteDb.instance.getReminderScheduleList().then((value){
      if(value != null && value.length > 0){
        String msg = '';
        for(int i = 0; i < value.length; i++){
          msg += '[' + value[i].startTime + '-' + value[i].endTime + '] ' + value[i].title + '\n';
        }
        NotificationManager notificationManager = new NotificationManager();
        notificationManager.initNotificationManager();
        notificationManager.showNotification('${value.length} Incomplete Schedule Today', msg);
      }
    });
  }

  void _onItemSelected(int index){
    setState(() {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300), curve: Curves.ease
      );
    });
  }

  void _onAddScheduleResults(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddScheduleScreen())
    );
    if(result != null && result){
      homePage.getState().refresh();
      Flushbar(
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        message:  'Success',
        duration:  Duration(seconds: 2),
        animationDuration: Duration(seconds: 1),
        icon: Icon(Ionicons.checkmark_circle_outline, color: Colors.lightGreenAccent),
      )..show(context);
    }
  }

  List<CustomBottomAppBarItem> _appBarItems(){
    return [
      CustomBottomAppBarItem(
        icon: Ionicons.home,
        hasNotification: false
      ),
      CustomBottomAppBarItem(
        icon: Ionicons.bar_chart,
        hasNotification: false
      ),
    ];
  }

  List<Widget> _buildScreens(){
    return [
      homePage,
      SummaryScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _onAddScheduleResults(context);
          },
          child: Icon(
              Ionicons.add
          ),
          elevation: 2,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
          ),
          child: CustomBottomAppBar(
            onTabSelected: _onItemSelected,
            items: _appBarItems(),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Scheduler',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Ionicons.share_outline),
                onPressed: () async {
                  var result = await SQLiteDb.exportDatabase();
                  if(result){
                    Flushbar(
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      message:  'Successfully Exported to Download Folder',
                      duration:  Duration(seconds: 2),
                      animationDuration: Duration(seconds: 1),
                      icon: Icon(Ionicons.checkmark_circle_outline, color: Colors.lightGreenAccent),
                    )..show(context);
                  }else{
                    Flushbar(
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      message:  'Fail to Export',
                      duration:  Duration(seconds: 2),
                      animationDuration: Duration(seconds: 1),
                      icon: Icon(Ionicons.warning_outline, color: Colors.red),
                    )..show(context);
                  }
                }
            )
          ],
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: SizedBox.expand(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onItemSelected,
              children: _buildScreens(),
            ),
          ),
        )
    );
  }

}