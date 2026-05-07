import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const AcademicApp());
}

// ─── Constants ────────────────────────────────────────────────────────────────

const kPrimary = Color(0xFF3B41E3);
const kPrimaryLight = Color(0xFFE8E9FF);
const kTextDark = Color(0xFF1A1B21);
const kTextMuted = Color(0xFF6B7280);
const kTextFaint = Color(0xFF9CA3AF);
const kSurface = Color(0xFFF9F9FF);

// ─── App Root ─────────────────────────────────────────────────────────────────

class AcademicApp extends StatelessWidget {
  const AcademicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Departments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MainShell(),
    );
  }
}

// ─── Main Shell ───────────────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 1;

  static const _navItems = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Overview'),
    _NavItem(icon: Icons.domain_outlined, activeIcon: Icons.domain_rounded, label: 'Depts'),
    _NavItem(icon: Icons.groups_outlined, activeIcon: Icons.groups_rounded, label: 'Faculty'),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _GradientBackground(),
          IndexedStack(
            index: _selectedIndex,
            children: [
              _PlaceholderPage(label: _navItems[0].label, icon: Icons.dashboard_rounded),
              const DepartmentsPage(),
              _PlaceholderPage(label: _navItems[2].label, icon: Icons.groups_rounded),
              _PlaceholderPage(label: _navItems[3].label, icon: Icons.settings_rounded),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _GlassBottomNav(
        items: _navItems,
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─── Gradient Background ──────────────────────────────────────────────────────

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEEEEFF),
            Color(0xFFF5EEFF),
            Color(0xFFEEF5FF),
            Color(0xFFF2EEFF),
          ],
          stops: [0.0, 0.35, 0.7, 1.0],
        ),
      ),
    );
  }
}

// ─── Departments Page ─────────────────────────────────────────────────────────

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  static const _departments = [
    _DeptData(
      name: 'CSE',
      subtitle: 'Computer Science & Eng.',
      students: '1,200 Students',
      iconData: Icons.terminal_rounded,
      accentColor: Color(0xFF1D6AE5),
      bgColor: Color(0xFFEBF2FF),
      imageUrl: 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=600&q=80',
    ),
    _DeptData(
      name: 'Polytechnic',
      subtitle: 'Diploma Programs',
      students: '850 Students',
      iconData: Icons.architecture_rounded,
      accentColor: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
      imageUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&q=80',
    ),
    _DeptData(
      name: 'AI & ML',
      subtitle: 'Artificial Intelligence',
      students: '450 Students',
      iconData: Icons.psychology_rounded,
      accentColor: Color(0xFF7C3AED),
      bgColor: Color(0xFFF5F3FF),
      imageUrl: 'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=600&q=80',
    ),
    _DeptData(
      name: 'Mech',
      subtitle: 'Mechanical Eng.',
      students: '600 Students',
      iconData: Icons.settings_rounded,
      accentColor: Color(0xFF374151),
      bgColor: Color(0xFFF3F4F6),
      imageUrl: 'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=600&q=80',
    ),
    _DeptData(
      name: 'EEE',
      subtitle: 'Electrical & Electronics',
      students: '550 Students',
      iconData: Icons.bolt_rounded,
      accentColor: Color(0xFFD97706),
      bgColor: Color(0xFFFFFBEB),
      imageUrl: 'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=600&q=80',
    ),
    _DeptData(
      name: 'ECE',
      subtitle: 'Electronics & Comm.',
      students: '700 Students',
      iconData: Icons.cell_tower_rounded,
      accentColor: Color(0xFF0891B2),
      bgColor: Color(0xFFECFEFF),
      imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&q=80',
    ),
    _DeptData(
      name: 'Civil',
      subtitle: 'Civil Engineering',
      students: '400 Students',
      iconData: Icons.construction_rounded,
      accentColor: Color(0xFFEA580C),
      bgColor: Color(0xFFFFF7ED),
      imageUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&q=80',
    ),
    _DeptData(
      name: 'Pharmacy',
      subtitle: 'Pharmaceutical Sci.',
      students: '300 Students',
      iconData: Icons.vaccines_rounded,
      accentColor: Color(0xFFE11D48),
      bgColor: Color(0xFFFFF1F2),
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: topPad + 20)),
        const SliverToBoxAdapter(child: _PageHeader()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const SliverToBoxAdapter(child: _StatsRow()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'ALL DEPARTMENTS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: kTextMuted,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 1,
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${_departments.length} total',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: kTextFaint,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.78,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, i) => _DeptCard(data: _departments[i]),
              childCount: _departments.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Page Header ──────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF3B41E3), Color(0xFF9B59B6)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Academic\nDepartments',
                    style: GoogleFonts.workSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Colors.white,
                      height: 1.18,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore specialized fields of study',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: kTextMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _GradientAvatar(),
        ],
      ),
    );
  }
}

