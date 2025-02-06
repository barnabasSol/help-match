import 'package:flutter/material.dart';

class Home_Page_V extends StatefulWidget {
  const Home_Page_V({super.key});

  @override
  State<Home_Page_V> createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page_V> {
  int _selectedIndex = 2; // Home is selected by default

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
              _buildOrganizationGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }


  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          'Welcome, Dear user',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
       
       Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
        children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primary,     
               child: const Icon(Icons.person, size: 32),
        ),
        
        SizedBox(width: 52,),
          Icon(
            color: Theme.of(context).colorScheme.primary,
            Theme.of(context).brightness == Brightness.light
                ? Icons.light_mode
                : Icons.dark_mode,
        ),
      ]
       ),

               
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for Organization',
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondary,

        prefixIcon: const Icon(Icons.search),
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
          return CategoryItem(category: _categories[index]);
        },
      ),
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
      onTap: (index) => setState(() => _selectedIndex = _change_to_pages(index)),
    );
  }

 // ignore: non_constant_identifier_names
 _change_to_pages(int index) {
    
    if (index == 4) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/profilev')};}

    else if (index == 3) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homec')};}


    else if (index == 0) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/navv')};}


    else if (index == 1) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homen')};}
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
                    'Organization ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                   Text(
                    'Organization Type',
                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary,),
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