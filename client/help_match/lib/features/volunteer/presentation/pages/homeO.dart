import 'package:flutter/material.dart';

class Home_Page_O extends StatefulWidget {
  const Home_Page_O({super.key});

  @override
  State<Home_Page_O> createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page_O> {
  int _selectedIndex = 2; // Home is selected by default
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              // Header Section
              _buildHeader(),
              const SizedBox(height: 24),

              // Organization Grid
              _buildOrganizationGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Organization Name"),
            accountEmail: const Text("organization@email.com"),
            currentAccountPicture:  CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              // backgroundImage: AssetImage('assets/organization_logo.png'),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Organization Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profileo');
            },
          ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Add New Job'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/addjob');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_document),
            title: const Text('Edit Job'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/editjob');
            },
          ),
        ],
      ),
    );
  }



  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        const Text(
          'Welcome, Dear user',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
         
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


  Widget _buildOrganizationGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return OrganizationCard(index: index);
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
     if (index == 3) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/homec')};
    } else if (index == 0) {
      return {Navigator.pop(context), Navigator.pushNamed(context, '/navo')};
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

  const OrganizationCard({super.key, required this.index});

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
              color: Theme.of(context).colorScheme.primary, // Replace with actual image
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              // icon: const Icon(Icons.bookmark_border),
              // icon: const Icon(Icons.add),
              icon: const Icon(Icons.settings),
             
              onPressed: () {},
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
                    'Job ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                   Text(
                    'Job Description',
                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
