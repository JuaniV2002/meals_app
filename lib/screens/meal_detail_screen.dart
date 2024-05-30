import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  final Function toggleFavorite;
  final Function isFavorite;
  const MealDetailScreen(this.toggleFavorite, this.isFavorite, {super.key});

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Ingredients',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 116, 209, 255),
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      width: 350,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final mealId = routeArgs['id'];
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMeal.title),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween(
                    begin: 0.5,
                    end: 1.0,
                  ).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavorite(mealId)
                    ? CupertinoIcons.star_fill
                    : CupertinoIcons.star,
                key: ValueKey(isFavorite(mealId)),
              ),
            ),
            onPressed: () => toggleFavorite(mealId),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: selectedMeal.id,
                child: Image.network(
                  selectedMeal.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            buildSectionTitle(context, 'Ingredients'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Text(selectedMeal.ingredients[index]),
                  ),
                ),
                itemCount: selectedMeal.ingredients.length,
              ),
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text('# ${(index + 1)}'),
                      ),
                      title: Text(
                        selectedMeal.steps[index],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                itemCount: selectedMeal.steps.length,
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
