import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentCarouselIndex = 0;
  late PageController _carouselController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  late AnimationController _offersHoverController;
  late Animation<double> _offersHoverAnimation;
  late AnimationController _mobileAnimationController;
  late Animation<double> _mobileScaleAnimation;
  int? _hoveredIndex;
  int? _hoveredOfferIndex;
  bool _showCartMessage = false;
  String _addedProductName = '';
  
  // Device detection variables
  bool _isMobile = false;
  bool _isTablet = false;
  bool _isDesktop = false;
  bool _isWeb = false;
  bool _isLandscape = false;
  double _screenWidth = 0;
  double _screenHeight = 0;
  
  final List<Map<String, dynamic>> featuredProducts = [
    {
      "title": "Ambient Lighting",
      "image": "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=600&h=400&fit=crop",
      "gradient": [Color(0xFF2D1B69), Color(0xFF4C1D95), Color(0xFF6B46C1)],
    },
    {
      "title": "Premium Collection",
      "image": "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=600&h=400&fit=crop",
      "gradient": [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4C1D95)],
    },
    {
      "title": "Tech Innovation",
      "image": "assets/3.jpg",
      "gradient": [Color(0xFF4C1D95), Color(0xFF6B46C1), Color(0xFF8B5CF6)],
    },
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "MacBook Pro 16\"",
      "price": "\$2,399",
      "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=300&fit=crop&crop=center",
      "description": "Professional laptop for developers"
    },
    {
      "name": "Wireless Headphones",
      "price": "\$299",
      "image": "assets/1.jpg",
      "description": "Premium audio experience"
    },
    {
      "name": "Smart Watch",
      "price": "\$399",
      "image": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=300&fit=crop&crop=center",
      "description": "Track your fitness and stay connected"
    },
    {
      "name": "Designer Backpack",
      "price": "\$129",
      "image": "assets/2.jpg",
      "description": "Stylish and functional"
    },
    {
      "name": "Premium Keyboard",
      "price": "\$199",
      "image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=300&h=200&fit=crop",
      "description": "Mechanical keyboard for professionals"
    },
    {
      "name": "Wireless Mouse",
      "price": "\$79",
      "image": "assets/3.jpg",
      "description": "Ergonomic wireless mouse"
    },
  ];

  final List<Map<String, String>> offers = [
    {
      "title": "50% Off Electronics",
      "description": "Limited time offer on all tech gadgets",
      "buttonText": "50% OFF"
    },
    {
      "title": "Free Shipping Weekend",
      "description": "No delivery charges on orders above \$50",
      "buttonText": "FREE SHIP"
    },
    {
      "title": "Buy 2 Get 1 Free",
      "description": "On selected accessories and peripherals",
      "buttonText": "B2G1"
    },
    {
      "title": "Student Discount",
      "description": "Extra 20% off with valid student ID",
      "buttonText": "20% OFF"
    },
    {
      "title": "Bundle Deals",
      "description": "Save more when you buy complete setups",
      "buttonText": "BUNDLE"
    },
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _offersHoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offersHoverAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _offersHoverController, curve: Curves.easeInOut),
    );
    _mobileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _mobileScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _mobileAnimationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _detectDeviceType(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _isLandscape = mediaQuery.orientation == Orientation.landscape;
    _isWeb = kIsWeb;
    
    // Comprehensive device detection
    if (_isWeb) {
      if (_screenWidth < 768) {
        _isMobile = true;
        _isTablet = false;
        _isDesktop = false;
      } else if (_screenWidth < 1024) {
        _isMobile = false;
        _isTablet = true;
        _isDesktop = false;
      } else {
        _isMobile = false;
        _isTablet = false;
        _isDesktop = true;
      }
    } else {
      // Mobile/Desktop app detection
      if (_screenWidth < 600) {
        _isMobile = true;
        _isTablet = false;
        _isDesktop = false;
      } else if (_screenWidth < 1200) {
        _isMobile = false;
        _isTablet = true;
        _isDesktop = false;
      } else {
        _isMobile = false;
        _isTablet = false;
        _isDesktop = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _detectDeviceType(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return CustomScrollView(
                physics: _getScrollPhysics(),
                slivers: [
                  _buildHeader(),
                  _buildFeaturedProducts(constraints),
                  _buildSectionTitle("Shop Our Collection"),
                  _buildProductGrid(constraints),
                  _buildSectionTitle("Hot Offers 🔥"),
                  _buildOffersList(constraints),
                  SliverToBoxAdapter(
                    child: SizedBox(height: _isMobile ? 80 : 20),
                  ),
                ],
              );
            },
          ),
          if (_showCartMessage) _buildCartMessage(),
        ],
      ),
    );
  }

  ScrollPhysics _getScrollPhysics() {
    if (_isWeb) {
      return const ClampingScrollPhysics();
    } else if (_isMobile) {
      return const BouncingScrollPhysics();
    } else {
      return const ClampingScrollPhysics();
    }
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: _isMobile ? 16 : (_isTablet ? 20 : 24),
          horizontal: _isMobile ? 16 : (_isTablet ? 24 : 32),
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF6B46C1),
        ),
        child: Center(
          child: Text(
            "Our Products",
            style: GoogleFonts.poppins(
              fontSize: _isMobile ? 24 : (_isTablet ? 28 : 32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts(BoxConstraints constraints) {
    final isTablet = constraints.maxWidth > 768;
    final carouselHeight = isTablet ? 250.0 : 200.0;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
        child: Column(
          children: [
            Text(
              "Featured Products",
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 28 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: carouselHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Carousel with enhanced mobile support
                  PageView.builder(
                    controller: _carouselController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                    itemCount: featuredProducts.length,
                    physics: const BouncingScrollPhysics(), // iOS-like bounce
                    itemBuilder: (context, index) {
                      final product = featuredProducts[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              // Background Image
                              Positioned.fill(
                                child: Image.network(
                                  product["image"],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: product["gradient"],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: product["gradient"],
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 60,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Gradient Overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Content
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    product["title"],
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 22 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Decorative Icon
                              Positioned(
                                top: 20,
                                right: 20,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.star,
                                      size: isTablet ? 24 : 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Left Arrow
                  Positioned(
                    left: 8,
                    top: carouselHeight / 2 - 20,
                    child: GestureDetector(
                      onTap: () {
                        if (_currentCarouselIndex > 0) {
                          _carouselController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Loop to last item
                          _carouselController.animateToPage(
                            featuredProducts.length - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Right Arrow
                  Positioned(
                    right: 8,
                    top: carouselHeight / 2 - 20,
                    child: GestureDetector(
                      onTap: () {
                        if (_currentCarouselIndex < featuredProducts.length - 1) {
                          _carouselController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Loop to first item
                          _carouselController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Navigation dots
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(featuredProducts.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentCarouselIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BoxConstraints constraints) {
    final isTablet = constraints.maxWidth > 768;

    // Always use 2 columns for better layout
    int crossAxisCount = 2;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: isTablet ? 0.85 : 0.8,
          crossAxisSpacing: isTablet ? 20 : 16,
          mainAxisSpacing: isTablet ? 20 : 16,
        ),
         delegate: SliverChildBuilderDelegate(
           (context, index) {
             final product = products[index];
             final isHovered = _hoveredIndex == index;

             return AnimatedBuilder(
               animation: _isMobile ? _mobileScaleAnimation : _hoverAnimation,
               builder: (context, child) {
                 return Transform.scale(
                   scale: _isMobile
                       ? (_hoveredIndex == index ? _mobileScaleAnimation.value : 1.0)
                       : (isHovered ? _hoverAnimation.value : 1.0),
                   child: _isMobile
                       ? GestureDetector(
                           onTapDown: (_) {
                             setState(() {
                               _hoveredIndex = index;
                             });
                             _mobileAnimationController.forward();
                           },
                           onTapUp: (_) {
                             setState(() {
                               _hoveredIndex = null;
                             });
                             _mobileAnimationController.reverse();
                           },
                           onTapCancel: () {
                             setState(() {
                               _hoveredIndex = null;
                             });
                             _mobileAnimationController.reverse();
                           },
                           child: _buildProductCard(product, isHovered, isTablet),
                         )
                       : MouseRegion(
                           onEnter: (_) {
                             setState(() {
                               _hoveredIndex = index;
                             });
                             _hoverController.forward();
                           },
                           onExit: (_) {
                             setState(() {
                               _hoveredIndex = null;
                             });
                             _hoverController.reverse();
                           },
                           child: _buildProductCard(product, isHovered, isTablet),
                         ),
                 );
               },
             );
           },
           childCount: products.length,
         ),
       ),
     );
   }

   Widget _buildProductCard(Map<String, dynamic> product, bool isHovered, bool isTablet) {
     return Container(
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(12),
         boxShadow: [
           BoxShadow(
             color: isHovered
                 ? Colors.grey.withOpacity(0.2)
                 : Colors.grey.withOpacity(0.1),
             spreadRadius: isHovered ? 2 : 1,
             blurRadius: isHovered ? 8 : 4,
             offset: Offset(0, isHovered ? 4 : 2),
           ),
         ],
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Expanded(
             flex: 3,
             child: Stack(
               children: [
                 Container(
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: const BorderRadius.vertical(
                       top: Radius.circular(12),
                     ),
                   ),
                   child: ClipRRect(
                     borderRadius: const BorderRadius.vertical(
                       top: Radius.circular(12),
                     ),
                     child: Image.network(
                       product["image"],
                       width: double.infinity,
                       height: double.infinity,
                       fit: BoxFit.cover,
                       loadingBuilder: (context, child, loadingProgress) {
                         if (loadingProgress == null) return child;
                         return Container(
                           height: double.infinity,
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                               colors: [
                                 Colors.grey[100]!,
                                 Colors.grey[200]!,
                               ],
                             ),
                           ),
                           child: Center(
                             child: CircularProgressIndicator(
                               value: loadingProgress.expectedTotalBytes != null
                                   ? loadingProgress.cumulativeBytesLoaded /
                                       loadingProgress.expectedTotalBytes!
                                   : null,
                               color: const Color(0xFF6B46C1),
                             ),
                           ),
                         );
                       },
                       errorBuilder: (context, error, stackTrace) {
                         return Container(
                           height: double.infinity,
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                               colors: [
                                 Colors.grey[100]!,
                                 Colors.grey[200]!,
                               ],
                             ),
                           ),
                           child: Icon(
                             Icons.image_not_supported,
                             size: isTablet ? 70 : 60,
                             color: Colors.grey[600],
                           ),
                         );
                       },
                     ),
                   ),
                 ),
                 Positioned(
                   top: 8,
                   right: 8,
                   child: GestureDetector(
                     onTap: () => _addToCart(product["name"]),
                     child: AnimatedContainer(
                       duration: const Duration(milliseconds: 200),
                       padding: const EdgeInsets.all(6),
                       decoration: BoxDecoration(
                         color: isHovered
                             ? const Color(0xFF4C1D95)
                             : const Color(0xFF6B46C1),
                         shape: BoxShape.circle,
                         boxShadow: isHovered ? [
                           BoxShadow(
                             color: const Color(0xFF6B46C1).withOpacity(0.3),
                             spreadRadius: 2,
                             blurRadius: 8,
                           ),
                         ] : null,
                       ),
                       child: const Icon(
                         Icons.shopping_cart,
                         color: Colors.white,
                         size: 16,
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
           Expanded(
             flex: 2,
             child: Padding(
               padding: const EdgeInsets.all(12),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     product["name"],
                     style: GoogleFonts.poppins(
                       fontSize: isTablet ? 16 : 14,
                       fontWeight: FontWeight.w600,
                       color: Colors.grey[800],
                     ),
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                   ),
                   const Spacer(),
                   Text(
                     product["price"],
                     style: GoogleFonts.poppins(
                       fontSize: isTablet ? 18 : 16,
                       fontWeight: FontWeight.bold,
                       color: const Color(0xFF6B46C1),
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

   Widget _buildOffersList(BoxConstraints constraints) {
     final isTablet = constraints.maxWidth > 768;

     return SliverList(
       delegate: SliverChildBuilderDelegate(
         (context, index) {
           final offer = offers[index];
           final isHovered = _hoveredOfferIndex == index;

           return AnimatedBuilder(
             animation: _isMobile ? _mobileScaleAnimation : _offersHoverAnimation,
             builder: (context, child) {
               return Transform.scale(
                 scale: _isMobile
                     ? (_hoveredOfferIndex == index ? _mobileScaleAnimation.value : 1.0)
                     : (isHovered ? _offersHoverAnimation.value : 1.0),
                 child: _isMobile
                     ? GestureDetector(
                         onTapDown: (_) {
                           setState(() {
                             _hoveredOfferIndex = index;
                           });
                           _mobileAnimationController.forward();
                         },
                         onTapUp: (_) {
                           setState(() {
                             _hoveredOfferIndex = null;
                           });
                           _mobileAnimationController.reverse();
                         },
                         onTapCancel: () {
                           setState(() {
                             _hoveredOfferIndex = null;
                           });
                           _mobileAnimationController.reverse();
                         },
                         child: _buildOfferCard(offer, isHovered, isTablet),
                       )
                     : MouseRegion(
                         onEnter: (_) {
                           setState(() {
                             _hoveredOfferIndex = index;
                           });
                           _offersHoverController.forward();
                         },
                         onExit: (_) {
                           setState(() {
                             _hoveredOfferIndex = null;
                           });
                           _offersHoverController.reverse();
                         },
                         child: _buildOfferCard(offer, isHovered, isTablet),
                       ),
               );
             },
           );
         },
         childCount: offers.length,
       ),
     );
   }

   Widget _buildOfferCard(Map<String, String> offer, bool isHovered, bool isTablet) {
     return Container(
       margin: EdgeInsets.symmetric(
         horizontal: isTablet ? 24 : 16,
         vertical: 6
       ),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(12),
         boxShadow: [
           BoxShadow(
             color: isHovered
                 ? Colors.grey.withOpacity(0.2)
                 : Colors.grey.withOpacity(0.1),
             spreadRadius: isHovered ? 2 : 1,
             blurRadius: isHovered ? 8 : 4,
             offset: Offset(0, isHovered ? 4 : 2),
           ),
         ],
       ),
       child: Padding(
         padding: EdgeInsets.all(isTablet ? 20 : 16),
         child: Row(
           children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     offer["title"]!,
                     style: GoogleFonts.poppins(
                       fontSize: isTablet ? 18 : 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.grey[800],
                     ),
                   ),
                   const SizedBox(height: 4),
                   Text(
                     offer["description"]!,
                     style: GoogleFonts.poppins(
                       fontSize: isTablet ? 16 : 14,
                       color: Colors.grey[600],
                     ),
                   ),
                 ],
               ),
             ),
             const SizedBox(width: 12),
             AnimatedContainer(
               duration: const Duration(milliseconds: 200),
               padding: EdgeInsets.symmetric(
                 horizontal: isTablet ? 20 : 16,
                 vertical: isTablet ? 10 : 8,
               ),
               decoration: BoxDecoration(
                 color: isHovered
                     ? const Color(0xFF4C1D95)
                     : const Color(0xFF6B46C1),
                 borderRadius: BorderRadius.circular(20),
                 boxShadow: isHovered ? [
                   BoxShadow(
                     color: const Color(0xFF6B46C1).withOpacity(0.3),
                     spreadRadius: 2,
                     blurRadius: 8,
                   ),
                 ] : null,
               ),
               child: Text(
                 offer["buttonText"]!,
                 style: GoogleFonts.poppins(
                   fontSize: isTablet ? 14 : 12,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

   void _addToCart(String productName) {
     setState(() {
       _addedProductName = productName;
       _showCartMessage = true;
     });
     
     // Auto-hide message after 3 seconds
     Future.delayed(const Duration(seconds: 3), () {
       if (mounted) {
         setState(() {
           _showCartMessage = false;
         });
       }
     });
   }

   Widget _buildCartMessage() {
     return Positioned(
       top: 100,
       left: 0,
       right: 0,
       child: Center(
         child: AnimatedOpacity(
           opacity: _showCartMessage ? 1.0 : 0.0,
           duration: const Duration(milliseconds: 200),
           child: Container(
             margin: const EdgeInsets.symmetric(horizontal: 20),
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(12),
               boxShadow: [
                 BoxShadow(
                   color: Colors.black.withOpacity(0.1),
                   spreadRadius: 2,
                   blurRadius: 10,
                   offset: const Offset(0, 4),
                 ),
               ],
             ),
             child: Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Container(
                   padding: const EdgeInsets.all(8),
                   decoration: const BoxDecoration(
                     color: Color(0xFF6B46C1),
                     shape: BoxShape.circle,
                   ),
                   child: const Icon(
                     Icons.shopping_cart,
                     color: Colors.white,
                     size: 20,
                   ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "Item added to cart",
                         style: GoogleFonts.poppins(
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                           color: Colors.grey[800],
                         ),
                       ),
                       const SizedBox(height: 4),
                       Text(
                         "$_addedProductName has been added to your cart",
                         style: GoogleFonts.poppins(
                           fontSize: 14,
                           color: Colors.grey[600],
                         ),
                       ),
                     ],
                   ),
                 ),
                 GestureDetector(
                   onTap: () {
                     setState(() {
                       _showCartMessage = false;
                     });
                   },
                   child: Container(
                     padding: const EdgeInsets.all(4),
                     decoration: BoxDecoration(
                       color: Colors.grey[100],
                       shape: BoxShape.circle,
                     ),
                     child: Icon(
                       Icons.close,
                       color: Colors.grey[600],
                       size: 16,
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

   @override
   void dispose() {
     _carouselController.dispose();
     _animationController.dispose();
     _hoverController.dispose();
     _offersHoverController.dispose();
     _mobileAnimationController.dispose();
     super.dispose();
   }
}