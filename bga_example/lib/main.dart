import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(SplittermondHeroApp());
}

class SplittermondHeroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splittermond Helden Generator',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HeroGeneratorScreen(),
    );
  }
}

class Hero {
  String name;
  String species;
  String culture;
  String profession;
  int age;
  String appearance;
  
  // Attribute values (Splittermond uses 8 core attributes)
  Map<String, int> attributes;
  Map<String, int> skills;
  Map<String, String> advantages;
  Map<String, String> disadvantages;
  List<String> equipment;
  String background;
  
  int healthPoints;
  int focusPoints;
  int defenseValue;
  int initiativeValue;
  int speed;
  
  Hero({
    this.name = '',
    this.species = 'Mensch',
    this.culture = 'Selemer',
    this.profession = 'Abenteurer',
    this.age = 20,
    this.appearance = '',
    Map<String, int>? attributes,
    Map<String, int>? skills,
    Map<String, String>? advantages,
    Map<String, String>? disadvantages,
    List<String>? equipment,
    this.background = '',
    this.healthPoints = 30,
    this.focusPoints = 20,
    this.defenseValue = 12,
    this.initiativeValue = 10,
    this.speed = 8,
  }) : 
    attributes = attributes ?? {
      'Ausstrahlung': 10,
      'Beweglichkeit': 10,
      'Intuition': 10,
      'Konstitution': 10,
      'Mystik': 10,
      'Stärke': 10,
      'Verstand': 10,
      'Willenskraft': 10,
    },
    skills = skills ?? {
      'Akrobatik': 0,
      'Alchemie': 0,
      'Anführen': 0,
      'Arkane Kunde': 0,
      'Athletik': 0,
      'Aufmerksamkeit': 0,
      'Darbietung': 0,
      'Diplomatie': 0,
      'Einschüchtern': 0,
      'Empathie': 0,
      'Entschlossenheit': 0,
      'Fingerfertigkeit': 0,
      'Geschichtskunde': 0,
      'Handwerk': 0,
      'Heilkunde': 0,
      'Jagdkunst': 0,
      'Kampf': 0,
      'Länderkunde': 0,
      'Lügen': 0,
      'Naturkunde': 0,
      'Redegewandtheit': 0,
      'Reiten': 0,
      'Schleichen': 0,
      'Schwimmen': 0,
      'Seefahrt': 0,
      'Straßenkunde': 0,
      'Überleben': 0,
      'Wachsamkeit': 0,
      'Zähigkeit': 0,
    },
    advantages = advantages ?? {},
    disadvantages = disadvantages ?? {},
    equipment = equipment ?? [];
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'species': species,
      'culture': culture,
      'profession': profession,
      'age': age,
      'appearance': appearance,
      'attributes': attributes,
      'skills': skills,
      'advantages': advantages,
      'disadvantages': disadvantages,
      'equipment': equipment,
      'background': background,
      'healthPoints': healthPoints,
      'focusPoints': focusPoints,
      'defenseValue': defenseValue,
      'initiativeValue': initiativeValue,
      'speed': speed,
    };
  }
  
  factory Hero.fromJson(Map<String, dynamic> json) {
    return Hero(
      name: json['name'] ?? '',
      species: json['species'] ?? 'Mensch',
      culture: json['culture'] ?? 'Selemer',
      profession: json['profession'] ?? 'Abenteurer',
      age: json['age'] ?? 20,
      appearance: json['appearance'] ?? '',
      attributes: Map<String, int>.from(json['attributes'] ?? {}),
      skills: Map<String, int>.from(json['skills'] ?? {}),
      advantages: Map<String, String>.from(json['advantages'] ?? {}),
      disadvantages: Map<String, String>.from(json['disadvantages'] ?? {}),
      equipment: List<String>.from(json['equipment'] ?? []),
      background: json['background'] ?? '',
      healthPoints: json['healthPoints'] ?? 30,
      focusPoints: json['focusPoints'] ?? 20,
      defenseValue: json['defenseValue'] ?? 12,
      initiativeValue: json['initiativeValue'] ?? 10,
      speed: json['speed'] ?? 8,
    );
  }
}

