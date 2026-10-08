import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Level 1 Imports
import 'l1_q1_doc_dir.dart';
import 'l1_q2_write_file.dart';
import 'l1_q3_read_file.dart';
import 'l1_q4_file_exists.dart';
import 'l1_q5_delete_file.dart';
import 'l1_q6_pref_string.dart';
import 'l1_q7_pref_counter.dart';
import 'l1_q8_memory_cache.dart';
import 'l1_q9_map_to_json.dart';
import 'l1_q10_json_to_map.dart';

// Level 2 Imports
import 'l2_q1_file_notes.dart';
import 'l2_q2_student_json.dart';
import 'l2_q3_pref_string_list.dart';
import 'l2_q4_cache_first_loader.dart';
import 'l2_q5_clear_cache.dart';
import 'l2_q6_theme_settings.dart';
import 'l2_q7_append_file.dart';
import 'l2_q8_student_file_list.dart';
import 'l2_q9_copy_image.dart';
import 'l2_q10_offline_queue.dart';

// Level 3 Imports
import 'l3_q1_notes_json_crud.dart';
import 'l3_q2_image_disk_cache.dart';
import 'l3_q3_offline_todo_hive.dart';
import 'l3_q4_generic_repository.dart';
import 'l3_q5_expiring_cache.dart';
import 'l3_q6_nested_json_model.dart';
import 'l3_q7_auto_bg_sync.dart';
import 'l3_q8_file_logger.dart';
import 'l3_q9_api_fallback_cache.dart';
import 'l3_q10_offline_data_pipeline.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('todos_box');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Data & Caching Questions',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class QuestionModel {
  final String id;
  final String title;
  final Widget screen;

  QuestionModel({required this.id, required this.title, required this.screen});
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static final List<QuestionModel> level1Questions = [
    QuestionModel(id: 'Q1', title: '1. Print getApplicationDocumentsDirectory() path', screen: const L1Q1DocDirScreen()),
    QuestionModel(id: 'Q2', title: '2. Create file & writeAsString("Hello Flutter")', screen: const L1Q2WriteFileScreen()),
    QuestionModel(id: 'Q3', title: '3. Read file with readAsString() & show in Text', screen: const L1Q3ReadFileScreen()),
    QuestionModel(id: 'Q4', title: '4. Check file exists() before reading', screen: const L1Q4FileExistsScreen()),
    QuestionModel(id: 'Q5', title: '5. Delete file with file.delete() & show alert', screen: const L1Q5DeleteFileScreen()),
    QuestionModel(id: 'Q6', title: '6. Store & retrieve String in SharedPreferences', screen: const L1Q6PrefStringScreen()),
    QuestionModel(id: 'Q7', title: '7. Store & increment integer counter in SharedPreferences', screen: const L1Q7PrefCounterScreen()),
    QuestionModel(id: 'Q8', title: '8. In-memory cache using Map for API data', screen: const L1Q8MemoryCacheScreen()),
    QuestionModel(id: 'Q9', title: '9. Convert Map into JSON string using jsonEncode()', screen: const L1Q9MapToJsonScreen()),
    QuestionModel(id: 'Q10', title: '10. Convert JSON string back to Map using jsonDecode()', screen: const L1Q10JsonToMapScreen()),
  ];

  static final List<QuestionModel> level2Questions = [
    QuestionModel(id: 'Q1', title: '1. Simple Notes app saving to/loading from local file', screen: const L2Q1FileNotesScreen()),
    QuestionModel(id: 'Q2', title: '2. Student class with toJson() & fromJson() methods', screen: const L2Q2StudentJsonScreen()),
    QuestionModel(id: 'Q3', title: '3. Save String List in SharedPreferences & display in ListView', screen: const L2Q3PrefStringListScreen()),
    QuestionModel(id: 'Q4', title: '4. Cache-first loader checking memory cache before API', screen: const L2Q4CacheFirstLoaderScreen()),
    QuestionModel(id: 'Q5', title: '5. Clear Cache button emptying cache Map', screen: const L2Q5ClearCacheScreen()),
    QuestionModel(id: 'Q6', title: '6. Theme settings (dark/light) saved in SharedPreferences', screen: const L2Q6ThemeSettingsScreen(isDarkMode: false, onThemeChanged: _emptyFn)),
    QuestionModel(id: 'Q7', title: '7. Append text to file using FileMode.append', screen: const L2Q7AppendFileScreen()),
    QuestionModel(id: 'Q8', title: '8. Store Student objects list as JSON in file', screen: const L2Q8StudentFileListScreen()),
    QuestionModel(id: 'Q9', title: '9. Copy gallery image to app documents directory', screen: const L2Q9CopyImageScreen()),
    QuestionModel(id: 'Q10', title: '10. Offline queue for unsent form data in SharedPreferences', screen: const L2Q10OfflineQueueScreen()),
  ];

  static void _emptyFn(bool val) {}

  static final List<QuestionModel> level3Questions = [
    QuestionModel(id: 'Q1', title: '1. Complete Notes App with Full JSON File CRUD', screen: const L3Q1NotesJsonCrudScreen()),
    QuestionModel(id: 'Q2', title: '2. Image Caching Layer on Disk', screen: const L3Q2ImageDiskCacheScreen()),
    QuestionModel(id: 'Q3', title: '3. Offline-first To-Do App with Hive & Connectivity Sync', screen: const L3Q3OfflineTodoHiveScreen()),
    QuestionModel(id: 'Q4', title: '4. Generic Repository Abstracting Local & Remote Sources', screen: const L3Q4GenericRepositoryScreen()),
    QuestionModel(id: 'Q5', title: '5. Expiring Caching System (5-Minute Expiry)', screen: const L3Q5ExpiringCacheScreen()),
    QuestionModel(id: 'Q6', title: '6. Nested JSON Model (Student with List<Mark>)', screen: const L3Q6NestedJsonModelScreen()),
    QuestionModel(id: 'Q7', title: '7. Auto Background Sync on Connectivity Recovery', screen: const L3Q7AutoBgSyncScreen()),
    QuestionModel(id: 'Q8', title: '8. File-Based Logger with Export/Share', screen: const L3Q8FileLoggerScreen()),
    QuestionModel(id: 'Q9', title: '9. Public API Fetch with Automatic Local Cache Fallback', screen: const L3Q9ApiFallbackCacheScreen()),
    QuestionModel(id: 'Q10', title: '10. Complete End-to-End Offline Data Pipeline', screen: const L3Q10OfflineDataPipelineScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Data & Persistence Solutions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Level 1 (Easy)'),
              Tab(text: 'Level 2 (Moderate)'),
              Tab(text: 'Level 3 (Hard)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildQuestionList(context, level1Questions, Colors.green.shade50),
            _buildQuestionList(context, level2Questions, Colors.blue.shade50),
            _buildQuestionList(context, level3Questions, Colors.purple.shade50),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionList(BuildContext context, List<QuestionModel> questions, Color cardBg) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        return Card(
          color: cardBg,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text(q.id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            title: Text(q.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => q.screen),
              );
            },
          ),
        );
      },
    );
  }
}
