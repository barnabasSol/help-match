import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/theme/cubit/theme_cubit.dart';
import 'package:help_match/features/volunteer/bloc/load_more/load_more_cubit.dart';
import 'package:help_match/features/volunteer/bloc/search_bloc/volunteer_bloc.dart';
import 'package:help_match/features/volunteer/dto/org_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:help_match/features/volunteer/presentation/widgets/org_card.dart';

class VolunteerHome extends StatefulWidget {
  //  final FlutterSecureStorage secureStorage;
  const VolunteerHome({super.key});

  @override
  State<VolunteerHome> createState() => _HomePageState();
}

class _HomePageState extends State<VolunteerHome> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  final _scrollController = ScrollController();
  int _selectedCat = -1;
  late List<OrgDto> _organizations;
  final TextEditingController _searchController = TextEditingController();
  final List<Category> _categories = const [
    Category('Non-Profit', Icons.volunteer_activism),
    Category('For-Profit', Icons.attach_money),
    Category('Government', Icons.account_balance),
    Category('Community', Icons.people), //
    Category('Education', Icons.school),
    Category('Healthcare', Icons.medical_services),
    Category('Cultural', Icons.spoke_rounded)
  ];

  @override
  void initState() {
    super.initState();
    context.read<VolunteerBloc>().add(InitialFetch());
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (_isLoading || !_hasMore) return;
        _isLoading = true;
        fetch();
      }
    });
  }

  Future<void> fetch() async {
    String type = '';
    if (_selectedCat > -1) {
      type = _categories[_selectedCat].label;
    }
    final loadMoreCubit = context.read<LoadMoreCubit>();
    await loadMoreCubit.fetchMore(SearchDto(
        page: ++_page, org_name: _searchController.text, org_type: type));
    List<OrgDto> orgs = loadMoreCubit.state;
    setState(() {
      if (orgs.length < 4) {
        _hasMore = false;
      }
      _isLoading = false;
      _organizations.addAll(orgs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            const SizedBox(height: 24),

            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 32),

            // Categories
            _buildCategorySection(),
            const SizedBox(height: 15),

            // Organization Grid
            Expanded(child: _buildScrollableOrganizationGrid()),
          ],
        ),
      ),
      //  bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
              "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain"),
        ),
        const SizedBox(
          width: 52,
        ),
        Icon(
          color: Theme.of(context).colorScheme.primary,
          Theme.of(context).brightness == Brightness.light
              ? Icons.light_mode
              : Icons.dark_mode,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.person, size: 32),
          ),
          const SizedBox(
            width: 52,
          ),
          IconButton(
            icon: Theme.of(context).brightness == Brightness.light
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
            onPressed: () {
              context.read<ThemeCubit>().themeChange();
            },
            color: Theme.of(context).colorScheme.primary,
          ),
        ]),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for Organization',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onTertiaryContainer,
        prefixIcon: IconButton(
            onPressed: () {
              String type = '';
              if (_selectedCat != -1) {
                type = _categories[_selectedCat].label;
              }
              context.read<VolunteerBloc>().add(SearchPressed(
                  dto: SearchDto(
                      org_name: _searchController.text, org_type: type)));
            },
            icon: Icon(Icons.search,
                color: Theme.of(context).colorScheme.primary)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final isSelected = _selectedCat == index;
          return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCat = index;
                });

                context.read<VolunteerBloc>().add(SearchPressed(
                    dto: SearchDto(
                        org_name: _searchController.text,
                        org_type: _categories[index].label)));
              },
              child: CategoryItem(
                  category: _categories[index], isSelected: isSelected));
        },
      ),
    );
  }

  Widget _buildScrollableOrganizationGrid() {
    return BlocBuilder<VolunteerBloc, VolunteerState>(
      builder: (context, state) {
        if (state is OrgsFetchedFailed) {
          return Center(
            child: Text(state.error),
          );
        } else if (state is OrgsFetchedSuccessfully) {
          _organizations = state.organizations;
          // return OrganizationCard(name: orgs[0].name, description: orgs[0].description, type: orgs[0].type, imageUrl: orgs[0].profileIcon);
          return RefreshIndicator(
            displacement: 20,
            onRefresh: () async {
              setState(() {
                _hasMore = true;
                _page = 1;
              });
              context.read<VolunteerBloc>().add(SearchPressed(
                  dto: SearchDto(
                      org_name: _searchController.text,
                      org_type: _selectedCat > -1
                          ? _categories[_selectedCat].label
                          : "")));
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(4),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return OrganizationCard(
                          orgDto: _organizations[index],
                        );
                      },
                      childCount: _organizations.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                    ),
                  ),
                ),
                if (_hasMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (!_hasMore)
                  SliverToBoxAdapter(
                    child: Center(
                        child: Text(
                      "That is all",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    )),
                  ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      },
    );
  }

  // ignore: non_constant_identifier_names
}

class Category {
  final String label;
  final IconData icon;

  const Category(this.label, this.icon);
}

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;

  const CategoryItem(
      {super.key, required this.category, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            category.icon,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
