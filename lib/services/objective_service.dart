import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabajoexp/model/objetive_data.dart';

class ObjectiveService {
  static final ObjectiveService _instance = ObjectiveService._internal();

  factory ObjectiveService() {
    return _instance;
  }

  ObjectiveService._internal();

  Future<void> saveObjectives(ObjectiveData objectives) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'objetivoPrincipal': objectives.objetivoPrincipal,
      'metodoPreferido': objectives.metodoPreferido,
      'nivelActividad': objectives.nivelActividad,
      'dietaPreferida': objectives.dietaPreferida,
    });
    await prefs.setString('objectives', data);
  }

  Future<ObjectiveData> loadObjectives() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('objectives');

    if (jsonString != null) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return ObjectiveData()
        ..objetivoPrincipal = data['objetivoPrincipal']
        ..metodoPreferido = data['metodoPreferido']
        ..nivelActividad = data['nivelActividad']
        ..dietaPreferida = data['dietaPreferida'];
    } else {
      return ObjectiveData();
    }
  }

  Future<void> clearObjectives() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('objectives');
  }
}