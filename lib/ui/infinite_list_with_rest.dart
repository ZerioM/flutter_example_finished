import 'package:example_finished/config/constants.dart';
import 'package:example_finished/utils/http.dart';
import 'package:example_finished/widgets/bottom_progress_bar.dart';
import 'package:example_finished/widgets/update_name_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InfiniteListWithRest extends StatefulWidget {
  const InfiniteListWithRest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfiniteListWithRestState();
}

class _InfiniteListWithRestState extends State<InfiniteListWithRest> {

  final ScrollController _scrollController = ScrollController();
  List<Item> items = [];
  bool loading = false, allLoaded = false;
  int updatingItem = -1, addingItem = -1;
  Http httpController = Http();

  // is called, when the state of an widget is initialized
  @override
  void initState() {
    super.initState();
    fetch();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        // fetch();
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
                        title: Text(items[index].title),
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

  fetch() async {
    if(allLoaded) return;

    setState(() => loading = true);

    items = await httpController.getItems();

    setState(() {
      loading = false;
      allLoaded = items.isEmpty;
    });
  }

  goToUpdateElement(index) {
    setState(() => updatingItem = index);
    showDialog(context: context, builder: (BuildContext context) => UpdateNamePopup(index: index, itemTitle: items[index].title, closeUpdateScreen: closeUpdateScreen));
  }

  openAddItemPopup() {
    setState(() => addingItem = 1);
    showDialog(context: context, builder: (BuildContext context) => UpdateNamePopup(index: -2, itemTitle: "New", closeUpdateScreen: addItem));
  }

  addItem(int index, String newName) async {
    setState(() => loading = true);
    final bool response = await httpController.addItem(newName);
    if(response == true) {
      items.add(Item(title: newName));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(newName + Constants.couldNotBeSaved)));
    }
    setState(() { 
      addingItem = -1; 
      loading = false;
    });
  }

  closeUpdateScreen(int index, String newName) async {
    setState(() => loading = true);
    final bool response = await httpController.saveItemById(index, newName);
    if(response == true) {
      items[index].title = newName;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(newName + ", index: " + index.toString() + Constants.couldNotBeUpdated)));
    }
    setState(() { 
      updatingItem = -1; 
      loading = false;
    });
  }

  deleteElement(index) async {
    setState(() => loading = true);
    final bool response = await httpController.deleteItemById(index);

    if(response == true){
      setState(() => items.removeAt(index));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(index.toString() + Constants.couldNotBeUpdated)));
    }
    
    setState(() => loading = false);
  }
  
}