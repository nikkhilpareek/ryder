import 'package:car_rental_app/presentation/bloc/bloc/car_bloc.dart';
import 'package:car_rental_app/presentation/bloc/bloc/car_event.dart';
import 'package:car_rental_app/presentation/bloc/bloc/car_state.dart';
import 'package:car_rental_app/presentation/pages/car_details_page.dart';
import 'package:car_rental_app/presentation/pages/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_rental_app/presentation/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  // Filter and view options
  String? selectedCategory;
  bool isGridView = false;
  final List<String> categories = ['All', 'SUV', 'Sedan', 'Hatchback', 'Luxury', 'Electric'];
  
  // Map to store subcategories for each main category
  final Map<String, List<String>> categoryMap = {
    'SUV': ['SUV', 'Compact SUV', 'Mid-size SUV', 'Full-size SUV', 'Crossover', 'XUV300', 'XUV'],
    'Sedan': ['Sedan', 'Compact Sedan', 'Mid-size Sedan', 'Full-size Sedan'],
    'Hatchback': ['Hatchback', 'Compact Hatchback'],
    'Luxury': ['Luxury', 'Premium', 'Sport'],
    'Electric': ['Electric', 'Hybrid', 'Plug-in Hybrid'],
  };
  
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2B34),
      appBar: AppBar(
        title: Image.asset(
          'assets/textlogo.png',
          height: 36,
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Toggle between list and grid view
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            tooltip: isGridView ? 'List View' : 'Grid View',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search cars...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          
          // Category filter chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 60,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                final isSelected = selectedCategory == category || 
                                  (selectedCategory == null && category == 'All');
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    backgroundColor: Colors.white.withOpacity(0.05),
                    selectedColor: Colors.deepPurple,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[300],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.deepPurple : Colors.transparent,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category == 'All' ? null : category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Car list or grid with filtering
          Expanded(
            child: BlocBuilder<CarBloc, CarState>(
              builder: (context, state) {
                if (state is CarsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  );
                } else if (state is CarsLoaded) {
                  // Filter cars by category and search query
                  var filteredCars = state.cars.where((car) {
                    // Apply category filter if selected
                    bool categoryMatch = true;
                    if (selectedCategory != null && selectedCategory != 'All') {
                      // Get all subcategories for the selected main category
                      final subcategories = categoryMap[selectedCategory] ?? [selectedCategory!];
                      
                      // Check if the car's category is in the subcategories list
                      categoryMatch = subcategories.any((subCategory) => 
                        car.category.toLowerCase().contains(subCategory.toLowerCase()));
                    }
                    
                    // Apply search filter if search query exists
                    final searchMatch = searchQuery.isEmpty || 
                        car.model.toLowerCase().contains(searchQuery);
                    
                    return categoryMatch && searchMatch;
                  }).toList();
                  
                  if (filteredCars.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.car_rental,
                            size: 70,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No cars found',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Show either grid or list view based on selection
                  if (isGridView) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredCars.length,
                      itemBuilder: (context, index) {
                        return _buildGridItem(filteredCars[index]);
                      },
                    );
                  } else {
                    return ListView.builder(
                      itemCount: filteredCars.length,
                      itemBuilder: (context, index) {
                        return CarCard(car: filteredCars[index]);
                      },
                    );
                  }
                } else if (state is CarsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CarBloc>().add(LoadCars());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Grid item card for condensed view
  Widget _buildGridItem(car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailsPage(car: car),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car image
                    Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          _getCarImagePath(car.model),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/car_image.png');
                          },
                        ),
                      ),
                    ),
                    
                    // Car details
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.model,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs. ${car.pricePerHour.toStringAsFixed(0)}/hr',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.speed, size: 14, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${car.distance.toStringAsFixed(0)} km',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star, size: 14, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '4.8',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Category label
                Positioned(
                  top: 8,
                  right: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(car.category).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          car.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods (same as before)
  String _getCarImagePath(String model) {
    // Convert model name to lowercase for case-insensitive comparison
    final modelLower = model.toLowerCase();
    
    if (modelLower.contains('creta')) {
      return 'assets/creta.webp';
    } else if (modelLower.contains('civic')) {
      return 'assets/civic.png';
    } else if (modelLower.contains('corolla')) {
      return 'assets/corolla.png';
    } else if (modelLower.contains('fortuner')) {
      return 'assets/fortuner.png';
    } else if (modelLower.contains('harrier')) {
      return 'assets/harrier.webp';
    } else if (modelLower.contains('xuv')) {
      return 'assets/mahindra xuv 300.webp';
    } else if (modelLower.contains('swift')) {
      return 'assets/maruti suzuki swift.png';
    } else if (modelLower.contains('maybach')) {
      return 'assets/maybach gls 600.webp';
    }
    
    // Default image if no match found
    return 'assets/car_image.png';
  }

  Color _getCategoryColor(String category) {
    // Check for substrings to handle subcategories with proper precedence
    final categoryLower = category.toLowerCase();
    
    // Check for SUV first (since it should take precedence over other categories)
    if (categoryLower.contains('suv') || 
        categoryLower.contains('crossover') ||
        categoryLower == 'xuv300' || // Special case for Mahindra XUV300
        categoryLower.contains('xuv')) {
      return Colors.blue;
    } 
    // Then check other categories
    else if (categoryLower.contains('sedan')) {
      return Colors.green;
    } else if (categoryLower.contains('hatch')) {
      return Colors.orange;
    } else if (categoryLower.contains('luxury') || categoryLower.contains('premium')) {
      return Colors.purple;
    } else if (categoryLower.contains('electric') || categoryLower.contains('hybrid')) {
      return Colors.teal;
    } else {
      return Colors.deepPurple;
    }
  }
}
