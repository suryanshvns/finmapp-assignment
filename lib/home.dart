import 'package:finma_assignment/Models/Question.dart';
import 'package:finma_assignment/question_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic data;
  int indexQuestion = 0;
  Map<String, String> answers = {};
  bool _isBalanceTOPup = false;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  @override
  initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/Questions.json');
    setState(() {
      data = questionFromJson(response);
    });
    if (kDebugMode) {
      print(data.schema.fields[0].schema.label);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 119, 108, 108)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              indexQuestion != 0
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          if (indexQuestion != 0) {
                            indexQuestion--;
                            pageController.animateToPage(
                              indexQuestion,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          }
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_sharp,
                            size: 18,
                          ),
                          Text(
                            ' Back',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ))
                  : const SizedBox(),
              InkWell(
                  onTap: () {
                    setState(() {
                      if (indexQuestion < data.schema.fields.length - 1) {
                        indexQuestion++;
                        if (kDebugMode) {
                          print(answers.toString());
                        }

                        for (int i = 0; i < data.schema.fields.length; i++) {
                          if (data.schema.fields[i].schema.hidden == true) {
                            indexQuestion = i + 1;
                            print('came here $i');
                          }
                        }

                        if (_isBalanceTOPup) {
                          for (int i = 0; i < data.schema.fields.length; i++) {
                            if (data.schema.fields[i].schema.hidden ==
                                "balance-transfer-top-up") {
                              data.schema.fields[i].schema.hidden = false;
                              _isBalanceTOPup = false;
                              indexQuestion = i;
                              print('came here $i');
                            } else {
                              if (i > 0) {
                                data.schema.fields[i].schema.hidden = true;
                                print('came else here $i');
                              }
                            }
                          }
                        }
                        pageController.animateToPage(
                          indexQuestion,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      }
                    });
                  },
                  child: indexQuestion < data.schema.fields.length - 1
                      ? Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 32, 145, 238),
                            // borderRadius: BorderRadius.circular(50)
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.elliptical(80, 100),
                              right: Radius.elliptical(80, 100),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        QuestionReview(answers: answers)));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 27, 190, 235),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: const Text(
                                  'Final Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ))
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: data != null
              ? Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontSize: 30),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: SizedBox(
                          height: 4,
                          child: GridView.builder(
                              itemCount: data.schema.fields.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: data.schema.fields.length,
                                      crossAxisSpacing: 1),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: indexQuestion == index
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(2)),
                                );
                              }),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: PageView.builder(
                            itemCount: data.schema.fields.length,
                            controller: pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return data.schema.fields[index].schema.hidden ==
                                      false
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.schema.fields[index].schema
                                              .label,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        data.schema.fields[index].type ==
                                                    "SingleChoiceSelector" ||
                                                data.schema.fields[index]
                                                        .type ==
                                                    "SingleSelect"
                                            ? SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                                child: ListView.builder(
                                                    itemCount: data
                                                        .schema
                                                        .fields[index]
                                                        .schema
                                                        .options
                                                        .length,
                                                    itemBuilder:
                                                        (context, position) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8,
                                                                horizontal: 0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              if (indexQuestion ==
                                                                  0) {
                                                                readJson();
                                                              }
                                                              if (data
                                                                      .schema
                                                                      .fields[
                                                                          index]
                                                                      .schema
                                                                      .options[
                                                                          position]
                                                                      .value ==
                                                                  "Balance transfer & Top-up") {
                                                                _isBalanceTOPup =
                                                                    true;
                                                              }
                                                              answers[
                                                                  data
                                                                      .schema
                                                                      .fields[
                                                                          index]
                                                                      .schema
                                                                      .label] = data
                                                                  .schema
                                                                  .fields[index]
                                                                  .schema
                                                                  .options[
                                                                      position]
                                                                  .value;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: answers.containsValue(data
                                                                            .schema
                                                                            .fields[
                                                                                index]
                                                                            .schema
                                                                            .options[
                                                                                position]
                                                                            .value)
                                                                        ? Color.fromARGB(
                                                                            255,
                                                                            33,
                                                                            154,
                                                                            224)
                                                                        : Colors
                                                                            .grey,
                                                                    width: 1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          15),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: 20,
                                                                    width: 20,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                100),
                                                                        border: Border.all(
                                                                            width:
                                                                                1,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                27,
                                                                                117,
                                                                                208))),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          3.0),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color: answers.containsValue(data.schema.fields[index].schema.options[position].value)
                                                                                ? Color.fromARGB(255, 14, 168, 225)
                                                                                : Colors.transparent,
                                                                            borderRadius: BorderRadius.circular(100)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Text(
                                                                    data
                                                                        .schema
                                                                        .fields[
                                                                            index]
                                                                        .schema
                                                                        .options[
                                                                            position]
                                                                        .value,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                                child: ListView.builder(
                                                    itemCount: data
                                                        .schema
                                                        .fields[index]
                                                        .schema
                                                        .fields
                                                        .length,
                                                    itemBuilder:
                                                        (context, position) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 10, 0, 10),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          41,
                                                                          131,
                                                                          234),
                                                                  width: 1)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    15,
                                                                    0,
                                                                    15,
                                                                    0),
                                                            child:
                                                                TextFormField(
                                                                    onChanged:
                                                                        (val) {
                                                                      setState(
                                                                          () {
                                                                        answers[data
                                                                            .schema
                                                                            .fields[index]
                                                                            .schema
                                                                            .fields[position]
                                                                            .schema
                                                                            .label] = val;
                                                                      });
                                                                    },
                                                                    decoration: InputDecoration(
                                                                        border: InputBorder
                                                                            .none,
                                                                        hintText: data
                                                                            .schema
                                                                            .fields[index]
                                                                            .schema
                                                                            .fields[position]
                                                                            .schema
                                                                            .label)),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              )
                                      ],
                                    )
                                  : SizedBox();
                            }),
                      )
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 38, 143, 229),
                ))),
    );
  }
}
