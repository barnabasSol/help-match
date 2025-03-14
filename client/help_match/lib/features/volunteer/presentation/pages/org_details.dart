import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/volunteer/bloc/org_bloc/org_bloc.dart';
import 'package:help_match/features/volunteer/dto/job_view_dto.dart';
import 'package:help_match/features/volunteer/presentation/widgets/job_card.dart';
import 'package:help_match/shared/widgets/map_ui.dart';

class OrgDetails extends StatefulWidget { 
  final String _orgId;
  OrgDetails({super.key, required orgId}) : _orgId = orgId;

  @override
  State<OrgDetails> createState() => _OrgDetailsState();
}

class _OrgDetailsState extends State<OrgDetails> {
  final _pageController = PageController();
  int selectedPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrganizationBloc>().add(FetchedOrg(org_id: widget._orgId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationBloc, OrgState>(builder: (context, state) {
      if (state is OrgFetchFailed) {
        return Center(child: Text(state.error));
      } else if (state is OrgFetchedSuccessfully) {
        var org = state.org;
        List<JobViewDto> jobs = state.org.jobs??[];
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                            child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30)),
                          child: Hero(
                            tag: 'org ${org.name}',
                            child: Image.network(
                              "https://imgs.search.brave.com/XUJeiz6wORWCNK-xAu78igkfR7GRKMfE0AvshQ8yOrQ/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9ibG9n/LmdyZWF0bm9ucHJv/Zml0cy5vcmcvd3At/Y29udGVudC91cGxv/YWRzLzIwMjIvMTEv/Z2l2ZS13aXRoLWhl/YXJ0LnBuZw",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                        Positioned(
                            left: 4,
                            bottom: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5)),
                                child: Text(
                                  org.name,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        const Positioned(
                            width: 90,
                            height: 90,
                            right: 5,
                            bottom: -40,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://imgs.search.brave.com/yw5EncgalTDrhbcKOguNACc9Ox5HX1NHcOtXRU0chQo/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy9l/L2VkL0lnbGVzaWFf/ZGVfU2FuX1BhbnRh/bGUlQzMlQjNuLF9P/aHJpZCxfTWFjZWRv/bmlhLF8yMDE0LTA0/LTE3LF9ERF8zNV9I/RFIuanBn"),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                    child: Text(org.description!,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _pageController.animateToPage(
                            0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.ease,
                          ),
                          child: SizedBox(
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Column(
                              children: [
                                Text(
                                  "Location",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedPage == 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Divider(
                                    thickness: 2,
                                    color: selectedPage == 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _pageController.animateToPage(1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.ease),
                          child: SizedBox(
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Column(
                              children: [
                                Text("Active Jobs",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedPage == 1
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onTertiaryContainer,
                                    )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Divider(
                                    thickness: 2,
                                    color: selectedPage == 1
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: selectedPage == 0 ? 370 : 400,
                    child: PageView(
                        onPageChanged: (value) {
                          setState(() {
                            selectedPage = value;
                          });
                        },
                        controller: _pageController,
                        children: [
                          SizedBox(
                            height: 350,
                            child: MapUi(org.location!),
                          ),
                          Container(
                            height: 500,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4),
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 5,
                              ),
                              itemCount: jobs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return JobCard(
                                  jobViewDto: jobs[index],
                                );
                              },
                            ),
                          )
                        ]),
                  )
                ],
              ),
            ),
          ),
        );
      }
      else{
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
