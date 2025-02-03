import 'package:flutter/material.dart';

class ApplicantCard extends StatelessWidget {
  final String name;
  const ApplicantCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
              ),
              const SizedBox(
                width: 6,
              ),
              Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        // const SizedBox(
                        //   height: 7,
                        // ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(),
                                  onPressed: () {},
                                  child: Text(
                                    "Accept",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  )),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            SizedBox(
                                width: 100,
                                height: 30,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Reject",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall)))
                          ],
                        )
                      ])
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