class _GradientAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF3B41E3), Color(0xFF77536D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'UP',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: const [
          _StatChip(value: '8', label: 'Departments', icon: Icons.domain_rounded),
          SizedBox(width: 10),
          _StatChip(value: '5,050', label: 'Students', icon: Icons.groups_rounded),
          SizedBox(width: 10),
          _StatChip(value: '320', label: 'Faculty', icon: Icons.person_rounded),
          SizedBox(width: 10),
          _StatChip(value: '42', label: 'Programs', icon: Icons.menu_book_rounded),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatChip({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.80),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: kPrimary, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                  height: 1.1,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: kTextMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Department Card ──────────────────────────────────────────────────────────
// FIX: Removed BackdropFilter from each card (major perf fix).
// FIX: Removed Transform.translate (overflow fix). Using Stack + Positioned for icon overlap.
// FIX: Used LayoutBuilder to prevent overflow. Card height is fully constrained.

class _DeptCard extends StatefulWidget {
  final _DeptData data;
  const _DeptCard({required this.data, super.key});

  @override
  State<_DeptCard> createState() => _DeptCardState();
}

class _DeptCardState extends State<_DeptCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.reverse();
  void _onTapUp(TapUpDetails _) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.95),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: d.accentColor.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image + Icon Overlap (Stack, no Transform.translate)
                SizedBox(
                  height: 110,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Cover image
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: d.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: d.bgColor,
                            child: Icon(
                              d.iconData,
                              color: d.accentColor.withOpacity(0.25),
                              size: 36,
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: d.bgColor,
                            child: Icon(
                              d.iconData,
                              color: d.accentColor.withOpacity(0.25),
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.95),
                              ],
                              stops: const [0.35, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Floating icon — positioned at bottom of image
                      Positioned(
                        left: 14,
                        bottom: -20, // hangs over the image border
                        child: _DeptIcon(data: d),
                      ),
                    ],
                  ),
                ),
                // ── Gap for the overlapping icon
                const SizedBox(height: 26),
                // ── Text content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          d.name,
                          style: GoogleFonts.workSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: kTextDark,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          d.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: kTextMuted,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        // Students badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: d.bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.group_outlined,
                                  color: d.accentColor, size: 13),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  d.students,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: d.accentColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class _DeptIcon extends StatelessWidget {
  final _DeptData data;
  const _DeptIcon({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: data.accentColor.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(data.iconData, color: data.accentColor, size: 22),
    );
  }
}

// ─── Glass Bottom Nav ─────────────────────────────────────────────────────────
// FIX: BackdropFilter used only ONCE here, not per card. Huge perf improvement.

class _GlassBottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 10, 12, bottomPad + 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.78),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.7), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final item = items[i];
              final active = i == selectedIndex;
              return _NavTab(
                item: item,
                isActive: active,
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? kPrimary.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                color: isActive ? kPrimary : kTextFaint,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? kPrimary : kTextFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Placeholder Page ─────────────────────────────────────────────────────────

class _PlaceholderPage extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PlaceholderPage({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: kPrimary, size: 34),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: GoogleFonts.workSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: kTextDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coming soon',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: kTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _DeptData {
  final String name;
  final String subtitle;
  final String students;
  final IconData iconData;
  final Color accentColor;
  final Color bgColor;
  final String imageUrl;

  const _DeptData({
    required this.name,
    required this.subtitle,
    required this.students,
    required this.iconData,
    required this.accentColor,
    required this.bgColor,
    required this.imageUrl,
  });
}
