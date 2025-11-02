import 'package:flutter/material.dart';

void main() {
  runApp(Week10AdvancedApp());
}

class Week10AdvancedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 10 - Scrolling Lists & Effects',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ScrollDemoScreen(),
    );
  }
}

class ScrollDemoScreen extends StatefulWidget {
  const ScrollDemoScreen({super.key});

  @override
  State<ScrollDemoScreen> createState() => _ScrollDemoScreenState();
}

class _ScrollDemoScreenState extends State<ScrollDemoScreen> {
  final List<String> fruits = [
    "Apple", "Banana", "Mango", "Orange", "Grapes",
    "Pineapple", "Watermelon", "Papaya", "Kiwi", "Strawberry"
  ];

  final List<String> vegetables = [
    "Carrot", "Potato", "Tomato", "Onion", "Cabbage",
    "Peas", "Broccoli", "Spinach", "Cauliflower", "Corn"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar inside CustomScrollView
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text("Scrolling Lists & Effects"),
              centerTitle: true,
            ),
          ),

          // ListView style - Fruits list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[(index % 9 + 1) * 100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          fruits[index][0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      title: Text(
                        fruits[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onTap: () {
                        setState(() {
                          fruits.shuffle(); // effect
                        });
                      },
                    ),
                  ),
                );
              },
              childCount: fruits.length,
            ),
          ),

          // GridView style - Vegetables grid
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.3,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade700,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        vegetables[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
                childCount: vegetables.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
