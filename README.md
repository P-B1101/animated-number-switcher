# animated_number_switcher

A Flutter package to animate text change. mostly numbers. it can animate time changes as well using time switcher.

## Getting started

To use this package, add `animated_number_switcher` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

## Usage

#### Example 


![Demo](screenshots/demo.gif)

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _random = Random();
  void _incrementCounter() {
    setState(() {
      _counter = _random.nextInt(_list.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            AnimatedTextSwitcher(
              _list[_counter],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

const _list = [
  'avoid',
  'away',
  'baby',
  'back',
  'bad',
  'bag',
  'ball',
  'book',
  'born',
  'both',
  'box',
  'boy',
  'card',
  'care',
  'chance',
  'civil',
  'claim',
  'class',
  'clear',
  'clearly',
  'close',
  'coach',
];



```