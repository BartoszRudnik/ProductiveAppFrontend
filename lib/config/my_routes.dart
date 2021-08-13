import 'package:productive_app/screen/collaborator_profile_tabs.dart';
import 'package:productive_app/screen/collaborators_screen.dart';
import 'package:productive_app/screen/completed_screen.dart';
import 'package:productive_app/screen/entry_screen.dart';
import 'package:productive_app/screen/filters_screen.dart';
import 'package:productive_app/screen/locations_screen.dart';
import 'package:productive_app/screen/login_screen.dart';
import 'package:productive_app/screen/main_screen.dart';
import 'package:productive_app/screen/new_password_screen.dart';
import 'package:productive_app/screen/related_task_info_screen.dart';
import 'package:productive_app/screen/reset_password_screen.dart';
import 'package:productive_app/screen/settings_tabs_screen.dart';
import 'package:productive_app/screen/tabs_screen.dart';
import 'package:productive_app/screen/tags_screen.dart';
import 'package:productive_app/screen/task_details_screen.dart';
import 'package:productive_app/screen/task_map.dart';
import 'package:productive_app/screen/trash_screen.dart';
import 'package:productive_app/widget/image_viewer.dart';
import 'package:productive_app/widget/pdf_viewer.dart';

class MyRoutes {
  static final routes = {
    MainScreen.routeName: (ctx) => MainScreen(),
    TabsScreen.routeName: (ctx) => TabsScreen(),
    LoginScreen.routeName: (ctx) => LoginScreen(),
    EntryScreen.routeName: (ctx) => EntryScreen(),
    ResetPassword.routeName: (ctx) => ResetPassword(),
    TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
    NewPassword.routeName: (ctx) => NewPassword(),
    TagsScreen.routeName: (ctx) => TagsScreen(),
    CompletedScreen.routeName: (ctx) => CompletedScreen(),
    TrashScreen.routeName: (ctx) => TrashScreen(),
    CollaboratorsScreen.routeName: (ctx) => CollaboratorsScreen(),
    SettingsTabsScreen.routeName: (ctx) => SettingsTabsScreen(),
    FiltersScreen.routeName: (ctx) => FiltersScreen(),
    RelatedTaskInfoScreen.routeName: (ctx) => RelatedTaskInfoScreen(),
    LocationsScreen.routeName: (ctx) => LocationsScreen(),
    TaskMap.routeName: (ctx) => TaskMap(),
    CollaboratorProfileTabs.routeName: (ctx) => CollaboratorProfileTabs(),
    PDFViewer.routeName: (ctx) => PDFViewer(),
    ImageViewer.routeName: (ctx) => ImageViewer(),
  };
}
