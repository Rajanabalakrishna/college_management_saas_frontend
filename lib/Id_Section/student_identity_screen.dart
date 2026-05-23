import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/auth_provider.dart';
import 'package:college_management_saas/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentIdentityScreen extends ConsumerStatefulWidget {
  const StudentIdentityScreen({super.key});

  @override
  ConsumerState<StudentIdentityScreen> createState() =>
      _StudentIdentityScreenState();
}

class _StudentIdentityScreenState extends ConsumerState<StudentIdentityScreen> {
  Offset _cardDrag = Offset.zero;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Student Identity',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _MessageState(
          icon: Icons.error_outline_rounded,
          title: 'Unable to load identity',
          message: error.toString(),
        ),
        data: (state) {
          final user = state.maybeWhen(
            authenticated: (user) => user,
            orElse: () => null,
          );

          if (user == null) {
            return const _MessageState(
              icon: Icons.badge_outlined,
              title: 'No student data found',
              message: 'Please login again to view your digital ID.',
            );
          }

          return _IdentityContent(
            user: user,
            cardDrag: _cardDrag,
            pressed: _pressed,
            onPanUpdate: (details) {
              setState(() {
                _cardDrag += details.delta;
                _cardDrag = Offset(
                  _cardDrag.dx.clamp(-60, 60),
                  _cardDrag.dy.clamp(-60, 60),
                );
              });
            },
            onPanEnd: () => setState(() => _cardDrag = Offset.zero),
            onPressChanged: (value) => setState(() => _pressed = value),
          );
        },
      ),
    );
  }
}

class _IdentityContent extends StatelessWidget {
  final User user;
  final Offset cardDrag;
  final bool pressed;
  final ValueChanged<DragUpdateDetails> onPanUpdate;
  final VoidCallback onPanEnd;
  final ValueChanged<bool> onPressChanged;

