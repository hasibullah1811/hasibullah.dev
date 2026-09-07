import 'package:flutter_test/flutter_test.dart';
import 'package:hasib_website/main.dart';

void main() {
  testWidgets('Portfolio renders resume sections', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());

    expect(find.text('Hasibullah Hasib'), findsOneWidget);
    expect(
      find.text('AI-Native Full-Stack Developer & Mobile Engineer'),
      findsOneWidget,
    );
    expect(find.text('SKILLS'), findsOneWidget);
    expect(find.text('EXPERIENCE'), findsOneWidget);
    expect(find.text('PROJECTS'), findsOneWidget);
    expect(find.text('EDUCATION'), findsOneWidget);
    expect(find.text('Helping Hand'), findsOneWidget);
    expect(find.text('Prism RAG Visualizer'), findsOneWidget);
  });
}
