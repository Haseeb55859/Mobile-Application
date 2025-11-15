import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lab Work",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 4,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

 
class HomeScreen extends StatelessWidget {
  final List<String> screens = [
    "Cosmic Grid",
    "Floating Widgets",
    "Tech List",
    "Contact Explorer",
    "Scroll Magic",
    "Sliver Universe",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lab Manual Widgets")),
      body: ListView.builder(
        itemCount: screens.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(screens[index]),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.tealAccent),
            onTap: () {
              if (index == 0)
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CosmicGrid()));
              if (index == 1)
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FloatingDemo()));
              if (index == 2)
                Navigator.push(context, MaterialPageRoute(builder: (_) => TechListDemo()));
              if (index == 3)
                Navigator.push(context, MaterialPageRoute(builder: (_) => ContactDemo()));
              if (index == 4)
                Navigator.push(context, MaterialPageRoute(builder: (_) => ScrollMagicDemo()));
              if (index == 5)
                Navigator.push(context, MaterialPageRoute(builder: (_) => SliverUniverseDemo()));
            },
          );
        },
      ),
    );
  }
}

 
class CosmicGrid extends StatelessWidget {
  final List<String> gridItems = [
    "Sun", "Rocket", "Galaxy", "Planet", "Comet", "Star", "Moon", "Asteroid", "Meteor", "Nebula", "Black Hole", "Aurora"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cosmic Grid")),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: gridItems.length,
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.tealAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                gridItems[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class FloatingDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Floating Widgets")),
      body: Center(
        child: Container(
          width: 320,
          height: 220,
          color: Colors.orange[900]?.withOpacity(0.2),
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 30,
                child: Icon(Icons.flight, size: 50, color: Colors.redAccent),
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Launch"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              Positioned(
                top: 80,
                right: 50,
                child: Icon(Icons.cloud, size: 40, color: Colors.white70),
              )
            ],
          ),
        ),
      ),
    );
  }
}

 
class TechListDemo extends StatelessWidget {
  final List<String> techItems = [
    "Flutter", "Dart", "Python", "AI", "Blockchain", "AR/VR", "Quantum", "Robotics", "IoT", "5G"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tech List")),
      body: ListView.builder(
        itemCount: techItems.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(techItems[index], style: TextStyle(fontSize: 18, color: Colors.tealAccent)),
          );
        },
      ),
    );
  }
}

 
class ContactDemo extends StatelessWidget {
  final List<String> contacts =
      List.generate(12, (i) => "Contact ${i + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Explorer")),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.tealAccent,
                child: Text("${index + 1}", style: TextStyle(color: Colors.black))),
            title: Text(contacts[index], style: TextStyle(color: Colors.white)),
            subtitle: Text("Phone: 0300-12${index}45${index}", style: TextStyle(color: Colors.white70)),
            trailing: Icon(Icons.call, color: Colors.tealAccent),
            onTap: () {},
          );
        },
      ),
    );
  }
}

 
class ScrollMagicDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scroll Magic")),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            25,
            (index) => Container(
              margin: EdgeInsets.all(10),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.indigoAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text("Scroll Card ${index + 1}",
                    style: TextStyle(fontSize: 20, color: Colors.tealAccent)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 
class SliverUniverseDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Sliver Universe"),
              background: Container(color: Colors.tealAccent.withOpacity(0.2)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text("Galaxy Item ${index + 1}", style: TextStyle(color: Colors.tealAccent)),
              ),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
