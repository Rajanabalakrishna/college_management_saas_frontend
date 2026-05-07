import 'package:college_management_saas/college_places_section.dart';
import 'package:college_management_saas/static_sections/branches_section.dart';
import 'package:college_management_saas/theme/app_colors.dart';
import 'package:college_management_saas/widgets/branch_card.dart';
import 'package:college_management_saas/widgets/place_card.dart';
import 'package:flutter/material.dart';

class CampusExploreScreen extends StatefulWidget {
  const CampusExploreScreen({super.key});

  @override
  State<CampusExploreScreen> createState() => _CampusExploreScreenState();
}

class _CampusExploreScreenState extends State<CampusExploreScreen> {
  int _selectedNavIndex = 2; // "Explore" is active by default

  // static const _branches = [
  //   BranchData(
  //     imageUrl:
  //     'https://lh3.googleusercontent.com/aida-public/AB6AXuCRqUYkvrycll6kqspHqwSScugJAHrL8XNP7n_ceT9jF_QeOsV1zf80SViAtOx2kpUIwtivL1a4NHn_Ca1eDaGV87UsIT5ZksWEqQz0C_0WwmXZqiFIl7h2IIaRh29WYiJMZgx7KpnR1HvwqQGFzocuvIhZK-P0bLgkajeXsG5km3KhOjBPNKiJerJSsHvjcngJ_Km1UcQKhV2ZXQbN_0_bqEy5ukTvy_qHwkqqqryXFP5tENZxWOJaDPJyn5KMfIJ_gaGFWmkLZ8w',
  //     category: 'Technology',
  //     title: 'Computer Science',
  //     description:
  //     'Pioneering software engineering, artificial intelligence, and quantum computing.',
  //     isTopRated: true,
  //   ),
  //   BranchData(
  //     imageUrl:
  //     'https://lh3.googleusercontent.com/aida-public/AB6AXuD9lxqA5Bid-jd4kAKlc5vfqKwxPQ5hhqHK0_YKjiiYsMdzFRZeC3OCngmWqvYSq0Wtcl_R5hAWRfvjsPLwxYpUJ03hnzhC37s501tVswxJcjDBsu9HVyNC43bpzD9IJlXI3Ff21jBHsx09iVA8LH5VCovX0DrDRXTZzxRLBU_15S2hx8J3j271v3rXy3smp_Nk7OegGxoQ8dMUJ2uj7-FbiM7X0mvedlL8tsAKLQGJeYzgK3X9nPAYhSkznckFM0LKTKocBkzfh8M',
  //     category: 'Engineering',
  //     title: 'Mechanical',
  //     description:
  //     'Focusing on thermodynamics, robotics, and advanced materials manufacturing.',
  //     isTopRated: false,
  //   ),
  //   BranchData(
  //     imageUrl:
  //     'https://lh3.googleusercontent.com/aida-public/AB6AXuC1dvFc_JmGfQsPEirXxiAF6DrMs5wwWoRus_D1Opz4qDZKpft7Y00pDfypgG36DGuDWnwTGUm_17syrwHkIAHpdh5AXfut_VW5jXxJoIj1wKf-hfhNV68ELQfceWZOOWQERJ8clfbRkzt7ezxOEK1t0WTGr9NLdYx-X_prFrBa_gHbTOlSNbxpdJccP_8UgNgoyTNFKlAnDEwf22Q2TmATPbcTNHkKZn1iaPi-zxIvc3FxufLmOJ6QiYS9hIUY-dYGyC1kVXgc0II',
  //     category: 'Infrastructure',
  //     title: 'Civil & Architecture',
  //     description:
  //     'Designing the future of sustainable urban environments and structural systems.',
  //     isTopRated: false,
  //   ),
  //   BranchData(
  //     imageUrl:
  //     'https://lh3.googleusercontent.com/aida-public/AB6AXuAZW2DEtSHq_gVbxyvrLTyjsHwmOKuyEHtDJe2iZXph3JY5BWy0sHSyTs3jVkE_eEH14vLX9qqfoLuvJAwtLkS3kiVG5c5oMjXdfHklj4fhPtSC5YBiK3ZohGT40UOD7wULTySiunkfSYTW7q_MlldjQwJXq-j0IS1aGJEgUfZJtem3YXUzszHcsTZ8ey1vXg1f8nnZTuLBbjGCGSYmWAOaV9E7_1qLxxT0JygEYaWYnVpLMwermQeTK6PdlbR9gsLsb6AU5ogBlbY',
  //     category: 'Sciences',
  //     title: 'Chemical',
  //     description:
  //     'Advancing research in pharmaceuticals, energy processing, and synthetic biology.',
  //     isTopRated: false,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Background Image ──────────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // ── Frosted/tinted overlay so content stays readable ──────────────
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.82),
            ),
          ),
          // ── Main Content ──────────────────────────────────────────────────
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
                  // const SizedBox(height: 40),
                  _buildBranchesSection(context),
                  // const SizedBox(height: 40),
                  //_buildCollegePlacesSection(context),
                  CollegePlacesSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Top App Bar ─────────────────────────────────────────────────────────────
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
            Expanded(
              child: const Text(
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

  // ── Hero + Search ───────────────────────────────────────────────────────────
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
          // Search Bar
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
                const Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 22),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search buildings, departments, facilities...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

  // ── Branches Carousel ───────────────────────────────────────────────────────
  Widget _buildBranchesSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // const Text(
              //   'Experience Our Branches',
              //   style: TextStyle(
              //     fontFamily: 'PlusJakartaSans',
              //     fontSize: 24,
              //     fontWeight: FontWeight.w700,
              //     color: AppColors.onSurface,
              //     letterSpacing: -0.3,
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {},
              //   style: TextButton.styleFrom(
              //     foregroundColor: AppColors.primary,
              //     padding: EdgeInsets.zero,
              //     minimumSize: Size.zero,
              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   ),
              //   child: const Text(
              //     'View all',
              //     style: TextStyle(
              //       fontFamily: 'PlusJakartaSans',
              //       fontSize: 13,
              //       fontWeight: FontWeight.w700,
              //       letterSpacing: 0.4,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // SizedBox(
        //   height: 330,
        //   child: ListView.separated(
        //     scrollDirection: Axis.horizontal,
        //     padding: const EdgeInsets.symmetric(horizontal: 24),
        //     itemCount: _branches.length,
        //     separatorBuilder: (_, __) => const SizedBox(width: 16),
        //     itemBuilder: (context, index) => BranchCard(data: _branches[index]),
        //   ),
        // ),
      ],
    );
  }

  // ── College Places (Bento Grid) ─────────────────────────────────────────────
  Widget _buildCollegePlacesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our College Places',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          // Feature Card — Library
          PlaceFeatureCard(
            imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBO758A3M-aFSUX6OgnC8nt5TDAnGZn3sKSMm2kvo1JQLURqMckoicV6ea1VWxGRhpqs4GI4S4jMc_HVfNFegoULueZ9YJcrgI0oBPB_0a71MJ7awDPtsF5bjaPycz_CCp6XEvd0myAcZS_29Lnykecv8qrbKRI6_M2NDY1aZf4ej-YGK--VXuC0tmRZuSmuZp6t3hPmpS78idCBqupU4iaPW4sDXrdJKLpMwwjE_t5twoY1Iuj19FwT7sdzcs9NiCEu-gTVAEldaU',
            tag: 'ACADEMIC HUB',
            tagIcon: Icons.local_library_outlined,
            title: 'Grand Memorial Library',
            description:
            'Over 2 million volumes, silent study atriums, and 24/7 access to digital archives for all enrolled students.',
          ),
          const SizedBox(height: 16),
          // Secondary Place Cards Row
          Row(
            children: [
              Expanded(
                child: PlaceSecondaryCard(
                  imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBYIXjlIc7iShl085Mo1ASDEAfaNOt-t6l19GhjNETcZ0Wprw_bJuLcJrLLKedO8RXfK5Rk2hwcTyAcRbbeIqlnYzqftKYqBduhabX3om_UPwwfxqNfMvTFisES5QYdHAYDz2vL1etxfOQjuElSDjegypJsz87dlBrzpJcI4TZTqyx_K_DKrFiNwWwRyL62UXs9IiS4DL70xFSL4TdjdXu1GazmWnLGdWH16bFSn84_Vp9h4oPtjjQR1GgYdysoWRhSKP3qc3SyHMc',
                  icon: Icons.local_cafe_outlined,
                  iconColor: AppColors.secondary,
                  title: 'The Quad Cafe',
                  description: 'Artisan coffee and collaboration.',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PlaceSecondaryCard(
                  imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuC8pPkVkVwuvQ-a7rCuvxb1EviBJwyM_KCQyJr9biwn-16YAEgga7gvOP-RiQ2kZq75xNzV7IWoz-BdhpaZVd3jSA8UI4xRtHfNUkQJHdSM-ZlyORgv313U3TbiyuwZ9R3NowL9WqOtF9wn8yP5ykzfPBQYUdasXxjMRIkZEbbApKASkZOw_02Juc-wu1KaJQa_jqpoSwuJT3MTaaGOyAPmQVTkQvK93JV8bXszL8VvwiTjC6xwibtG9BkAGtasb_2y8QaQiY9ah30',
                  icon: Icons.sports_basketball_outlined,
                  iconColor: AppColors.primary,
                  title: 'Athletics Center',
                  description: 'Fitness, courts, and team sports.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Update your _buildBottomNav method with this onTap logic:

  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.grid_view_outlined, label: 'Dashboard'),
      _NavItem(icon: Icons.account_balance_outlined, label: 'Depts'),
      _NavItem(icon: Icons.explore, label: 'Explore'),
      _NavItem(icon: Icons.forum_outlined, label: 'Social'),
    ];

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
            children: List.generate(items.length, (index) {
              final isActive = _selectedNavIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedNavIndex = index);

                  if (index == 1) {
                    // Route to MainShell when Depts is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainShell()),
                    );
                  } else if (index == 0) {
                    // Route to CollegePlacesSection when Dashboard is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CollegePlacesSection()),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.navActiveBackground : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index].icon,
                        color: isActive ? AppColors.navActiveText : AppColors.navInactiveText,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive ? AppColors.navActiveText : AppColors.navInactiveText,
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

class _NavItem {
  final IconData icon;


  final String label;
  const _NavItem({required this.icon, required this.label});
}