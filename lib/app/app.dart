import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_map_dynamic_key/google_map_dynamic_key.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../core/setups/bottom_sheet_setup.dart';
import 'app_setup_locator.dart';

class App {
  App._();

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
    await setupDependencies();
    await setupBottomSheetUi();
    await initGoogleMapKey();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getTemporaryDirectory()).path,
      ),
    );
  }

  static Future<void> initGoogleMapKey() async => await GoogleMapDynamicKey()
      .setGoogleApiKey(dotenv.env["GOOGLE_MAP_KEY_ANDROID"]!)
      .then((value) => print("Map key is set"))
      .catchError((error) => print("Failed to set map key"));
}
