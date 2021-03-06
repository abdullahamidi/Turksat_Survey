import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turksat_survey/Classes/Answers.dart';
import 'package:turksat_survey/Classes/Questions.dart';
import 'package:turksat_survey/Screens/LoginScreen.dart';
import 'package:turksat_survey/ViewModels/UserAnswersVM.dart';
import 'package:turksat_survey/Widgets/QuestionWidget.dart';

class SurveyScreen extends StatelessWidget {
  Answers answers = Answers();
  UserAnswersVM userAnswers;
  Questions questions;
  SurveyScreen(this.questions, this.userAnswers);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Türksat Anket Uygulaması"),
          actions: [
            IconButton(
                padding: EdgeInsets.only(right: 30.0),
                icon: Icon(Icons.power_settings_new,
                    color: Theme.of(context).errorColor, size: 30.0),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: questions.questions.length == 0
              ? Center(
                  heightFactor: MediaQuery.of(context).size.height / 25,
                  child: Text("Anket soru içermemektedir"))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      for (var i = 0; i < questions.questions.length; i++)
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: Colors.blueGrey[50],
                            elevation: 5.0,
                            margin: EdgeInsets.all(10.0),
                            child: QuestionWidget(
                                questions.questions[i], userAnswers)),
                      RaisedButton(
                          padding: EdgeInsets.symmetric(horizontal: 75),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            answers.insertAnswers(userAnswers).then((_) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Image.asset(
                                        "assets/images/check.png",
                                        scale: 3,
                                      ),
                                      content: Text(
                                        "Anket Başarıyla Kaydedildi",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              int count = 0;
                                              Navigator.of(context).popUntil(
                                                  (_) => count++ >= 2);
                                            },
                                            child: Text(
                                              "Anket Seç",
                                            )),
                                        FlatButton(
                                            onPressed: () {
                                              SystemNavigator.pop();
                                            },
                                            child: Text(
                                              "Çıkış Yap",
                                            ))
                                      ],
                                    );
                                  });
                            });
                          },
                          child: Text(
                            "Anketi Kaydet",
                          )),
                    ]),
        ));
  }
}
