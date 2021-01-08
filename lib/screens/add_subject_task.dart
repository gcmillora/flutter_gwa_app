import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/database_helper.dart';
import 'package:flutter_application_1/models/subject_model.dart';

class AddSubjectScreen extends StatefulWidget {
  final Function updateSubjectList;
  final Subject subject;
  AddSubjectScreen({this.updateSubjectList, this.subject});
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

final _formKey = GlobalKey<FormState>();

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final List<String> _grades = [
    "1.00",
    "1.25",
    "1.50",
    "1.75",
    "2.00",
    "2.25",
    "2.5",
    "2.75",
    "3.00",
    "4.00",
    "5.00"
  ];
  String _title = '';
  String _unit = '';
  String _grade = '';

  @override
  void initState() {
    super.initState();
    if (widget.subject != null) {
      _title = widget.subject.title;
      _unit = widget.subject.unit;
      _grade = widget.subject.grade;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _delete() {
    DatabaseHelper.instance.deleteSubject(widget.subject.id);
    widget.updateSubjectList();
    Navigator.pop(context);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Subject subject = Subject(title: _title, grade: _grade, unit: _unit);
      if (widget.subject == null) {
        DatabaseHelper.instance.insertSubject(subject);
      } else {
        subject.id = widget.subject.id;
        DatabaseHelper.instance.updateSubject(subject);
      }
      widget.updateSubjectList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 15),
              Text(
                widget.subject == null ? 'Add Subject' : 'Update Subject',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a task title'
                            : null,
                        onSaved: (input) => _title = input,
                        initialValue: _title,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a task title'
                            : null,
                        onSaved: (input) => _unit = input,
                        initialValue: _unit.toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: DropdownButtonFormField(
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 22.0,
                        style: TextStyle(fontSize: 18.0),
                        items: _grades.map((String grade) {
                          return DropdownMenuItem(
                            value: grade,
                            child: Text(
                              grade,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Grade',
                          labelStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (input) =>
                            _grade == null ? 'Please select a grade' : null,
                        onChanged: (value) {
                          setState(() {
                            _grade = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: FlatButton(
                        child: Text(
                          widget.subject == null ? 'Add' : 'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: _submit,
                      ),
                    ),
                    widget.subject != null
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 20.0),
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: FlatButton(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: _delete,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
