import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:planets/app/cubit/audio_player_cubit.dart';
import 'package:planets/dashboard/dashboard.dart';
import 'package:planets/global/background/background.dart';
import 'package:planets/global/stylized_button.dart';
import 'package:planets/global/stylized_container.dart';
import 'package:planets/global/stylized_text.dart';
import 'package:planets/layout/layout.dart';
import 'package:planets/loading/cubit/assetcache_cubit.dart';
import 'package:planets/loading/widgets/loading.dart';
import 'package:planets/utils/utils.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  void _move(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioPlayerCubit, AudioPlayerState>(
      listener: (context, state) {
        final bool isReady = state is AudioPlayerReady;
        if (isReady) {
          context.read<AssetcacheCubit>().startCache();
        }
      },
      builder: (context, state) {
        final bool isReady = state is AudioPlayerReady;
        final bool isInitialized =
            context.select((AssetcacheCubit cubit) => cubit.state).isDone;

        return Background(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ResponsiveLayoutBuilder(
              small: (_, __) => _LoadingPageSmall(
                isInitialized: isInitialized,
                isReady: isReady,
                onStartPressed: () => _move(context),
              ),
              medium: (_, Widget? child) => child!,
              large: (_, Widget? child) => child!,
              child: (_) => _LoadingPageLarge(
                isInitialized: isInitialized,
                isReady: isReady,
                onStartPressed: () => _move(context),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoadingPageLarge extends StatelessWidget {
  final bool isReady;
  final bool isInitialized;
  final VoidCallback onStartPressed;

  const _LoadingPageLarge({
    Key? key,
    required this.isReady,
    required this.isInitialized,
    required this.onStartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Image.asset('assets/images/planets.png'),
        ),
        Expanded(
          child: _MainBody(
            isLarge: true,
            isInitialized: isInitialized,
            isReady: isReady,
            onPressed: onStartPressed,
          ),
        ),
      ],
    );
  }
}

class _LoadingPageSmall extends StatelessWidget {
  final bool isReady;
  final bool isInitialized;
  final VoidCallback onStartPressed;

  const _LoadingPageSmall({
    Key? key,
    required this.isReady,
    required this.isInitialized,
    required this.onStartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // show asset
          Expanded(
            child: Image.asset('assets/images/planets.png'),
            flex: 5,
          ),

          // show rest body
          Expanded(
            flex: 7,
            child: _MainBody(
              isInitialized: isInitialized,
              isReady: isReady,
              onPressed: onStartPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  final bool isReady;
  final bool isInitialized;
  final bool isLarge;
  final VoidCallback onPressed;

  const _MainBody({
    Key? key,
    this.isLarge = false,
    required this.isInitialized,
    required this.isReady,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // app name
        Column(
          children: [
            StylizedText(
              text: "Planets",
              fontSize: isLarge ? 68.0 : 48.0,
              textColor: Utils.darkenColor(Colors.blue),
              strokeColor: Colors.white,
            ),
            const Gap(4.0),
            Wrap(
              children: [
                Text(
                  'Made with',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    letterSpacing: 1.4,
                    fontSize: isLarge ? 20.0 : 15.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLarge ? 8.0 : 4.0,
                  ),
                  child: Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.redAccent,
                    size: isLarge ? 24.0 : 20.0,
                  ),
                ),
                Text(
                  'Powered by Flutter',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    letterSpacing: 1.4,
                    fontSize: isLarge ? 20.0 : 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),

        Column(
          children: [
            // loading animation
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: !isInitialized
                    ? Text(
                        'Please wait, initializing...',
                        key: const Key('initializing'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.90),
                          fontSize: isLarge ? 28.0 : 22.0,
                          letterSpacing: 1.4,
                        ),
                      )
                    : Text(
                        'Ready when you are, Captain!',
                        key: const Key('ready'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.90),
                          fontSize: isLarge ? 28.0 : 22.0,
                          letterSpacing: 1.4,
                        ),
                      )),

            const Gap(12.0),

            // loading animation
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isReady ? 1.0 : 0.0,
              child: Loading(
                key: ValueKey(isReady),
                tileSize: isLarge ? 60.0 : 40.0,
              ),
            ),
          ],
        ),

        // start button
        StylizedButton(
          onPressed: () {
            if (isReady && isInitialized) {
              onPressed();
            }
          },
          child: StylizedContainer(
            color: isReady && isInitialized ? Colors.greenAccent : Colors.grey,
            child: StylizedText(
              text: 'Start',
              fontSize: isLarge ? 32.0 : 24.0,
            ),
          ),
        ),
      ],
    );
  }
}
