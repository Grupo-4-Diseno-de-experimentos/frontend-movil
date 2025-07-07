import 'package:trabajoexp/model/objetive_data.dart';

class CustomerRequest {
  final String goal;
  final String method;
  final String sexo;
  final int edad;
  final double altura;
  final double peso;
  final String activityLevel;
  final String dietType;

  CustomerRequest({
    required this.goal,
    required this.method,
    required this.sexo,
    required this.edad,
    required this.altura,
    required this.peso,
    required this.activityLevel,
    required this.dietType,
  });

  /// 🔥 Factory para construir desde ObjectiveData
  factory CustomerRequest.fromObjectiveData(ObjectiveData data) {
    return CustomerRequest(
      goal: data.objetivoPrincipal?.toUpperCase() ?? '',
      method: data.metodoPreferido?.toUpperCase() ?? '',
      sexo: data.sexo?.toUpperCase() ?? '',
      edad: data.edad ?? 0,
      altura: data.altura ?? 0,
      peso: data.peso ?? 0,
      activityLevel: data.nivelActividad?.toUpperCase() ?? '',
      dietType: data.dietaPreferida?.toUpperCase() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "goal": goal,
      "method": method,
      "sexo": sexo,
      "edad": edad,
      "altura": altura,
      "peso": peso,
      "activityLevel": activityLevel,
      "dietType": dietType,
    };
  }
}