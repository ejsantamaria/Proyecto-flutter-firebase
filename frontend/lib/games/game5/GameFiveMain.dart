import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:frontend/games/game5/robert_colors.dart';
import 'robert_slapper.dart';

const pauseMenu = 'PauseMenu';
final robertSlapper = RobertSlapper();
Future<void> execute() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  GameWidget<RobertSlapper>(
      game: robertSlapper,
      initialActiveOverlays: [
        pauseMenu,
      ],
      overlayBuilderMap: {
        'PauseMenu': (context, game) {
          return GameFiveMain(robertSlapper: game);
        },
      },
    );
}

class GameFiveMain extends StatefulWidget {

  GameFiveMain({Key? key, required RobertSlapper robertSlapper}) : super(key: key);

  final RobertSlapper robertSlapper = new RobertSlapper();

  @override
  State<GameFiveMain> createState() => _GameFiveMainState();
}

class _GameFiveMainState extends State<GameFiveMain> {
  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    await Flame.device.setLandscape();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    execute();
    return Center(
      
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
            Text('Robert Slapper',
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
            Image.asset(
              'assets/images/Logo.png',
              height: 180,
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
                primary: RobertColors.primary,
              ),
              onPressed: () {
                robertSlapper.overlays.remove(pauseMenu);
                robertSlapper.start();

                robertSlapper.sessionManager.reset();
              },
              child: Text('Start Game'),
            )
          ],
        ),
      ),
    );
  }
}