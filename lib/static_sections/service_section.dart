import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




// ─── THEME ───────────────────────────────────────────────────────────────────

class AppTheme {
  static const Color primary = Color(0xFF24389C);
  static const Color primaryContainer = Color(0xFF3F51B5);
  static const Color secondary = Color(0xFF785900);
  static const Color secondaryContainer = Color(0xFFFDC003);
  static const Color tertiary = Color(0xFF004C44);
  static const Color tertiaryContainer = Color(0xFF00665C);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onSurface = Color(0xFF1A1C1C);
  static const Color onSurfaceVariant = Color(0xFF454652);
  static const Color background = Color(0xFFF9F9F9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F3);
  static const Color surfaceContainer = Color(0xFFEEEEEE);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color outline = Color(0xFF757684);
  static const Color outlineVariant = Color(0xFFC5C5D4);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryContainer,
      secondary: secondary,
      secondaryContainer: secondaryContainer,
      tertiary: tertiary,
      tertiaryContainer: tertiaryContainer,
      error: error,
      surface: background,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
    ),
    fontFamily: 'WorkSans',
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceContainerLowest,
      elevation: 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: primary),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceContainerLowest,
      indicatorColor: Color(0xFFEEF0FF),
      labelTextStyle: WidgetStatePropertyAll(TextStyle(
        fontFamily: 'WorkSans',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      )),
      height: 64,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFBAC3FF),
      primaryContainer: const Color(0xFF293CA0),
      secondary: const Color(0xFFFFDF9E),
      secondaryContainer: const Color(0xFF5B4300),
      tertiary: const Color(0xFF85F6E5),
      tertiaryContainer: const Color(0xFF004D45),
      error: const Color(0xFFFFB4AB),
      surface: const Color(0xFF121314),
      onSurface: const Color(0xFFE2E2E2),
      onSurfaceVariant: const Color(0xFFC5C5D4),
      outline: const Color(0xFF8F9099),
      outlineVariant: const Color(0xFF454652),
    ),
    fontFamily: 'WorkSans',
    scaffoldBackgroundColor: const Color(0xFF121314),
  );
}

// ─── HOME SCREEN ─────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'HOME'),
    _NavItem(icon: Icons.school_rounded, label: 'ACADEMICS'),
    _NavItem(icon: Icons.notifications_rounded, label: 'ALERTS', badge: true),
    _NavItem(icon: Icons.account_circle_rounded, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(),
      body: _selectedIndex == 0
          ? const _DashboardBody()
          : _PlaceholderBody(label: _navItems[_selectedIndex].label),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: () {},
        tooltip: 'Menu',
      ),
      title: const Text('Academic Excellence'),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.outlineVariant,
                  width: 1.5,
                ),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBfK-I7mz3kTZReh_KWVeNnrH8hCQBhvDy75dZsEvCSoIO7wVcd9SjhbdIIq6c4MyWEmUBT6E7J33IY6ytSIpC3jkFjonCyv2quR5oxV_QN8zXu3QmKrXGUj1VSnqybIvsHYe5W8-8NdoPi4dtD-fC-uHM-GAb0elv2GV6PgL105bDtJWB2Xu7mJlexoAv3D_uR3em1Rvn_3rDHuOUyy5UNs2DIqXDd3swq7HmNpg3htfbPo9dzbxilUiVMFCyhKclSbhE3v5jdTbg0',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppTheme.outlineVariant.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: AppTheme.outlineVariant.withOpacity(0.4),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final selected = _selectedIndex == i;
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = i),
                  splashColor: AppTheme.primary.withOpacity(0.08),
                  highlightColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppTheme.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                item.icon,
                                size: 22,
                                color: selected
                                    ? AppTheme.primary
                                    : AppTheme.onSurfaceVariant,
                              ),
                            ),
                            if (item.badge)
                              Positioned(
                                top: -1,
                                right: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
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
  final bool badge;
  const _NavItem({required this.icon, required this.label, this.badge = false});
}

