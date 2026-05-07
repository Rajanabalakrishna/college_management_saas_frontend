import 'package:college_management_saas/college_places_section.dart';
import 'package:college_management_saas/static_sections/branches_section.dart';
import 'package:college_management_saas/static_sections/explore_screen.dart';
import 'package:college_management_saas/static_sections/way2news.dart';
import 'package:college_management_saas/theme/app_colors.dart';
import 'package:college_management_saas/widgets/branch_card.dart';
import 'package:college_management_saas/widgets/place_card.dart';
import 'package:flutter/material.dart';

// ── Import your existing DepartmentsPage ─────────────────────────────────────
// This is the DepartmentsPage from your paste.txt / MainShell.
// Adjust the import path to wherever you keep that file.

// =============================================================================
//  CampusExploreScreen — the ONE shell for the entire app.
//  It owns the bottom nav bar and switches pages via IndexedStack.
//  No Navigator.push is used for tab switching — ever.
// =============================================================================
class CampusExploreScreen extends StatefulWidget {
  const CampusExploreScreen({super.key});

  @override
  State<CampusExploreScreen> createState() => _CampusExploreScreenState();
}

class _CampusExploreScreenState extends State<CampusExploreScreen> {
  // Start on Explore tab (index 0)
  int _selectedNavIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.explore,                  label: 'Explore'),
    _NavItem(icon: Icons.account_balance_outlined,  label: 'Depts'),
    _NavItem(icon: Icons.grid_view_outlined,        label: 'Dashboard'),
    _NavItem(icon: Icons.forum_outlined,            label: 'Social'),
  ];

  // All 4 tab pages. IndexedStack keeps them all alive (preserves scroll state).
  // Replace DashboardScreen / FeedScreen with your actual widget class names.
  late final List<Widget> _pages = [
    const _ExploreBody(),     // index 0 — Explore (home content)
    const DepartmentsPage(),  // index 1 — Academic Departments
    const ExploreScreen(),  // index 2 — Dashboard (your existing screen)
    const FeedScreen(),       // index 3 — Social / Feed (your existing screen)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      // ── IndexedStack is the ONLY way pages are switched ───────────────────
      body: IndexedStack(
        index: _selectedNavIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Bottom Navigation Bar ─────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBarBackground,
        border: Border(
          top: BorderSide(color: AppColors.navBarBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final isActive = _selectedNavIndex == index;
              return GestureDetector(
                // ✅ ONLY setState — zero Navigator.push calls
                onTap: () => setState(() => _selectedNavIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.navActiveBackground
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _navItems[index].icon,
                        color: isActive
                            ? AppColors.navActiveText
                            : AppColors.navInactiveText,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _navItems[index].label,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? AppColors.navActiveText
                              : AppColors.navInactiveText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  _ExploreBody — the Explore tab content (index 0)
//  Extracted from the original CampusExploreScreen body so it can live
//  inside IndexedStack as a plain widget.
// =============================================================================
class _ExploreBody extends StatelessWidget {
  const _ExploreBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Background Image ───────────────────────────────────────────────
        Positioned.fill(
          child: Image.asset(
            'assets/images/background_home.jpg',
            fit: BoxFit.cover,
            cacheWidth: 1080,
          ),
        ),
        // ── Frosted overlay ────────────────────────────────────────────────
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.82),
          ),
        ),
        // ── Scrollable content ─────────────────────────────────────────────
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildSliverAppBar(innerBoxIsScrolled),
          ],
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSearchSection(context),
                _buildBranchesSection(context),
                CollegePlacesSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Top App Bar ────────────────────────────────────────────────────────────
  SliverAppBar _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.white.withOpacity(0.95),
      elevation: innerBoxIsScrolled ? 1 : 0,
      shadowColor: AppColors.cardShadow,
      leadingWidth: 160,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceContainerHigh,
              backgroundImage: const NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAa23_PYcuRJDQnFNBkqZM6GT_DZCcFw6MCSEtnH_0C_C2K2qKGIKzsraYLbkvcYy3PZh7aD0oib-kPO3SGh4x0YFKCrk-mVTIaMj7skQ-qybDOHDOoH0T4CcxBNkjk_CX0EsDAwM3_R_qp_oGWovOc8LuIfhfZjsbicita5GXd4Wt10E1EqXYfzJxrDh3JV8TvN0CJYcnwF2HRe4DJRKdmmMjAxgHfS7j0Xo2WRXfM4pvUZ55eECT59hxRH_Yt5rVxEa7qsuAaCQ4',
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'College Plasma',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.onSurfaceVariant,
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ── Hero + Search ──────────────────────────────────────────────────────────
  Widget _buildHeroSearchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const Text(
            'Explore Your Campus',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: -0.7,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Discover departments, iconic spaces, and academic resources.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          // ── Search Bar ───────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.search,
                    color: AppColors.onSurfaceVariant, size: 22),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText:
                      'Search buildings, departments, facilities...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 14),
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Branches Carousel ──────────────────────────────────────────────────────
  // Uncomment and populate _branches list when you're ready to enable this.
  Widget _buildBranchesSection(BuildContext context) {
    return const SizedBox.shrink();
    // Replace with your BranchCard carousel when ready:
    // return Column(children: [ ... ]);
  }
}

// =============================================================================
//  _NavItem model
// =============================================================================
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}