

import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';
import 'package:college_management_saas/Assignments/presentation/providers/assignment_provider.dart';
import 'package:college_management_saas/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignmentsScreen extends ConsumerStatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  ConsumerState<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends ConsumerState<AssignmentsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 240) {
        ref.read(assignmentsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assignments = ref.watch(assignmentsProvider);
    final query = ref.watch(assignmentsProvider.notifier).query;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          IconButton(
            onPressed: () => ref.read(assignmentsProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFilters(context, query),
        icon: const Icon(Icons.tune_rounded),
        label: const Text('Filter'),
      ),
      body: assignments.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.read(assignmentsProvider.notifier).refresh(),
        ),
        data: (page) {
          if (page.items.isEmpty) {
            return _EmptyState(
              onClear: () => ref.read(assignmentsProvider.notifier).clearFilters(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(assignmentsProvider.notifier).refresh(),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: page.items.length + (page.hasNext ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= page.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return _AssignmentCard(assignment: page.items[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _openFilters(BuildContext context, AssignmentListQuery current) {
    final subjectController = TextEditingController(text: current.subject ?? '');
    final classController = TextEditingController(text: current.className ?? '');
    final branchController = TextEditingController(text: current.branch ?? '');
    final yearController = TextEditingController(text: current.year?.toString() ?? '');
    AssignmentStatus? selectedStatus = current.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                      'Filter assignments',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: selectedStatus == null,
                          onSelected: (_) => setSheetState(() => selectedStatus = null),
                        ),
                        ...AssignmentStatus.values.map(
                              (status) => FilterChip(
                            label: Text(status.label),
                            selected: selectedStatus == status,
                            onSelected: (_) => setSheetState(() => selectedStatus = status),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _FilterField(controller: subjectController, label: 'Subject'),
                    const SizedBox(height: 12),
                    _FilterField(controller: classController, label: 'Class'),
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
                              ref.read(assignmentsProvider.notifier).clearFilters();
                            },
                            child: const Text('Clear'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final year = int.tryParse(yearController.text.trim());

                              ref.read(assignmentsProvider.notifier).applyFilters(
                                AssignmentListQuery(
                                  status: selectedStatus,
                                  subject: subjectController.text.trim().isEmpty
                                      ? null
                                      : subjectController.text.trim(),
                                  className: classController.text.trim().isEmpty
                                      ? null
                                      : classController.text.trim(),
                                  branch: branchController.text.trim().isEmpty
                                      ? null
                                      : branchController.text.trim(),
                                  year: year,
                                ),
                              );

                              Navigator.pop(context);
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
      },
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

class _AssignmentCard extends StatelessWidget {
  final AssignmentEntity assignment;

  const _AssignmentCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final due = assignment.dueDate;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDetails(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusPill(status: assignment.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                assignment.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(icon: Icons.menu_book_outlined, label: assignment.subject),
                  _MetaChip(icon: Icons.school_outlined, label: assignment.className),
                  if (assignment.branch != null)
                    _MetaChip(icon: Icons.account_tree_outlined, label: assignment.branch!),
                  if (assignment.year != null)
                    _MetaChip(icon: Icons.calendar_today_outlined, label: 'Year ${assignment.year}'),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    assignment.isOverdue ? Icons.warning_amber_rounded : Icons.schedule_rounded,
                    size: 18,
                    color: assignment.isOverdue ? AppColors.error : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Due ${due.day}/${due.month}/${due.year}',
                      style: TextStyle(
                        color: assignment.isOverdue
                            ? AppColors.error
                            : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${assignment.maxMarks} marks',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(assignment.description),
            const SizedBox(height: 16),
            _MetaChip(icon: Icons.menu_book_outlined, label: assignment.subject),
            const SizedBox(height: 8),
            Text('Class: ${assignment.className}'),
            if (assignment.section != null) Text('Section: ${assignment.section}'),
            if (assignment.branch != null) Text('Branch: ${assignment.branch}'),
            if (assignment.year != null) Text('Year: ${assignment.year}'),
            const SizedBox(height: 8),
            Text('Max marks: ${assignment.maxMarks}'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final AssignmentStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == AssignmentStatus.published
        ? AppColors.tertiary
        : status == AssignmentStatus.closed
        ? AppColors.error
        : AppColors.outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
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
            const Icon(Icons.assignment_outlined, size: 54),
            const SizedBox(height: 12),
            const Text('No assignments found'),
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