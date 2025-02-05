import 'package:flutter/material.dart';

class ApplicantCard extends StatelessWidget {
  final String name;
  const ApplicantCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    // const SizedBox(height: 2),
                    Row(
                      children: [
                        SizedBox(
                          width: 91,
                          height: 21,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Accept",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 10,fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        SizedBox(
                          width: 88,
                          height: 21, // Fixed button height for consistency
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Reject",
                               style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 10,fontWeight: FontWeight.w600
                              ),)
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
