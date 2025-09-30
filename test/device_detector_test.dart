import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proportional_design/proportional_design.dart';

void main() {
  group('DeviceDetector Tests', () {
    testWidgets('should detect phone correctly', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final deviceType = context.deviceType;
                expect(deviceType, DeviceType.phone);
                expect(context.isPhoneDevice, true);
                expect(context.isTabletDevice, false);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should detect tablet correctly', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final deviceType = context.deviceType;
                expect(deviceType, DeviceType.tablet);
                expect(context.isTabletDevice, true);
                expect(context.isPhoneDevice, false);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should detect Material Design breakpoint compact',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final breakpoint = context.breakpoint;
                expect(breakpoint, MaterialBreakpoint.compact);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should detect Material Design breakpoint medium',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 1000)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final breakpoint = context.breakpoint;
                expect(breakpoint, MaterialBreakpoint.medium);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should detect Material Design breakpoint expanded',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1000, 1200)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final breakpoint = context.breakpoint;
                expect(breakpoint, MaterialBreakpoint.expanded);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should return device info', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final info = context.deviceInfo;
                expect(info['width'], 375);
                expect(info['height'], 812);
                expect(info['isPortrait'], true);
                expect(info['isLandscape'], false);
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });
}
