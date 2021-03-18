import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/post_job_screen.dart';
import 'package:service_app/screens/widgets/custom_drawer.dart';
import 'package:service_app/screens/widgets/job_list_item_widget.dart';

class SearchJobsScreen extends StatefulWidget {
  static const routeName = '/search-jobs-screen';

  @override
  _SearchJobsScreenState createState() => _SearchJobsScreenState();
}

class _SearchJobsScreenState extends State<SearchJobsScreen> {
  final _searchController = TextEditingController();
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getAllJobUser()
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = Provider.of<Customer>(context).jobsList;
    final searchContainer = Container(
      padding: EdgeInsets.only(left: 8),
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: TextField(
        cursorColor: Colors.grey,
        style: TextStyle(
          fontSize: 18.0,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (text) {
          Provider.of<Customer>(context, listen: false).searchJobs(text);
        },
        maxLines: 1,
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
          hintText: 'Search by Job Title...',
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        controller: _searchController,
        onSubmitted: (_) {},
      ),
    );
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(PostJobScreen.routeName)
              .then((value) {
            if (value == true) {
              setState(() {
                isInit = true;
                Provider.of<Customer>(context, listen: false)
                    .getAllJobUser()
                    .then((value) {
                  setState(() {
                    isInit = false;
                  });
                });
              });
            }
          });
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            );
          },
        ),
        title: Text('Find Jobs'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: searchContainer,
        ),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: jobs[i],
                    child: JobListItemWidget(),
                  ),
                ),
              ),
            ),
    );
  }
}
