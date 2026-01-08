import 'package:fancy_titles/core/animation_timings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SonicManiaTiming', () {
    group('main durations', () {
      test('slideIn has positive duration', () {
        expect(SonicManiaTiming.slideIn.inMilliseconds, greaterThan(0));
      });

      test('slideOutDelay has positive duration', () {
        expect(SonicManiaTiming.slideOutDelay.inMilliseconds, greaterThan(0));
      });

      test('totalDuration has positive duration', () {
        expect(SonicManiaTiming.totalDuration.inMilliseconds, greaterThan(0));
      });

      test('fadeTransition has positive duration', () {
        expect(SonicManiaTiming.fadeTransition.inMilliseconds, greaterThan(0));
      });
    });

    group('curtain timings', () {
      test('curtainExpandDuration has positive duration', () {
        expect(
          SonicManiaTiming.curtainExpandDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('curtainBlueDelay is zero', () {
        expect(SonicManiaTiming.curtainBlueDelay, Duration.zero);
      });

      test('curtainOrangeDelay is greater than curtainBlueDelay', () {
        expect(
          SonicManiaTiming.curtainOrangeDelay,
          greaterThan(SonicManiaTiming.curtainBlueDelay),
        );
      });

      test('curtainAmberDelay is greater than curtainOrangeDelay', () {
        expect(
          SonicManiaTiming.curtainAmberDelay,
          greaterThan(SonicManiaTiming.curtainOrangeDelay),
        );
      });

      test('curtainGreenDelay is greater than curtainAmberDelay', () {
        expect(
          SonicManiaTiming.curtainGreenDelay,
          greaterThan(SonicManiaTiming.curtainAmberDelay),
        );
      });

      test('curtainYellowDelay is greater than curtainGreenDelay', () {
        expect(
          SonicManiaTiming.curtainYellowDelay,
          greaterThan(SonicManiaTiming.curtainGreenDelay),
        );
      });

      test('curtainBlackDelay is positive', () {
        expect(
          SonicManiaTiming.curtainBlackDelay.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('bounce timings', () {
      test('bounceVerticallyDuration has positive duration', () {
        expect(
          SonicManiaTiming.bounceVerticallyDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('bounceVerticallyDelay has positive duration', () {
        expect(
          SonicManiaTiming.bounceVerticallyDelay.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('timing relationships', () {
      test('totalDuration is greater than slideIn', () {
        expect(
          SonicManiaTiming.totalDuration,
          greaterThan(SonicManiaTiming.slideIn),
        );
      });

      test('slideOutDelay is greater than slideIn', () {
        expect(
          SonicManiaTiming.slideOutDelay,
          greaterThan(SonicManiaTiming.slideIn),
        );
      });

      test('totalDuration is greater than slideOutDelay', () {
        expect(
          SonicManiaTiming.totalDuration,
          greaterThan(SonicManiaTiming.slideOutDelay),
        );
      });
    });

    group('clipped bar timings (OPT-005)', () {
      test('clippedBarInitialDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarInitialDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarDefaultDuration has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarDefaultDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarDefaultDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarDefaultDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarRedDuration has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarRedDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarRedDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarRedDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarOrangeDuration has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarOrangeDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarOrangeDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarOrangeDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarBlueDuration has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarBlueDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarBlueDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarBlueDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarGreenDuration has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarGreenDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedBarGreenDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedBarGreenDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clipped bar delays form a valid sequence', () {
        // Red and orange slide out before blue and green
        expect(
          SonicManiaTiming.clippedBarOrangeDelay,
          lessThan(SonicManiaTiming.clippedBarRedDelay),
        );
        expect(
          SonicManiaTiming.clippedBarRedDelay,
          lessThanOrEqualTo(SonicManiaTiming.clippedBarGreenDelay),
        );
      });
    });

    group('clipped curtain timings (OPT-005)', () {
      test('clippedCurtainDuration has positive duration', () {
        expect(
          SonicManiaTiming.clippedCurtainDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedCurtainInitialDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedCurtainInitialDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedCurtainSlideOutDelay has positive duration', () {
        expect(
          SonicManiaTiming.clippedCurtainSlideOutDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('clippedCurtainSlideOutDelay is greater than initialDelay', () {
        expect(
          SonicManiaTiming.clippedCurtainSlideOutDelay,
          greaterThan(SonicManiaTiming.clippedCurtainInitialDelay),
        );
      });
    });
  });

  group('Persona5Timing', () {
    group('main durations', () {
      test('initialDelay has non-negative duration', () {
        expect(
          Persona5Timing.initialDelay.inMilliseconds,
          greaterThanOrEqualTo(0),
        );
      });

      test('mainDuration has positive duration', () {
        expect(Persona5Timing.mainDuration.inMilliseconds, greaterThan(0));
      });

      test('totalDuration has positive duration', () {
        expect(Persona5Timing.totalDuration.inMilliseconds, greaterThan(0));
      });

      test('textAppearDelay has positive duration', () {
        expect(Persona5Timing.textAppearDelay.inMilliseconds, greaterThan(0));
      });
    });

    group('transitions', () {
      test('fadeTransitionReverse has positive duration', () {
        expect(
          Persona5Timing.fadeTransitionReverse.inMilliseconds,
          greaterThan(0),
        );
      });

      test('circleTransitionDuration has positive duration', () {
        expect(
          Persona5Timing.circleTransitionDuration.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('timing relationships', () {
      test('totalDuration is greater than mainDuration', () {
        expect(
          Persona5Timing.totalDuration,
          greaterThan(Persona5Timing.mainDuration),
        );
      });

      test('mainDuration is greater than textAppearDelay', () {
        expect(
          Persona5Timing.mainDuration,
          greaterThan(Persona5Timing.textAppearDelay),
        );
      });
    });
  });

  group('EvangelionTiming', () {
    group('main durations', () {
      test('textAppearDelay has positive duration', () {
        expect(
          EvangelionTiming.textAppearDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('backgroundFadeTime has positive duration', () {
        expect(
          EvangelionTiming.backgroundFadeTime.inMilliseconds,
          greaterThan(0),
        );
      });

      test('totalDuration has positive duration', () {
        expect(EvangelionTiming.totalDuration.inMilliseconds, greaterThan(0));
      });

      test('fadeTransition has positive duration', () {
        expect(
          EvangelionTiming.fadeTransition.inMilliseconds,
          greaterThan(0),
        );
      });

      test('containerTransition has positive duration', () {
        expect(
          EvangelionTiming.containerTransition.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('spark timings', () {
      test('crossFlashDuration has positive duration', () {
        expect(
          EvangelionTiming.crossFlashDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('sparkDefaultDuration has positive duration', () {
        expect(
          EvangelionTiming.sparkDefaultDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('sparkFirstDelay is zero', () {
        expect(EvangelionTiming.sparkFirstDelay, Duration.zero);
      });

      test('spark delays increase sequentially', () {
        expect(
          EvangelionTiming.sparkSecondDelay,
          greaterThan(EvangelionTiming.sparkFirstDelay),
        );
        expect(
          EvangelionTiming.sparkThirdDelay,
          greaterThan(EvangelionTiming.sparkSecondDelay),
        );
        expect(
          EvangelionTiming.sparkFourthDelay,
          greaterThan(EvangelionTiming.sparkThirdDelay),
        );
        expect(
          EvangelionTiming.sparkFifthDelay,
          greaterThan(EvangelionTiming.sparkFourthDelay),
        );
        expect(
          EvangelionTiming.sparkSixthDelay,
          greaterThan(EvangelionTiming.sparkFifthDelay),
        );
      });
    });

    group('curtain timings', () {
      test('curtainFirstDuration has positive duration', () {
        expect(
          EvangelionTiming.curtainFirstDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('curtainSecondaryDuration has positive duration', () {
        expect(
          EvangelionTiming.curtainSecondaryDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('curtainFirstDelay is zero', () {
        expect(EvangelionTiming.curtainFirstDelay, Duration.zero);
      });

      test('curtain delays increase sequentially', () {
        expect(
          EvangelionTiming.curtainSecondDelay,
          greaterThan(EvangelionTiming.curtainFirstDelay),
        );
        expect(
          EvangelionTiming.curtainThirdDelay,
          greaterThan(EvangelionTiming.curtainSecondDelay),
        );
        expect(
          EvangelionTiming.curtainFourthDelay,
          greaterThan(EvangelionTiming.curtainThirdDelay),
        );
        expect(
          EvangelionTiming.curtainFifthDelay,
          greaterThan(EvangelionTiming.curtainFourthDelay),
        );
        expect(
          EvangelionTiming.curtainSixthDelay,
          greaterThan(EvangelionTiming.curtainFifthDelay),
        );
      });
    });

    group('timing relationships', () {
      test('totalDuration is greater than textAppearDelay', () {
        expect(
          EvangelionTiming.totalDuration,
          greaterThan(EvangelionTiming.textAppearDelay),
        );
      });

      test('totalDuration is greater than backgroundFadeTime', () {
        expect(
          EvangelionTiming.totalDuration,
          greaterThan(EvangelionTiming.backgroundFadeTime),
        );
      });
    });

    group('blur cache timings (OPT-005)', () {
      test('blurCacheDelay has positive duration', () {
        expect(
          EvangelionTiming.blurCacheDelay.inMilliseconds,
          greaterThan(0),
        );
      });

      test('blurCacheDelay equals 16ms (approximately 1 frame at 60fps)', () {
        expect(
          EvangelionTiming.blurCacheDelay,
          equals(const Duration(milliseconds: 16)),
        );
      });
    });
  });

  group('MarioMakerTiming', () {
    group('main durations', () {
      test('defaultTotalDuration has positive duration', () {
        expect(
          MarioMakerTiming.defaultTotalDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('irisOutDuration has positive duration', () {
        expect(
          MarioMakerTiming.irisOutDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('titleEntryDelay has positive duration', () {
        expect(
          MarioMakerTiming.titleEntryDelay.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('bouncing circle', () {
      test('bounceDuration has positive duration', () {
        expect(MarioMakerTiming.bounceDuration.inMilliseconds, greaterThan(0));
      });
    });

    group('expanding circle', () {
      test('expandDelay has positive duration', () {
        expect(MarioMakerTiming.expandDelay.inMilliseconds, greaterThan(0));
      });

      test('expandDuration has positive duration', () {
        expect(MarioMakerTiming.expandDuration.inMilliseconds, greaterThan(0));
      });

      test('expandDelayDefault has positive duration', () {
        expect(
          MarioMakerTiming.expandDelayDefault.inMilliseconds,
          greaterThan(0),
        );
      });

      test('expandDurationDefault has positive duration', () {
        expect(
          MarioMakerTiming.expandDurationDefault.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('sliding title', () {
      test('slideDuration has positive duration', () {
        expect(MarioMakerTiming.slideDuration.inMilliseconds, greaterThan(0));
      });

      test('slideDelayDefault has positive duration', () {
        expect(
          MarioMakerTiming.slideDelayDefault.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('contracting circle', () {
      test('contractDuration has positive duration', () {
        expect(
          MarioMakerTiming.contractDuration.inMilliseconds,
          greaterThan(0),
        );
      });
    });

    group('timing relationships', () {
      test('defaultTotalDuration is greater than bounceDuration', () {
        expect(
          MarioMakerTiming.defaultTotalDuration,
          greaterThan(MarioMakerTiming.bounceDuration),
        );
      });

      test('defaultTotalDuration is greater than expandDuration', () {
        expect(
          MarioMakerTiming.defaultTotalDuration,
          greaterThan(MarioMakerTiming.expandDuration),
        );
      });

      test('slideDelayDefault is greater than titleEntryDelay', () {
        expect(
          MarioMakerTiming.slideDelayDefault,
          greaterThan(MarioMakerTiming.titleEntryDelay),
        );
      });

      test('phases sum fits within totalDuration', () {
        final phasesSum = MarioMakerTiming.bounceDuration +
            MarioMakerTiming.expandDuration +
            MarioMakerTiming.irisOutDuration;

        expect(
          MarioMakerTiming.defaultTotalDuration,
          greaterThanOrEqualTo(phasesSum),
        );
      });
    });

    group('specific values', () {
      test('contractDuration equals 500ms', () {
        expect(
          MarioMakerTiming.contractDuration,
          equals(const Duration(milliseconds: 500)),
        );
      });

      test('expandDelayDefault equals 2 seconds', () {
        expect(
          MarioMakerTiming.expandDelayDefault,
          equals(const Duration(seconds: 2)),
        );
      });

      test('expandDurationDefault equals 1500ms', () {
        expect(
          MarioMakerTiming.expandDurationDefault,
          equals(const Duration(milliseconds: 1500)),
        );
      });

      test('slideDelayDefault equals 3500ms', () {
        expect(
          MarioMakerTiming.slideDelayDefault,
          equals(const Duration(milliseconds: 3500)),
        );
      });

      test('slideDuration equals 500ms', () {
        expect(
          MarioMakerTiming.slideDuration,
          equals(const Duration(milliseconds: 500)),
        );
      });
    });

    group('bouncing circle defaults (OPT-005)', () {
      test('bounceDurationDefault has positive duration', () {
        expect(
          MarioMakerTiming.bounceDurationDefault.inMilliseconds,
          greaterThan(0),
        );
      });

      test('bounceDurationDefault equals 2 seconds', () {
        expect(
          MarioMakerTiming.bounceDurationDefault,
          equals(const Duration(seconds: 2)),
        );
      });

      test('imageScaleOutDuration has positive duration', () {
        expect(
          MarioMakerTiming.imageScaleOutDuration.inMilliseconds,
          greaterThan(0),
        );
      });

      test('imageScaleOutDuration equals 300ms', () {
        expect(
          MarioMakerTiming.imageScaleOutDuration,
          equals(const Duration(milliseconds: 300)),
        );
      });

      test('imageScaleOutDuration is less than bounceDurationDefault', () {
        expect(
          MarioMakerTiming.imageScaleOutDuration,
          lessThan(MarioMakerTiming.bounceDurationDefault),
        );
      });
    });
  });
}
