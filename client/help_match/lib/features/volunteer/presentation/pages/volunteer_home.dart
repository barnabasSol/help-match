import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/features/volunteer/bloc/volunteer_bloc.dart';
import 'package:help_match/features/volunteer/dto/org_card_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';

class VolunteerHome extends StatefulWidget {
  const VolunteerHome({super.key});

  @override
  State<VolunteerHome> createState() => _HomePageState();
}

class _HomePageState extends State<VolunteerHome> {
  int _selectedIndex = 2; // Home is selected by default
  int _selectedCat = -1;
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
    // TODO: implement initState
    super.initState();
    context.read<VolunteerBloc>().add(InitialFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(height: 32),

              // Organization Grid
              _buildScrollableOrganizationGrid(),
            ],
          ),
        ),
      ),
      //  bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    String name = context.read<UserAuthCubit>().currentUser!.username;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Welcome, Dear $name',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.person, size: 32),
          ),
          SizedBox(
            width: 52,
          ),
          Icon(
            color: Theme.of(context).colorScheme.primary,
            Theme.of(context).brightness == Brightness.light
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
        ]),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for Organization',
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,
        prefixIcon: IconButton(
            onPressed: () {
              String type = '';
              if (_selectedCat != -1) {
                type = _categories[_selectedIndex].label;
              }
              context.read<VolunteerBloc>().add(SearchPressed(
                  dto: SearchDto(
                      org_name: _searchController.text, org_type: type)));
            },
            icon: const Icon(Icons.search)),
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
          return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCat = index;
                });
                print(_searchController.text +
                    "Org type" +
                    _categories[index].label);
                context.read<VolunteerBloc>().add(SearchPressed(
                    dto: SearchDto(
                        org_name: _searchController.text,
                        org_type: _categories[index].label)));
              },
              child: CategoryItem(category: _categories[index]));
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
          List<OrgCardDto> orgs = state.organizations;
          return GridView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(), // Allow scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: state.organizations.length,
            itemBuilder: (context, index) {
              return OrganizationCard(
                index: index,
                orgName: orgs[index].org_name,
                orgType: orgs[index].type,
              );
            },
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.tertiary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) =>
          setState(() => _selectedIndex = _change_to_pages(index)),
    );
  }

  // ignore: non_constant_identifier_names
  _change_to_pages(int index) {
    if (index == 4) {
      return {
        Navigator.pop(context),
        Navigator.pushNamed(context, '/profilev')
      };
    } else if (index == 3) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/homec')};
    } else if (index == 0) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/navv')};
    } else if (index == 1) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/homen')};
    }
  }
}

class Category {
  final String label;
  final IconData icon;

  const Category(this.label, this.icon);
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(category.icon, size: 32),
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

class OrganizationCard extends StatelessWidget {
  final int index;
  final String orgName;
  final String orgType;

  const OrganizationCard(
      {super.key,
      required this.index,
      required this.orgName,
      required this.orgType});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              // height: 120,   // might be an issue forward
              color: Theme.of(context).colorScheme.primary,
              // Replace with actual image
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              // icon: const Icon(Icons.bookmark_border),
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/joblist');
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orgName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    orgType,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
