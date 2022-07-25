import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:frontend/games/game5/robert_colors.dart';
import 'package:frontend/games/game5/session_manager.dart';
import 'robert_slapper.dart';
import 'package:frontend/utils/constants.dart' as Constants;

const pauseMenu = 'PauseMenu';
var robertSlapper = RobertSlapper();

class GameFiveMain extends StatefulWidget {
  GameFiveMain({
    Key? key,
    required this.robertSlapper,
  }) : super(key: key);
  final RobertSlapper robertSlapper;
  @override
  State<GameFiveMain> createState() => _GameFiveMainState();
}

class _GameFiveMainState extends State<GameFiveMain> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Navigator.of(context).pop(false);
        return true;
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 400,
          height: 340,
          decoration: BoxDecoration(
            color: RobertColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Salta, salta',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  )),
              if (robertSlapper.sessionManager.score > 0)
                Text(robertSlapper.sessionManager.scoreComponent.text,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    )),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                  primary: Constants.BTN_GREEN,
                ),
                onPressed: () {
                  robertSlapper.overlays.remove(pauseMenu);
                  robertSlapper.start();

                  robertSlapper.sessionManager.reset();
                },
                child: Text('Jugar'),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                  primary: Constants.BTN_RED,
                ),
                onPressed: () {
                  robertSlapper.overlays.remove(pauseMenu);
                  robertSlapper.start();

                  robertSlapper.sessionManager.reset();
                  setState(() {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Salir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameFiveMainExecute extends StatefulWidget {
  GameFiveMainExecute({Key? key}) : super(key: key);

  @override
  State<GameFiveMainExecute> createState() => _GameFiveMainExecuteState();
}

class _GameFiveMainExecuteState extends State<GameFiveMainExecute> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    return Scaffold(
      /*appBar: MediaQuery.of(context).orientation == Orientation.landscape
            ? null // show nothing in lanscape mode
            : AppBar(
                title: const Text('Kindacode.com'),
              ),*/
      body: GameWidget<RobertSlapper>(
        game: robertSlapper,
        initialActiveOverlays: [
          pauseMenu,
        ],
        overlayBuilderMap: {
          'PauseMenu': (context, game) {
            return GameFiveMain(robertSlapper: game);
          },
        },
      ),
    );
    ;
  }
}
