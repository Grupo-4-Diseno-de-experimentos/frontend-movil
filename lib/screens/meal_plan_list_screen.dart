import 'package:flutter/material.dart';
import 'package:trabajoexp/model/meal_plan_model.dart';
import '../../services/meal_plan_service.dart';
import 'package:trabajoexp/screens/create_meal_plan_screen.dart';
import 'package:trabajoexp/widgets/app_side_bar_widget.dart';
import 'package:trabajoexp/screens/meal_plan_detail_screen.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> with SingleTickerProviderStateMixin {
  final MealPlanService _service = MealPlanService();
  List<MealPlan> _mealPlans = [];
  String? _selectedCategory;
  String? _selectedGoal;
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadMealPlans();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMealPlans();
    });
  }

  Future<void> _loadMealPlans() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<MealPlan> plans;
      if (_tabController.index == 0) {
        plans = await _service.getAllMealPlans();
      } else {
        plans = await _service.getAllMealPlans(category: _selectedCategory, goal: _selectedGoal);
      }

      setState(() {
        _mealPlans = plans;
      });
    } catch (e) {
      print("Error al cargar planes: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildDropdowns() {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text("Categoría"),
                isExpanded: true,
                underline: const SizedBox(),
                items: ['Hiperproteico', 'Hipocalórico', 'Vegetariano']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                  _loadMealPlans();
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: _selectedGoal,
                hint: const Text("Objetivo"),
                isExpanded: true,
                underline: const SizedBox(),
                items: ['Perder Peso', 'Mantener', 'Ganar Masa']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGoal = value;
                  });
                  _loadMealPlans();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealPlanCard(MealPlan plan) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${plan.category} • ${plan.goal}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${plan.caloriesPerDay} cal', style: const TextStyle(fontWeight: FontWeight.bold)),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealPlanDetailScreen(planId: plan.id!),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planes de Comida"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Mis Planes"),
            Tab(text: "Todos los Planes"),
          ],
          onTap: (index) => _loadMealPlans(),
        ),
      ),
      drawer: const AppSidebar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Color(0xFFE3F2FD)]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildDropdowns(),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _mealPlans.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("No se encontraron planes."),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _loadMealPlans,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Recargar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.blue.shade700,
                        ),
                      )
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _mealPlans.length,
                  itemBuilder: (_, index) => _buildMealPlanCard(_mealPlans[index]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateMealPlanScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Nuevo Plan"),
        backgroundColor: Colors.teal.shade300,
      ),
    );
  }
}