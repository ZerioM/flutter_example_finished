import 'package:example_finished/config/constants.dart';
import 'package:example_finished/utils/mock_helper.dart';
import 'package:example_finished/widgets/dismiss_background.dart';
import 'package:flutter/material.dart';

class InfiniteList extends StatefulWidget {
  const InfiniteList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {

  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;

  // is called, when the state of an widget is initialized
  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  // Builds the UI of the stateful Infinite List
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if(items.isNotEmpty){
          return Stack(
            children: [
              ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) 
                {
                  if(index < items.length) {
                    return Dismissible(
                      child: ListTile(
                        title: Text(items[index]),
                      ),
                      background:
                        const DismissBackground(text: Constants.deleteEntry, color: Colors.red, isLeft: true),
                      secondaryBackground: 
                        const DismissBackground(text: Constants.changeName, color: Colors.blue, isLeft: false),
                      key: ValueKey<String>(items[index]),
                      onDismissed: (DismissDirection direction) {
                        if(direction == DismissDirection.startToEnd) {
                          deleteElement(index);
                        } else {
                          goToUpdateElement(index);
                        }
                      }
                    );
                  } else {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: 50,
                      child: const Center(
                        child: Text(Constants.nothingMoreToLoad)
                      ),
                    );
                  }
                  
                }, 
                separatorBuilder: (context,index) 
                {
                  return const Divider(height: 1);
                }, 
                itemCount: items.length + (allLoaded ? 1 : 0)
              ),
              // TODO: why is this if statement so weird, what does it mean?
              if(loading)...[
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: 80,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    )
                  )
                  )
              ]
            ]);
              
        } else {
          return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },),
    );
  }

  mockFetch() async {
    if(allLoaded) return;

    setState(() {
      loading = true;
    });

    List<String> newData = await MockHelper.mockList(items);

    if(newData.isNotEmpty) items.addAll(newData);

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  deleteElement(index) {
    setState(() {
      items.removeAt(index);
    });
  }

  goToUpdateElement(index) {
    setState(() {
      items.removeAt(index);
    });
  }
  
}