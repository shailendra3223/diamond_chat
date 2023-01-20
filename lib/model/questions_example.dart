
List<QuizeQuestionModel> questions = [
  QuizeQuestionModel(
    "Grand Central Terminal, Park Avenue, New York is the world's?",
    {
      "largest railway station": true,
      "highest railway station": false,
      "longest railway station": false,
      "None of the above": false,
    },
  ),
  QuizeQuestionModel("Eritrea, which became the 182nd member of the UN in 1993, is in the continent of?", {
    "Asia": false,
    "Africa": true,
    "Europe": false,
    "Australia":false,
  }),
  QuizeQuestionModel("Who is the father of Geometry?", {
    "Aristotle": false,
    "Pythagoras": false,
    "Kepler": false,
    "Euclid": true,
  }),
  QuizeQuestionModel("What is common between Kutty, Shankar, Laxman and Sudhir Dar?", {
    "Film Direction": false,
    "Drawing Cartoons": true,
    "Instrumental Music": false,
    "Classical Dance": false,
  }),
  QuizeQuestionModel("In which decade was the American Institute of Electrical Engineers (AIEE) founded?", {
    "1880s": true,
    "1930s": false,
    "1950s": false,
    "1850s": false,
  }),
  QuizeQuestionModel("Who was known as Iron man of India?", {
    "Govind Ballabh Pant": false,
    "Jawaharlal Nehru": false,
    "Subhash Chandra Bose": false,
    "Sardar Vallabhbhai Patel": true,
  }),
  QuizeQuestionModel(
      "What is part of a database that holds only one type of information?", {
    "Report": false,
    "Record": false,
    "Field": true,
    "File": false,
  }),
  QuizeQuestionModel("Track and field star Carl Lewis won how many gold medals at the 1984 Olympic games?", {
    "Two": false,
    "Three": false,
    "Four": true,
    "Eight": false,
  }),
  QuizeQuestionModel(
      "Who is the first Indian woman to win an Asian Games gold in 400m run?",
      {
        "M.L.Valsamma": false,
        "P.T.Usha": false,
        "Kamaljit Sandhu": true,
        "K.Malleshwari": false,
      }),
  QuizeQuestionModel(
      "The present Lok Sabha is the?", {
    "14th Lok Sabha": false,
    "15th Lok Sabha": true,
    "16th Lok Sabha": false,
    "17th Lok Sabha": false,
  }),
];

class QuizeQuestionModel {
  String? question;
  Map<String, bool>? answers;
  QuizeQuestionModel(this.question, this.answers);
}
