import 'package:flutter/material.dart';

class QuestionReview extends StatefulWidget {
  final Map<String , String> answers;
  const QuestionReview({super.key, required this.answers});

  @override
  State<QuestionReview> createState() => _QuestionReviewState();
}

class _QuestionReviewState extends State<QuestionReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: const Center(child: Text(
              'Submit',
            style: TextStyle(
              fontSize: 20,
              color: Colors.deepOrangeAccent
            ),
          )),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Review Answer',
                  style: TextStyle(
                      fontSize: 18,
                  ),),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.8,
                child: ListView.builder(
                    itemCount: widget.answers.length,
                    itemBuilder: (context,position){
                      String key = widget.answers.keys.elementAt(position);
                      String value = widget.answers.values.elementAt(position);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Q: $key',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.deepOrangeAccent
                              ),
                            ),
                            Text(
                                'Ans: $value',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
