import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/database_helper.dart';
import 'package:flutter_application_1/models/subject_model.dart';
import 'package:flutter_application_1/screens/add_subject_task.dart';

class SubjectListScreen extends StatefulWidget {
  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  Future<List<Subject>> _subjectList;
  double gwa = 0;
  double total_grade = 0;
  double total_unit = 0;
  double _tt = 1;
  @override
  void initState() {
    super.initState();
    _updateSubjectList();
    gwa = 0;
    total_unit = 0;
    total_grade = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _updateSubjectList() {
    setState(() {
      _subjectList = DatabaseHelper.instance.getSubjectList();
      gwa = 0;
      total_unit = 0;
      total_grade = 0;
    });
  }

  _buildGwa(Subject subject) {
    total_unit = double.parse(subject.unit) + total_unit;
    total_grade =
        double.parse(subject.grade) * double.parse(subject.unit) + total_grade;
    gwa = total_grade / total_unit;
    String g = gwa.toStringAsFixed(3);
    gwa = double.parse(g);
  }

  Widget _buildSubjects(Subject subject) {
    _tt = double.parse(subject.unit) + _tt;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(subject.title),
            subtitle: Text(
              subject.unit,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            trailing: Text(
              subject.grade,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddSubjectScreen(
                  updateSubjectList: _updateSubjectList,
                  subject: subject,
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddSubjectScreen(
                      updateSubjectList: _updateSubjectList,
                    ))),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: FutureBuilder(
                future: _subjectList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 100.0),
                    itemCount: 1 + snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Subjects',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 10.0),
                                ]));
                      }

                      return _buildSubjects(snapshot.data[index - 1]);
                    },
                  );
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: FutureBuilder(
                future: _subjectList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    itemCount: 1 + snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == snapshot.data.length) {
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 90.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      'GWA',
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      '$gwa',
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                ]));
                      }
                      _buildGwa(snapshot.data[index]);
                      return SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
