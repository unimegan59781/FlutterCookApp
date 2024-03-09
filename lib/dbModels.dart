class CSVdb {
  final int id;
  final int yes;
  final int no;
  final String statment;
  final String? question;

  CSVdb(
      {required this.id,
      required this.yes,
      required this.no,
      required this.statment,
      this.question});

  CSVdb.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        yes = res["yes"],
        no = res["no"],
        statment = res["statment"],
        question = res["question"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'yes': yes,
      'no': no,
      'statment': statment,
      'question': question
    };
  }
}