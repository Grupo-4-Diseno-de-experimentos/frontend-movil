import 'package:flutter/material.dart';
import 'package:trabajoexp/widgets/app_side_bar_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const AppSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPremiumCard(),
            const SizedBox(height: 16),
            _buildCreatePlanCard(context),
            const SizedBox(height: 16),
            _buildPatientsCard(),
            const SizedBox(height: 16),
            _buildWeeklyProgressCard(),
            const SizedBox(height: 16),
            _buildRecipesLibraryCard(),
            const SizedBox(height: 16),
            _buildClientViewCard(),
            const SizedBox(height: 16),
            _buildTrackingPanelCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.grey, Colors.blueGrey]),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.star, color: Colors.white, size: 40),
          SizedBox(height: 10),
          Text('Plan Premium', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('\$12 por usuario/mes', style: TextStyle(fontSize: 18, color: Colors.white70)),
          SizedBox(height: 10),
          Text('Organiza comidas personalizadas para tus clientes con herramientas avanzadas', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.white70),
              SizedBox(width: 5),
              Text('Acceso completo a todas las funciones', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePlanCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes navegar a tu pantalla de crear plan
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.add, color: Colors.white, size: 36),
            SizedBox(height: 10),
            Text('Crear Nuevo Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 5),
            Text('Diseña planes de comida personalizados desde cero', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.white70),
                SizedBox(width: 5),
                Text('5 min aprox', style: TextStyle(color: Colors.white70)),
                SizedBox(width: 20),
                Icon(Icons.check_circle, size: 16, color: Colors.white70),
                SizedBox(width: 5),
                Text('Plantillas incluidas', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.people, color: Colors.white, size: 36),
          SizedBox(height: 10),
          Text('Mis Pacientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('24', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('Gestiona perfiles y seguimiento', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.trending_up, color: Colors.white, size: 36),
          SizedBox(height: 10),
          Text('Progreso Semanal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('+18%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('Adherencia a planes', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildRecipesLibraryCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrangeAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.library_books, color: Colors.white, size: 36),
          SizedBox(height: 10),
          Text('Biblioteca de Recetas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('+250 recetas nutritivas verificadas', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildClientViewCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.black, Colors.grey]),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.remove_red_eye, color: Colors.white, size: 36),
          SizedBox(height: 10),
          Text('✨ Vista de Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('Interfaz intuitiva y clara para tus pacientes', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTrackingPanelCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.teal, Colors.green]),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.sync, color: Colors.white, size: 36),
          SizedBox(height: 10),
          Text('🔄 Panel de Seguimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text('Monitorea progreso y ajustes en tiempo real', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}