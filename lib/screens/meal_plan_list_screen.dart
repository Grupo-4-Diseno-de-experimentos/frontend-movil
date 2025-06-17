import 'package:flutter/material.dart';
import 'package:trabajoexp/model/meal_plan_model.dart';
import '../../services/meal_plan_service.dart';

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
      if (_tabController.indexIsChanging == false) {
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
        plans = await _service.getAllMealPlans(
          category: _selectedCategory,
          goal: _selectedGoal,
        );
      }

      setState(() {
        _mealPlans = plans;
      });
    } catch (e) {
      print("Error al cargar planes: $e");
      // podrías mostrar un snackbar o alert
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
          child: DropdownButton<String>(
            value: _selectedCategory,
            hint: const Text("Categoría"),
            isExpanded: true,
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
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButton<String>(
            value: _selectedGoal,
            hint: const Text("Objetivo"),
            isExpanded: true,
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
      ],
    );
  }

  Widget _buildMealPlanCard(MealPlan plan) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(plan.name),
        subtitle: Text('${plan.category} • ${plan.goal}'),
        trailing: Text('${plan.caloriesPerDay} cal'),
        onTap: () {
          // Navegar al detalle del plan
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Planes de Comida"), bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: "Mis Planes"),
          Tab(text: "Todos los Planes"),
        ],
        onTap: (index) {
          // Aquí podrías cambiar el endpoint si "Mis Planes" es distinto
          _loadMealPlans();
        },
      )),
      body: Padding(
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
    );
  }
}