class HeroGeneratorScreen extends StatefulWidget {
  @override
  _HeroGeneratorScreenState createState() => _HeroGeneratorScreenState();
}

class _HeroGeneratorScreenState extends State<HeroGeneratorScreen> with SingleTickerProviderStateMixin {
  Hero currentHero = Hero();
  late TabController _tabController;
  List<String> savedHeroes = [];
  
  final List<String> species = [
    'Mensch', 'Alb', 'Gnom', 'Varg', 'Zwerg', 'Dragorim'
  ];
  
  final List<String> cultures = [
    'Selemer', 'Kurnalem', 'Zerzanisch', 'Tulamidisch', 'Norbardisch', 
    'Архайsch', 'Fjarningisch', 'Kormasch'
  ];
  
  final List<String> professions = [
    'Abenteurer', 'Gelehrter', 'Handwerker', 'Kämpfer', 'Kundschafter', 
    'Magier', 'Sozial', 'Wildnisläufer'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadSavedHeroes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedHeroes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final heroesDir = Directory('${directory.path}/heroes');
      
      if (await heroesDir.exists()) {
        final files = heroesDir.listSync()
            .where((file) => file.path.endsWith('.json'))
            .map((file) => file.path.split('/').last.replaceAll('.json', ''))
            .toList();
        
        setState(() {
          savedHeroes = files;
        });
      }
    } catch (e) {
      print('Error loading saved heroes: $e');
    }
  }

  Future<void> _saveHero() async {
    if (currentHero.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte geben Sie einen Namen für den Helden ein')),
      );
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final heroesDir = Directory('${directory.path}/heroes');
      
      if (!await heroesDir.exists()) {
        await heroesDir.create(recursive: true);
      }
      
      final file = File('${heroesDir.path}/${currentHero.name}.json');
      await file.writeAsString(jsonEncode(currentHero.toJson()));
      
      await _loadSavedHeroes();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Held ${currentHero.name} gespeichert')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern: $e')),
      );
    }
  }

  Future<void> _loadHero(String heroName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/heroes/$heroName.json');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final heroData = jsonDecode(jsonString);
        
        setState(() {
          currentHero = Hero.fromJson(heroData);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Held $heroName geladen')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden: $e')),
      );
    }
  }

  Future<void> _deleteHero(String heroName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/heroes/$heroName.json');
      
      if (await file.exists()) {
        await file.delete();
        await _loadSavedHeroes();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Held $heroName gelöscht')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen: $e')),
      );
    }
  }

  void _newHero() {
    setState(() {
      currentHero = Hero();
    });
  }

  Future<void> _printHero() async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Header(
                level: 0,
                child: pw.Text(
                  'SPLITTERMOND HELDENBOGEN',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              
              // Basic Info
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Name: ${currentHero.name}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Text('Spezies: ${currentHero.species}'),
                        pw.Text('Kultur: ${currentHero.culture}'),
                        pw.Text('Profession: ${currentHero.profession}'),
                        pw.Text('Alter: ${currentHero.age}'),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Lebenspunkte: ${currentHero.healthPoints}'),
                        pw.Text('Fokuspunkte: ${currentHero.focusPoints}'),
                        pw.Text('Verteidigung: ${currentHero.defenseValue}'),
                        pw.Text('Initiative: ${currentHero.initiativeValue}'),
                        pw.Text('Geschwindigkeit: ${currentHero.speed}'),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              
              // Attributes
              pw.Header(level: 1, child: pw.Text('ATTRIBUTE')),
              pw.GridView(
                crossAxisCount: 4,
                children: currentHero.attributes.entries.map((attr) =>
                  pw.Container(
                    padding: pw.EdgeInsets.all(4),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text('${attr.key}: ${attr.value}'),
                  )
                ).toList(),
              ),
              pw.SizedBox(height: 15),
              
              // Skills
              pw.Header(level: 1, child: pw.Text('FERTIGKEITEN')),
              pw.GridView(
                crossAxisCount: 3,
                children: currentHero.skills.entries.where((skill) => skill.value > 0).map((skill) =>
                  pw.Container(
                    padding: pw.EdgeInsets.all(4),
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Text('${skill.key}: ${skill.value}'),
                  )
                ).toList(),
              ),
              pw.SizedBox(height: 15),
              
              // Equipment
              if (currentHero.equipment.isNotEmpty) ...[
                pw.Header(level: 1, child: pw.Text('AUSRÜSTUNG')),
                pw.Bullet(text: currentHero.equipment.join(', ')),
                pw.SizedBox(height: 15),
              ],
              
              // Background
              if (currentHero.background.isNotEmpty) ...[
                pw.Header(level: 1, child: pw.Text('HINTERGRUND')),
                pw.Text(currentHero.background),
                pw.SizedBox(height: 15),
              ],
              
              // Advantages
              if (currentHero.advantages.isNotEmpty) ...[
                pw.Header(level: 1, child: pw.Text('STÄRKEN')),
                ...currentHero.advantages.entries.map((adv) =>
                  pw.Bullet(text: '${adv.key}: ${adv.value}')
                ),
                pw.SizedBox(height: 15),
              ],
              
              // Disadvantages
              if (currentHero.disadvantages.isNotEmpty) ...[
                pw.Header(level: 1, child: pw.Text('SCHWÄCHEN')),
                ...currentHero.disadvantages.entries.map((dis) =>
                  pw.Bullet(text: '${dis.key}: ${dis.value}')
                ),
              ],
            ],
          );
        },
      ),
    );
    
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splittermond Helden Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveHero,
            tooltip: 'Held speichern',
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printHero,
            tooltip: 'Held drucken',
          ),
          PopupMenuButton<String>(
            onSelected: (String heroName) {
              _loadHero(heroName);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'new',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Neuer Held'),
                  onTap: () {
                    Navigator.pop(context);
                    _newHero();
                  },
                ),
              ),
              PopupMenuDivider(),
              ...savedHeroes.map((heroName) => PopupMenuItem<String>(
                value: heroName,
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(heroName),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteHero(heroName);
                    },
                  ),
                ),
              )).toList(),
            ],
            child: Icon(Icons.folder_open),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Grunddaten'),
            Tab(text: 'Attribute'),
            Tab(text: 'Fertigkeiten'),
            Tab(text: 'Kampf & Ausrüstung'),
            Tab(text: 'Hintergrund'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicInfoTab(),
          _buildAttributesTab(),
          _buildSkillsTab(),
          _buildCombatEquipmentTab(),
          _buildBackgroundTab(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: currentHero.name,
                    decoration: InputDecoration(
                      labelText: 'Name des Helden',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        currentHero.name = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: currentHero.species,
                          decoration: InputDecoration(
                            labelText: 'Spezies',
                            border: OutlineInputBorder(),
                          ),
                          items: species.map((String species) {
                            return DropdownMenuItem<String>(
                              value: species,
                              child: Text(species),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              currentHero.species = newValue!;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: currentHero.culture,
                          decoration: InputDecoration(
                            labelText: 'Kultur',
                            border: OutlineInputBorder(),
                          ),
                          items: cultures.map((String culture) {
                            return DropdownMenuItem<String>(
                              value: culture,
                              child: Text(culture),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              currentHero.culture = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: currentHero.profession,
                          decoration: InputDecoration(
                            labelText: 'Profession',
                            border: OutlineInputBorder(),
                          ),
                          items: professions.map((String profession) {
                            return DropdownMenuItem<String>(
                              value: profession,
                              child: Text(profession),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              currentHero.profession = newValue!;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: currentHero.age.toString(),
                          decoration: InputDecoration(
                            labelText: 'Alter',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              currentHero.age = int.tryParse(value) ?? 20;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: currentHero.appearance,
                    decoration: InputDecoration(
                      labelText: 'Aussehen',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() {
                        currentHero.appearance = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Attribute (8-18)',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: currentHero.attributes.length,
            itemBuilder: (context, index) {
              String attributeName = currentHero.attributes.keys.elementAt(index);
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          attributeName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: currentHero.attributes[attributeName]!.toDouble(),
                          min: 6,
                          max: 18,
                          divisions: 12,
                          label: currentHero.attributes[attributeName].toString(),
                          onChanged: (double value) {
                            setState(() {
                              currentHero.attributes[attributeName] = value.round();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 40,
                        child: Text(
                          currentHero.attributes[attributeName].toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Fertigkeiten (0-20)',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: currentHero.skills.length,
            itemBuilder: (context, index) {
              String skillName = currentHero.skills.keys.elementAt(index);
              return Card(
                child: ListTile(
                  title: Text(skillName),
                  trailing: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Slider(
                            value: currentHero.skills[skillName]!.toDouble(),
                            min: 0,
                            max: 20,
                            divisions: 20,
                            label: currentHero.skills[skillName].toString(),
                            onChanged: (double value) {
                              setState(() {
                                currentHero.skills[skillName] = value.round();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 30,
                          child: Text(
                            currentHero.skills[skillName].toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCombatEquipmentTab() {
    final TextEditingController equipmentController = TextEditingController();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combat Values
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kampfwerte',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: currentHero.healthPoints.toString(),
                          decoration: InputDecoration(
                            labelText: 'Lebenspunkte',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              currentHero.healthPoints = int.tryParse(value) ?? 30;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: currentHero.focusPoints.toString(),
                          decoration: InputDecoration(
                            labelText: 'Fokuspunkte',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              currentHero.focusPoints = int.tryParse(value) ?? 20;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: currentHero.defenseValue.toString(),
                          decoration: InputDecoration(
                            labelText: 'Verteidigung',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              currentHero.defenseValue = int.tryParse(value) ?? 12;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: currentHero.initiativeValue.toString(),
                          decoration: InputDecoration(
                            labelText: 'Initiative',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              currentHero.initiativeValue = int.tryParse(value) ?? 10;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: currentHero.speed.toString(),
                          decoration: InputDecoration(
                            labelText: 'Geschwindigkeit',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              currentHero.speed = int.tryParse(value) ?? 8;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Equipment
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ausrüstung',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: equipmentController,
                          decoration: InputDecoration(
                            labelText: 'Neuen Gegenstand hinzufügen',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (equipmentController.text.isNotEmpty) {
                            setState(() {
                              currentHero.equipment.add(equipmentController.text);
                              equipmentController.clear();
                            });
                          }
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (currentHero.equipment.isNotEmpty)
                    Column(
                      children: currentHero.equipment.asMap().entries.map((entry) {
                        int index = entry.key;
                        String item = entry.value;
                        return ListTile(
                          title: Text(item),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                currentHero.equipment.removeAt(index);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundTab() {
    final TextEditingController advantageController = TextEditingController();
    final TextEditingController advantageDescController = TextEditingController();
    final TextEditingController disadvantageController = TextEditingController();
    final TextEditingController disadvantageDescController = TextEditingController();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Background
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hintergrund',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: currentHero.background,
                    decoration: InputDecoration(
                      labelText: 'Hintergrundgeschichte',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    onChanged: (value) {
                      setState(() {
                        currentHero.background = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Advantages
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stärken',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: advantageController,
                          decoration: InputDecoration(
                            labelText: 'Stärke',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: advantageDescController,
                          decoration: InputDecoration(
                            labelText: 'Beschreibung',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (advantageController.text.isNotEmpty) {
                            setState(() {
                              currentHero.advantages[advantageController.text] = 
                                  advantageDescController.text;
                              advantageController.clear();
                              advantageDescController.clear();
                            });
                          }
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (currentHero.advantages.isNotEmpty)
                    Column(
                      children: currentHero.advantages.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          subtitle: Text(entry.value),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                currentHero.advantages.remove(entry.key);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Disadvantages
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schwächen',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: disadvantageController,
                          decoration: InputDecoration(
                            labelText: 'Schwäche',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: disadvantageDescController,
                          decoration: InputDecoration(
                            labelText: 'Beschreibung',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (disadvantageController.text.isNotEmpty) {
                            setState(() {
                              currentHero.disadvantages[disadvantageController.text] = 
                                  disadvantageDescController.text;
                              disadvantageController.clear();
                              disadvantageDescController.clear();
                            });
                          }
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (currentHero.disadvantages.isNotEmpty)
                    Column(
                      children: currentHero.disadvantages.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          subtitle: Text(entry.value),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                currentHero.disadvantages.remove(entry.key);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}