import 'package:example_finished/config/constants.dart';
import 'package:example_finished/utils/mock_helper.dart';
import 'package:example_finished/widgets/bottom_progress_bar.dart';
import 'package:example_finished/widgets/update_name_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InfiniteList extends StatefulWidget {
  const InfiniteList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {

  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;
  int updatingItem = -1, addingItem = -1;

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
                    return Slidable(

                      child: ListTile(
                        title: Text(items[index]),
                      ),

                      actionPane: const SlidableStrechActionPane(),

                      actions: <Widget>[
                        IconSlideAction(
                          caption: Constants.changeName,
                          color: Colors.blue,
                          icon: Icons.update,
                          onTap: () => goToUpdateElement(index),
                        )
                      ],

                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: Constants.deleteEntry,
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => deleteElement(index),
                        )
                      ],
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
                itemCount: items.length + (allLoaded ? 1 : 0),
              ),
              // TODO: why is this if statement so weird, what does it mean?
              if(loading)...[
                BottomProgressBar(constraints: constraints)
              ]
            ]);
              
        } else {
          return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddItemPopup(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange.shade300),
    );
  }

  mockFetch() async {
    if(allLoaded) return;

    setState(() => loading = true);

    List<String> newData = await MockHelper.mockList(items);

    if(newData.isNotEmpty) items.addAll(newData);

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  deleteElement(index) {
    setState(() => items.removeAt(index));
  }

  goToUpdateElement(index) {
    setState(() => updatingItem = index);
    showDialog(context: context, builder: (BuildContext context) => UpdateNamePopup(index: index, itemTitle: items[index], closeUpdateScreen: closeUpdateScreen));
  }

  closeUpdateScreen(index, newName) {
    items[index] = newName;
    setState(() => updatingItem = -1);
  }

  openAddItemPopup() {
    setState(() => addingItem = 1);
    showDialog(context: context, builder: (BuildContext context) => UpdateNamePopup(index: -2, itemTitle: "New", closeUpdateScreen: addItem));
  }

  addItem(int index, String newName) {
    items.add(newName);
    setState(() => addingItem = -1);
  }
  
}