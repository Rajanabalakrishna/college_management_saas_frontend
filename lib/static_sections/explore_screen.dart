import 'package:college_management_saas/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
 // your AppColors file

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

class FeatureItem {
  final IconData icon;
  final String label;
  final Color? badgeColor;
  final int? badgeCount;

  const FeatureItem({
    required this.icon,
    required this.label,
    this.badgeColor,
    this.badgeCount,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// STATIC DATA
// ─────────────────────────────────────────────────────────────────────────────

class _ExploreData {
  static const List<FeatureItem> features = [
    FeatureItem(icon: Icons.calendar_today_outlined,           label: 'Lecture'),
    FeatureItem(icon: Icons.trending_up_outlined,              label: 'Attendance'),
    FeatureItem(icon: Icons.menu_book_outlined,                label: 'Syllabus'),
    FeatureItem(icon: Icons.schedule_outlined,                 label: 'Time Table'),
    FeatureItem(icon: Icons.people_outline,                    label: 'Faculties'),
    FeatureItem(icon: Icons.quiz_outlined,                     label: 'Exams'),
    FeatureItem(icon: Icons.bar_chart_outlined,                label: 'Results'),
    FeatureItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Fees',
      badgeColor: AppColors.error,
      badgeCount: 1,
    ),
    FeatureItem(icon: Icons.checklist_outlined,                label: 'Attendance\nRequest'),
    FeatureItem(icon: Icons.receipt_long_outlined,             label: 'Fee Receipt'),
    FeatureItem(icon: Icons.badge_outlined,                    label: 'ID Card'),
    FeatureItem(
      icon: Icons.directions_bus_outlined,
      label: 'Bus Track',
      badgeColor: AppColors.error,
      badgeCount: 1,
    ),
    FeatureItem(icon: Icons.notifications_outlined,            label: 'Notices'),
    FeatureItem(icon: Icons.assignment_outlined,               label: 'Assignments'),
    FeatureItem(icon: Icons.library_books_outlined,            label: 'Library'),
    FeatureItem(icon: Icons.emoji_events_outlined,             label: 'Events'),
  ];

  // Grouped for section-based layout
  static const Map<String, List<int>> sections = {
    'Academics': [0, 1, 2, 3],
    'People & Exams': [4, 5, 6, 7],
    'Requests & Docs': [8, 9, 10, 11],
    'Info & Activities': [12, 13, 14, 15],
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN EXPLORE SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────────
          _ExploreAppBar(),

          // ── Quick Access Banner ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: _QuickAccessBanner(),
          ),

          // ── Sectioned Feature Grid ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionedFeatureList(),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXPLORE APP BAR (SliverAppBar)
// ─────────────────────────────────────────────────────────────────────────────

class _ExploreAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 120,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.outlineVariant,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
          ),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left: Title block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onBackground,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'All your college services in one place',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right: Notification button
                    _NotificationButton(),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Text(
            'Explore',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.onBackground,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          _NotificationButton(),
        ],
      ),
      titleSpacing: 20,
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.onSurfaceVariant,
            size: 22,
          ),
        ),
        Positioned(
          top: -3,
          right: -3,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUICK ACCESS BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _QuickAccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Tip 💡',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Attendance below 75%?\nApply for an attendance request now.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Apply Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right: icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.checklist_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTIONED FEATURE LIST
// ─────────────────────────────────────────────────────────────────────────────

class _SectionedFeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _ExploreData.sections.entries.map((entry) {
        final sectionTitle = entry.key;
        final indices = entry.value;
        final items = indices.map((i) => _ExploreData.features[i]).toList();

        return _FeatureSection(title: sectionTitle, items: items);
      }).toList(),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  final String title;
  final List<FeatureItem> items;

  const _FeatureSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4-column grid for this section
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
              childAspectRatio: 0.80,
            ),
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: _FeatureTile(item: items[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FEATURE TILE
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureTile extends StatelessWidget {
  final FeatureItem item;
  const _FeatureTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: route to feature screen
        },
        splashColor: AppColors.primaryContainer,
        highlightColor: AppColors.primaryContainer.withValues(alpha: 0.4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.outlineVariant,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon box with optional badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      item.icon,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  if (item.badgeCount != null)
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: item.badgeColor ?? AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${item.badgeCount}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}