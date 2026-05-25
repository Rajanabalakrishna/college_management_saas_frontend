import 'package:college_management_saas/Attendance/domain/attendance_entity.dart';
import 'package:college_management_saas/Attendance/presentation/providers/attendance_provider.dart';
import 'package:college_management_saas/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final attendance = ref.watch(attendanceProvider);
    final query = ref.watch(attendanceProvider.notifier).query;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            onPressed: () => _pickDate(query.date),
            icon: const Icon(Icons.calendar_month_rounded),
          ),
          IconButton(
            onPressed: () => _openFilters(query),
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            onPressed: () => ref.read(attendanceProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: attendance.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.read(attendanceProvider.notifier).refresh(),
        ),
        data: (day) {
          if (day.students.isEmpty) {
            return _EmptyState(
              onClear: () => ref.read(attendanceProvider.notifier).clearFilters(),
            );
          }

          return Column(
            children: [
              _Header(day: day),
              if (day.editable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => ref
                              .read(attendanceProvider.notifier)
                              .markAll(AttendanceStatus.present),
                          icon: const Icon(Icons.done_all_rounded),
                          label: const Text('All Present'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => ref
                              .read(attendanceProvider.notifier)
                              .markAll(AttendanceStatus.absent),
                          icon: const Icon(Icons.remove_done_rounded),
                          label: const Text('All Absent'),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.read(attendanceProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      day.editable ? 110 : 24,
                    ),
                    itemCount: day.students.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final student = day.students[index];
                      return _StudentTile(
                        student: student,
                        editable: day.editable && !_saving,
                        onChanged: (value) {
                          ref
                              .read(attendanceProvider.notifier)
                              .toggleStudent(student.id, value ?? false);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: attendance.maybeWhen(
        data: (day) {
          if (!day.editable) return const SizedBox.shrink();

          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.outlineVariant)),
              ),
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.save_rounded),
                label: Text(_saving ? 'Saving' : 'Save Today'),
              ),
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _pickDate(String currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _parseYmd(currentDate),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      await ref.read(attendanceProvider.notifier).setDate(picked);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(attendanceProvider.notifier).saveToday();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _openFilters(AttendanceQuery query) {
    final classController = TextEditingController(text: query.className ?? '');
    final secController = TextEditingController(text: query.sec ?? '');
    final branchController = TextEditingController(text: query.branch ?? '');
    final yearController = TextEditingController(text: query.year?.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter students',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                _FilterField(controller: classController, label: 'Class'),
                const SizedBox(height: 12),
                _FilterField(controller: secController, label: 'Section'),
                const SizedBox(height: 12),
                _FilterField(controller: branchController, label: 'Branch'),
                const SizedBox(height: 12),
                _FilterField(
                  controller: yearController,
                  label: 'Year',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(attendanceProvider.notifier).clearFilters();
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(attendanceProvider.notifier).applyFilters(
                            className: classController.text,
                            sec: secController.text,
                            branch: branchController.text,
                            year: int.tryParse(yearController.text.trim()),
                          );
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final AttendanceDay day;

  const _Header({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _prettyDate(day.date),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
              _ModePill(editable: day.editable),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total',
                  value: day.total.toString(),
                  icon: Icons.groups_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Present',
                  value: day.presentCount.toString(),
                  icon: Icons.check_circle_rounded,
                  color: AppColors.navActiveText,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Absent',
                  value: day.absentCount.toString(),
                  icon: Icons.cancel_rounded,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final bool editable;

  const _ModePill({required this.editable});

  @override
  Widget build(BuildContext context) {
    final color = editable ? AppColors.navActiveText : AppColors.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(editable ? Icons.edit_rounded : Icons.lock_rounded, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            editable ? 'Editable' : 'Read only',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final AttendanceStudent student;
  final bool editable;
  final ValueChanged<bool?> onChanged;

  const _StudentTile({
    required this.student,
    required this.editable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final present = student.status == AttendanceStatus.present;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: editable ? () => onChanged(!present) : null,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: present
                    ? AppColors.navActiveBackground
                    : AppColors.errorContainer,
                child: Icon(
                  present ? Icons.check_rounded : Icons.close_rounded,
                  color: present ? AppColors.navActiveText : AppColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (student.rollNo != null) _MiniMeta(student.rollNo!),
                        if (student.className != null) _MiniMeta(student.className!),
                        if (student.sec != null) _MiniMeta('Sec ${student.sec}'),
                        if (student.branch != null) _MiniMeta(student.branch!),
                      ],
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: present,
                onChanged: editable ? onChanged : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMeta extends StatelessWidget {
  final String text;

  const _MiniMeta(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;

  const _FilterField({
    required this.controller,
    required this.label,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fact_check_outlined, size: 54),
            const SizedBox(height: 12),
            const Text('No students found'),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onClear, child: const Text('Clear filters')),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 54),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

DateTime _parseYmd(String value) {
  final parts = value.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

String _prettyDate(String value) {
  final date = _parseYmd(value);
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}