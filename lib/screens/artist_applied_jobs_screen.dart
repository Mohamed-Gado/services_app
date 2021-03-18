import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/jobs_provider.dart';
import 'package:service_app/screens/widgets/applied_job_item_widget.dart';

class ArtistAppliedJobsScreen extends StatefulWidget {
  static const routeName = '/artist-applied-jobs-screen';
  ArtistAppliedJobsScreen({Key key}) : super(key: key);

  @override
  _ArtistAppliedJobsScreenState createState() =>
      _ArtistAppliedJobsScreenState();
}

class _ArtistAppliedJobsScreenState extends State<ArtistAppliedJobsScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<JobProvider>(context, listen: false)
          .getAppliedJobs()
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
    final jobs = Provider.of<JobProvider>(context).appliedJobs;
    return Scaffold(
      appBar: AppBar(
        title: Text('Applied Jobs'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(top: 4.0, right: 4.0, left: 4.0),
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: jobs[i],
                  child: AppliedJobItemWidget(),
                ),
              ),
            ),
    );
  }
}
