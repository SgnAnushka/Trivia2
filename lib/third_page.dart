import 'package:flutter/material.dart';
import 'que.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Thirdpage extends StatefulWidget {
  final String category;
  final String difficulty;
  final String Type;

  const Thirdpage({
    Key? key,
    required this.category,
    required this.difficulty,
    required this.Type,
  }) : super(key: key);

  @override
  _ThirdpageState createState() => _ThirdpageState();
}

class _ThirdpageState extends State<Thirdpage> {
  List<Queclass> questions = [];
  int index = 0;
  bool isLoading = true;
  int totalcorrect=0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final categoryMap = {
      'Mythology': 20,
      'Art': 25,
      'History': 23,
      'Animals': 27,
    };
    final categoryID = categoryMap[widget.category] ?? 0;
    final response = await http.get(
      Uri.parse(
          'https://opentdb.com/api.php?amount=10&category=$categoryID&difficulty=${widget.difficulty}&type=${widget.Type}'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        questions = (data['results'] as List)
            .map((item) => Queclass.fromJson(item))
            .toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _correctAns(String selectedOption, BuildContext context) {
    if (selectedOption == questions[index].correctoption) {
      setState(() {
        totalcorrect++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Correct!',
            style: TextStyle(color: Colors.green),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wrong!',
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _answerQuestion(BuildContext context) {
    setState(() {
      if (index < questions.length - 1) {
        index++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have completed the quiz!'),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'RESTART',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Center(
          child: Text(
            'QUESTIONS',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : questions.isEmpty
          ? const Center(
        child: Text(
          'Questions could not be fetched' ,
          style: TextStyle(fontSize: 20.0),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(

                'Correct Answers: $totalcorrect',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20.0),
            Text(
              'Question ${index+1}/10: ${questions[index].questions}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20.0),
            ...questions[index].options.asMap().entries.map((entry) {
              int optionIndex = entry.key;
              String optionText = entry.value;
              return ElevatedButton(
                onPressed: () {
                  _correctAns(optionText, context);
                  _answerQuestion(context);
                },
                child: Text(optionText),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