  const _IdentityContent({
    required this.user,
    required this.cardDrag,
    required this.pressed,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onPressChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 760;
    final maxCardWidth = isWide ? 380.0 : 350.0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            isWide ? 32 : 16,
            20,
            isWide ? 32 : 16,
            100,
          ),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: isWide
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: maxCardWidth,
                      child: _MainColumn(
                        user: user,
                        cardDrag: cardDrag,
                        pressed: pressed,
                        onPanUpdate: onPanUpdate,
                        onPanEnd: onPanEnd,
                        onPressChanged: onPressChanged,
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      child: _SidePanel(user: user),
                    ),
                  ],
                )
                    : _MainColumn(
                  user: user,
                  cardDrag: cardDrag,
                  pressed: pressed,
                  onPanUpdate: onPanUpdate,
                  onPanEnd: onPanEnd,
                  onPressChanged: onPressChanged,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MainColumn extends StatelessWidget {
  final User user;
  final Offset cardDrag;
  final bool pressed;
  final ValueChanged<DragUpdateDetails> onPanUpdate;
  final VoidCallback onPanEnd;
  final ValueChanged<bool> onPressChanged;

  const _MainColumn({
    required this.user,
    required this.cardDrag,
    required this.pressed,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onPressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VerifiedBadge(isActive: user.isActive),
        const SizedBox(height: 20),
        GestureDetector(
          onPanUpdate: onPanUpdate,
          onPanEnd: (_) => onPanEnd(),
          onTapDown: (_) => onPressChanged(true),
          onTapCancel: () => onPressChanged(false),
          onTapUp: (_) => onPressChanged(false),
          child: RepaintBoundary(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: _cardTransform(cardDrag, pressed),
              transformAlignment: Alignment.center,
              child: _StudentIdCard(user: user),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _ActionButton(
          icon: Icons.picture_as_pdf_rounded,
          label: 'Download PDF',
          filled: true,
          onTap: () => _showTodo(context, 'PDF download will be added here.'),
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: Icons.share_rounded,
          label: 'Share Digital ID',
          filled: false,
          onTap: () => _showTodo(context, 'Share action will be added here.'),
        ),
      ],
    );
  }

  Matrix4 _cardTransform(Offset drag, bool pressed) {
    final rotateY = drag.dx / 900;
    final rotateX = -drag.dy / 900;

    return Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      ..scale(pressed ? 0.985 : 1.0);
  }

  void _showTodo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final bool isActive;

  const _VerifiedBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFF3BF) : AppColors.errorContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? const Color(0xFFFFD43B) : AppColors.error,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.verified_rounded : Icons.pending_outlined,
            size: 18,
            color: isActive ? const Color(0xFF745C00) : AppColors.error,
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? 'IDENTITY VERIFIED' : 'IDENTITY PENDING',
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: isActive ? const Color(0xFF745C00) : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentIdCard extends StatelessWidget {
  final User user;

  const _StudentIdCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18002147),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _CardHeader(user: user),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, -42),
                  child: _ProfilePhoto(user: user),
                ),
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Column(
                    children: [
                      Text(
                        _display(user.fullName),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_roleTitle(user.role)} ID - Academic Year ${DateTime.now().year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _InfoGrid(user: user),
                      const SizedBox(height: 24),
                      _QrBlock(user: user),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 8, color: const Color(0xFFFED65B)),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final User user;

  const _CardHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: const BoxDecoration(
        color: Color(0xFF002147),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -24,
            child: Icon(
              Icons.school_rounded,
              size: 118,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Plasma Group',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'OF COLLEGES',
                  style: TextStyle(
                    color: Color(0xFFD6E3FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  final User user;

  const _ProfilePhoto({required this.user});

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.imageUrl?.trim();

    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.surfaceContainerLowest,
          width: 5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => _InitialsAvatar(user: user),
        errorWidget: (_, __, ___) => _InitialsAvatar(user: user),
      )
          : _InitialsAvatar(user: user),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final User user;

  const _InitialsAvatar({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        _initials(user.fullName),
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final User user;

  const _InfoGrid({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Roll No',
                  value: _display(user.rollNo),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  label: 'Department',
                  value: _display(user.branch?.toUpperCase()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Class',
                  value: _classText(user),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  label: 'Batch',
                  value: _batchText(user),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrBlock extends StatelessWidget {
  final User user;

  const _QrBlock({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 122,
          height: 122,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: CustomPaint(
            painter: _IdentityPatternPainter(
              seed: _seedFrom('${user.id}-${user.email}-${user.collegeId}'),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SCAN FOR ACCESS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}

class _SidePanel extends StatelessWidget {
  final User user;

  const _SidePanel({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Identity Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(icon: Icons.email_outlined, label: 'Email', value: user.email),
          _DetailRow(icon: Icons.person_outline, label: 'Role', value: _roleTitle(user.role)),
          _DetailRow(icon: Icons.school_outlined, label: 'Year', value: user.year == null ? 'Not assigned' : 'Year ${user.year}'),
          _DetailRow(icon: Icons.groups_outlined, label: 'Section', value: _display(user.sec)),
          _DetailRow(icon: Icons.verified_user_outlined, label: 'Status', value: user.isActive ? 'Active' : 'Inactive'),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 21, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = filled ? const Color(0xFF002147) : Colors.transparent;
    final foreground = filled ? Colors.white : const Color(0xFF002147);

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF002147)),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: foreground, size: 21),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
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

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44, color: AppColors.primary),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdentityPatternPainter extends CustomPainter {
  final int seed;

  const _IdentityPatternPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = false;
    final cell = size.width / 21;

    paint.color = Colors.white;
    canvas.drawRect(Offset.zero & size, paint);

    _drawFinder(canvas, paint, cell, 0, 0);
    _drawFinder(canvas, paint, cell, 14, 0);
    _drawFinder(canvas, paint, cell, 0, 14);

    var value = seed;
    for (var y = 0; y < 21; y++) {
      for (var x = 0; x < 21; x++) {
        final inFinder =
            (x < 7 && y < 7) || (x > 13 && y < 7) || (x < 7 && y > 13);
        if (inFinder) continue;

        value = (value * 1103515245 + 12345) & 0x7fffffff;
        final draw = value % 5 == 0 || value % 7 == 0;

        if (draw) {
          paint.color = const Color(0xFF0B1C30);
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  void _drawFinder(
      Canvas canvas,
      Paint paint,
      double cell,
      int startX,
      int startY,
      ) {
    paint.color = const Color(0xFF0B1C30);
    canvas.drawRect(
      Rect.fromLTWH(startX * cell, startY * cell, 7 * cell, 7 * cell),
      paint,
    );

    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH((startX + 1) * cell, (startY + 1) * cell, 5 * cell, 5 * cell),
      paint,
    );

    paint.color = const Color(0xFF0B1C30);
    canvas.drawRect(
      Rect.fromLTWH((startX + 2) * cell, (startY + 2) * cell, 3 * cell, 3 * cell),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _IdentityPatternPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}

String _display(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return 'Not assigned';
  return text;
}

String _classText(User user) {
  final className = user.className?.trim();
  final section = user.sec?.trim();

  if ((className == null || className.isEmpty) &&
      (section == null || section.isEmpty)) {
    return 'Not assigned';
  }

  if (className != null && className.isNotEmpty && section != null && section.isNotEmpty) {
    return '$className - $section';
  }

  return className?.isNotEmpty == true ? className! : section!;
}

String _batchText(User user) {
  if (user.startingYear != null && user.endingYear != null) {
    return '${user.startingYear} - ${user.endingYear}';
  }

  if (user.year != null) return 'Year ${user.year}';

  return '${user.createdAt.year}';
}

String _roleTitle(String role) {
  final clean = role.trim();
  if (clean.isEmpty) return 'Student';
  return clean[0].toUpperCase() + clean.substring(1).toLowerCase();
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();

  if (parts.isEmpty) return 'ST';
  if (parts.length == 1) return parts.first.substring(0, math.min(2, parts.first.length)).toUpperCase();

  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

int _seedFrom(String value) {
  var seed = 17;
  for (final code in value.codeUnits) {
    seed = (seed * 31 + code) & 0x7fffffff;
  }
  return seed;
}