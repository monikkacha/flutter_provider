import 'package:flutter/material.dart';
import 'package:flutter_provider/network/api_store.dart';
import 'package:flutter_provider/network/api_wrapper.dart';
import 'package:flutter_provider/screens/post_screen.dart';
import 'package:flutter_provider/utils/log_util.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // way to initialize single store
  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider<ApiStore>(
  //     create: (context) => ApiStore(),
  //     child: MaterialApp(
  //       title: 'Flutter Demo',
  //       theme: ThemeData(
  //         primarySwatch: Colors.blue,
  //       ),
  //       home: IntroductionaryScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    init();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApiStore>(
          create: (context) => ApiStore(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IntroductionaryScreen(),
      ),
    );
  }

  init() {
    ApiWrapper.init();
    loggerConfigure();
  }
}

class IntroductionaryScreen extends StatelessWidget {
  const IntroductionaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("GET DATA"),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => MyHomePage())),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                child: Text("POST DATA "),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => PostScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ScrollController();

  late ApiStore apiStore;

  @override
  void initState() {
    initData();
    setScrollController();
  }

  initData() async {
    apiStore = Provider.of<ApiStore>(context, listen: false);
    // apiStore.fetchData();
    Provider.of<ApiStore>(context, listen: false).fetchData();
  }

  setScrollController() {
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          Provider.of<ApiStore>(context, listen: false).fetchMoreData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider"),
      ),
      body: Consumer<ApiStore>(
        builder: (_, store, widget) {
          return store.isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  controller: _controller,
                  itemCount: (store.list.length + 1),
                  itemBuilder: (_, index) {
                    return (store.list.length == index)
                        ? store.loadingMoreData
                            ? Container(
                                margin: EdgeInsets.only(bottom: 100.0),
                                height: 50.0,
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : SizedBox()
                        : Card(
                            child: ListTile(
                              title: Text(store.list[index].title),
                              subtitle: Text(store.list[index].id.toString()),
                            ),
                          );
                  });
        },
      ),
    );
  }
}
