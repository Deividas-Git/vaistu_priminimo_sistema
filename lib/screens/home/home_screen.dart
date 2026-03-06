import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/screens/home/agenda_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime today = DateTime.now();
  final DateTime tomorrow = DateTime.now().add(Duration(days: 1));
  final DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Center(
            child: Text("Dienotvarkė", style: TextStyle(color: Colors.white)),
          ),
          backgroundColor: ColorScheme.of(
            context,
          ).primary.withValues(alpha: 0.7),
          bottom: TabBar(
            dividerColor: Colors.white,
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            unselectedLabelStyle: TextStyle(
              color: ColorScheme.of(context).onSurfaceVariant,
              fontSize: 16,
              //fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: "Vakar"),
              Tab(text: "Šiandien"),
              Tab(text: "Rytoj"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AgendaScreen(date: yesterday),
            AgendaScreen(date: today),
            AgendaScreen(date: tomorrow),
          ],
        ),
      ),
    );
  }
}