// ─── DASHBOARD BODY ──────────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Hero Image
        SliverToBoxAdapter(child: _HeroBanner()),
        // Profile Card (overlapping hero)
        SliverToBoxAdapter(child: _ProfileCard()),
        // Quick Stats
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        const SliverToBoxAdapter(child: _StatsRow()),
        // Services Section
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(child: _SectionHeader(title: 'Quick Services')),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(child: _ServicesGrid()),
        ),
        // Recent Activity
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(child: _SectionHeader(title: 'Recent Activity')),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(child: _RecentActivityList()),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ─── HERO BANNER ─────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA1ZIB47jI7JcuNKrsaiw9sRHce8ILCA7QkzFmS0lQYjW0V8YR3sxr3gvtbrEjWnN7c05b3UmKzt3ECNAZdLzx7UGe99lvCkJVGf9G2V8lljNLgaLsDvXV18dWDPmhrhqeFyQEhlhBe6WZKSwxSeFyMS3Hh25ZEVgubnM7WXI4gqc5kq9-ulqXvejyWVe41oaz1Qbv0Q8e9yzOxSxQXrQCB6JdVj5d8utc2JlOznSmwFimbK-Glf3m8HsE3B4cuZ5j3hIdib_BYzcz0',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF24389C), Color(0xFF004C44)],
                ),
              ),
            ),
          ),
          // Gradient overlay
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xD9F9F9F9)],
                stops: [0.4, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PROFILE CARD ────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF24389C).withOpacity(0.10),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.surfaceContainerLowest,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBYsIS-IRLdJ5FWmdY1nwf1QNmDkhxzNNyxi-9THLFNircvuaOq0Zj-scqPQZkDAI8sP4fXYPNP1NkcaLcZS0_C_7MmqSucPBBh_TevZenaeF_UXlDuHY9GL7kLtN7lEOV0FQkWjS_ZcTAgN_KEZ9pEV8bGpNPlcYCDpqycp1Vawn0bAnz7opruxb7a43KvW4SUmrv1Swob_FCK1i1J1YraAK3MOBmsUJz9g_rkZYYdI6Kz1bmE5bWJFuh5VlCsPVCg6F1f_wKnaBIQ',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'D. Madhu',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: const [
                        _ProfileChip(
                          label: 'CS Branch',
                          color: AppTheme.primary,
                          isAccent: true,
                        ),
                        _ProfileChip(label: 'Sem 5', color: AppTheme.onSurfaceVariant),
                        _ProfileChip(label: 'ID: 62', color: AppTheme.onSurfaceVariant),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isAccent;

  const _ProfileChip({
    required this.label,
    required this.color,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAccent
            ? AppTheme.primary.withOpacity(0.08)
            : AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: isAccent
            ? Border.all(color: AppTheme.primary.withOpacity(0.2), width: 1)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── STATS ROW ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Expanded(child: _StatCard(value: '82%', label: 'Attendance', color: AppTheme.tertiary, icon: Icons.how_to_reg_rounded)),
          SizedBox(width: 10),
          Expanded(child: _StatCard(value: '7.8', label: 'CGPA', color: AppTheme.primary, icon: Icons.military_tech_rounded)),
          SizedBox(width: 10),
          Expanded(child: _StatCard(value: '3', label: 'Pending', color: AppTheme.error, icon: Icons.assignment_late_rounded)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurface,
            letterSpacing: -0.2,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'See all',
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── SERVICES GRID ───────────────────────────────────────────────────────────

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid();

  static const List<_ServiceItem> _services = [
    _ServiceItem(icon: Icons.menu_book_rounded, label: 'Materials', color: AppTheme.primary),
    _ServiceItem(icon: Icons.how_to_reg_rounded, label: 'Attendance', color: AppTheme.tertiary),
    _ServiceItem(icon: Icons.subject_rounded, label: 'Syllabus', color: AppTheme.primary),
    _ServiceItem(icon: Icons.calendar_month_rounded, label: 'Timetable', color: Color(0xFF785900)),
    _ServiceItem(icon: Icons.groups_rounded, label: 'Faculties', color: AppTheme.primary),
    _ServiceItem(icon: Icons.quiz_rounded, label: 'Exams', color: AppTheme.error),
    _ServiceItem(icon: Icons.military_tech_rounded, label: 'Results', color: AppTheme.tertiary),
    _ServiceItem(icon: Icons.payments_rounded, label: 'Fees', color: Color(0xFF785900)),
    _ServiceItem(icon: Icons.assignment_rounded, label: 'Assignments', color: AppTheme.primary),
    _ServiceItem(icon: Icons.badge_rounded, label: 'ID Card', color: AppTheme.onSurfaceVariant),
    _ServiceItem(icon: Icons.directions_bus_rounded, label: 'Bus Track', color: AppTheme.tertiary),
    _ServiceItem(icon: Icons.more_horiz_rounded, label: 'More', color: AppTheme.primary),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.88,
      ),
      itemCount: _services.length,
      itemBuilder: (_, i) => _ServiceTile(item: _services[i]),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final Color color;

  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _ServiceTile extends StatefulWidget {
  final _ServiceItem item;

  const _ServiceTile({required this.item});

  @override
  State<_ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<_ServiceTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        HapticFeedback.lightImpact();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.outlineVariant.withOpacity(0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.item.color.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.item.icon,
                  size: 22,
                  color: widget.item.color,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurfaceVariant,
                    letterSpacing: 0.1,
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

// ─── RECENT ACTIVITY ─────────────────────────────────────────────────────────

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  static const List<_ActivityItem> _items = [
    _ActivityItem(
      icon: Icons.assignment_turned_in_rounded,
      title: 'Assignment Submitted',
      subtitle: 'Data Structures — Unit 3',
      time: '2h ago',
      color: AppTheme.tertiary,
    ),
    _ActivityItem(
      icon: Icons.how_to_reg_rounded,
      title: 'Attendance Marked',
      subtitle: 'Operating Systems — 9:00 AM',
      time: 'Today',
      color: AppTheme.primary,
    ),
    _ActivityItem(
      icon: Icons.notifications_active_rounded,
      title: 'Exam Schedule Released',
      subtitle: 'Internal Assessment — Nov 10',
      time: 'Yesterday',
      color: AppTheme.error,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineVariant.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_items.length, (i) {
          return Column(
            children: [
              _ActivityTile(item: _items[i]),
              if (i < _items.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppTheme.outlineVariant.withOpacity(0.3),
                  indent: 66,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;

  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 20, color: item.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.time,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PLACEHOLDER SCREEN ──────────────────────────────────────────────────────

class _PlaceholderBody extends StatelessWidget {
  final String label;

  const _PlaceholderBody({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 48,
            color: AppTheme.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            '$label coming soon',
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
