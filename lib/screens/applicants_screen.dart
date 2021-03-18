import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/customer.dart';
import 'package:service_app/screens/widgets/applicants_item_widget.dart';

class ApplicantsScreen extends StatefulWidget {
  final String jobId;
  ApplicantsScreen({
    @required this.jobId,
  });

  @override
  _ApplicantsScreenState createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  bool isInit = true;
  final _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Customer>(context, listen: false)
          .getAllApplicants(widget.jobId)
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
    final applicants = Provider.of<Customer>(context).applicants;
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
          Provider.of<Customer>(context, listen: false).searchApplicants(text);
        },
        maxLines: 1,
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
          hintText: 'Search by Provider...',
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
      appBar: AppBar(
        title: Text('Applicants'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: searchContainer,
        ),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : applicants.length <= 0
              ? Center(
                  child: Text(
                    'No applicants for this job!',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(4.0),
                  child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      return ApplicantsItemWidget(
                        job: applicants[i],
                      );
                    },
                    itemCount: applicants.length,
                  ),
                ),
    );
  }
}
