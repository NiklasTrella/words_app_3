// Tento soubor obsahuje "cesty", na které lze odkazovat.

import 'package:words_app_3/backend/system/models.dart';

import 'package:words_app_3/frontend/editors/course_editor.dart';
import 'package:words_app_3/frontend/main/a_decision.dart';

// Odkazy na "cesty"
var appRoutes = {
  '/': (context) => const DecisionScreen(),
  '/create_course': (context) => CourseEditorScreen(CourseModel(null, null, null), null),
};