class Queclass{
  final String category;
  final String type;
  final String difficulty;
  final String questions;
  final String correctoption;
  final List<String>  incorrectoptions;

  Queclass({required this.category,required this.type,required this.difficulty,required this.questions,required this.correctoption,required this.incorrectoptions});
  factory Queclass.fromJson(Map<String, dynamic> json) {
    final List<dynamic> incorrectAnswersJson = json["incorrect_answers"];
    final List<String> incorrectOptions = incorrectAnswersJson.cast<String>();
    return Queclass(
      category: json["category"],
      type: json["type"],
      difficulty: json["difficulty"],
      questions: json["question"],
      correctoption: json["correct_answer"],
      incorrectoptions: incorrectOptions,
    );
  }

  Map<String,dynamic> tojson()=>{
    "category":category,
    "type":type,
    "difficulty":difficulty,
    "question":questions,
    "correct_answer":correctoption,
    "incorrect_answers":incorrectoptions};

  List<String> get options
  {
    List<String> optionsList = List.from(incorrectoptions);
    optionsList.add(correctoption);
    optionsList.shuffle();
    return optionsList;
  }


}
