import 'dart:ui';
import 'package:flutter/material.dart';

class EduGlassScreen extends StatelessWidget {
  const EduGlassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// APP BAR
            SliverAppBar(
              pinned: true,
              floating: true,
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0.7),
              expandedHeight: 80,
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.15),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/150?img=12',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'EduGlass',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF006194),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFF006194),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// BODY
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    /// SEARCH BAR
                    _SearchBar(),

                    const SizedBox(height: 20),

                    /// CATEGORY
                    SizedBox(
                      height: 46,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: const [
                          CategoryChip(
                            title: 'Engineering',
                            isSelected: true,
                          ),
                          SizedBox(width: 12),
                          CategoryChip(title: 'Polytechnic'),
                          SizedBox(width: 12),
                          CategoryChip(title: 'Pharmacy'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// ENGINEERING
                    const SectionHeader(
                      title: 'Engineering Materials',
                    ),

                    const SizedBox(height: 16),

                    const MaterialCard(
                      icon: Icons.square_outlined,
                      iconColor: Color(0xFF006194),
                      title: 'Thermodynamics Notes',
                      subtitle: 'Dr. Sarah Jenkins • Unit 1-4',
                      tag: 'PDF',
                      info: '2.4 MB',
                      actionIcon: Icons.download,
                    ),

                    const SizedBox(height: 16),

                    const MaterialCard(
                      icon: Icons.architecture,
                      iconColor: Color(0xFF712AE2),
                      title: 'Structural Analysis',
                      subtitle: 'Prof. Michael Chen • Tutorial',
                      tag: 'VIDEO',
                      info: '45 Mins',
                      actionIcon: Icons.play_arrow,
                      outlinedButton: true,
                    ),

                    const SizedBox(height: 32),

                    /// PHARMACY
                    const SectionHeader(
                      title: 'Pharmacy Resources',
                    ),

                    const SizedBox(height: 16),

                    const MaterialCard(
                      icon: Icons.medical_services_outlined,
                      iconColor: Color(0xFF006399),
                      title: 'Pharmacology Basics',
                      subtitle: 'Dr. Elena Rodriguez • Sem III',
                      tag: 'SLIDES',
                      info: '12 MB',
                      actionIcon: Icons.download,
                    ),

                    const SizedBox(height: 32),

                    /// FEATURED BANNER
                    const WebinarBanner(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: const GlassBottomNavBar(),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search materials, subjects...',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF006194)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: const Color(0xFF006194).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ]
            : [],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              color: Color(0xFF006194),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class MaterialCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String tag;
  final String info;
  final IconData actionIcon;
  final bool outlinedButton;

  const MaterialCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.info,
    required this.actionIcon,
    this.outlinedButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 16),

                /// CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.15),
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: iconColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            info,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                /// ACTION BUTTON
                Container(
                  decoration: BoxDecoration(
                    color: outlinedButton
                        ? Colors.transparent
                        : const Color(0xFF006194),
                    borderRadius: BorderRadius.circular(14),
                    border: outlinedButton
                        ? Border.all(
                      color: const Color(0xFF006194),
                    )
                        : null,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      actionIcon,
                      color: outlinedButton
                          ? const Color(0xFF006194)
                          : Colors.white,
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
}

class WebinarBanner extends StatelessWidget {
  const WebinarBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 190,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1522202176988-66273c2fd55f',
              fit: BoxFit.cover,
              cacheWidth: 1200,
              filterQuality: FilterQuality.low,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF006194).withOpacity(0.95),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text(
                    'UPCOMING WEBINAR',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'AI in Engineering 2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Guest Lecture by Dr. Aris Thorne',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                      const Color(0xFF006194),
                      elevation: 0,
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Register Now',
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
}

class GlassBottomNavBar extends StatelessWidget {
  const GlassBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),
          child: Container(
            height: 78,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: const [
                BottomNavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                ),
                BottomNavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Library',
                  active: true,
                ),
                BottomNavItem(
                  icon: Icons.bookmark_outline,
                  label: 'Saved',
                ),
                BottomNavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFCCE5FF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active
                ? const Color(0xFF004B74)
                : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: active
                  ? const Color(0xFF004B74)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}