import 'package:flutter_test/flutter_test.dart';
import 'package:shoper_flutter/core/service/api_service.dart';
import 'package:shoper_flutter/main.dart';

void main() {
  testWidgets('Example Widget Test', (WidgetTester tester) async {
    final ApiService apiService = ApiService(); // Instantiate ApiService here

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(apiService));

    // Verify that your initial widget is rendered.
    expect(find.text('Welcome to the home screen.'), findsOneWidget);

    // Perform interactions or additional tests based on your app's behavior.
    // For example, you can tap a button and test the updated UI.

    // Uncomment the lines below and replace with actual interaction in your app.
    // await tester.tap(find.byType(YourButtonType));
    // await tester.pump();

    // Verify the updated UI state.
    // expect(find.text('Updated Text'), findsOneWidget);
  });
}
