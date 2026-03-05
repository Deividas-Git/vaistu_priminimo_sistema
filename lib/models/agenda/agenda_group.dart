import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';

class AgendaGroup {
  final TimeOfDay time;
  final List<AgendaItem> items;

  AgendaGroup({required this.time, required this.items});
}
