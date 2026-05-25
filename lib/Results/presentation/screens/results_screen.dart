import 'package:college_management_saas/Results/domain/result_entity.dart';
import 'package:college_management_saas/Results/presentation/providers/result_provider.dart';
import 'package:college_management_saas/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  final String? studentId;

  const ResultsScreen({
    super.key,
    this.studentId,
  });

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentId = widget.studentId;
      if (studentId != null && studentId.trim().isNotEmpty) {
        ref.read(resultsProvider.notifier).setStudentId(studentId.trim());
      } else {
        ref.read(resultsProvider.notifier).useLoggedInStudent();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 240) {
        ref.read(resultsProvider.notifier).loadNextPage();
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
    final results = ref.watch(resultsProvider);
    final query = ref.watch(resultsProvider.notifier).query;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Results'),
        actions: [
          IconButton(
            onPressed: () => _openFilters(query),
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            onPressed: () => ref.read(resultsProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFilters(query),
        icon: const Icon(Icons.tune_rounded),
        label: const Text('Filter'),
      ),
      body: results.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.read(resultsProvider.notifier).refresh(),
        ),
        data: (page) {
          if (page.items.isEmpty) {
            return _EmptyState(
              onClear: () => ref.read(resultsProvider.notifier).clearFilters(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(resultsProvider.notifier).refresh(),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: page.items.length + 1 + (page.hasNext ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _SummaryCard(summary: page.summary);
                }

                final resultIndex = index - 1;

                if (resultIndex >= page.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return _ResultCard(result: page.items[resultIndex]);
              },
            ),
          );
        },
      ),
    );
  }

  void _openFilters(ResultQuery query) {
    final subjectController = TextEditingController(text: query.subject ?? '');
    final examTypeController = TextEditingController(text: query.examType ?? '');
    final semesterController = TextEditingController(text: query.semester?.toString() ?? '');
    final academicYearController = TextEditingController(text: query.academicYear ?? '');

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
                  'Filter results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                _FilterField(controller: subjectController, label: 'Subject'),
                const SizedBox(height: 12),
                _FilterField(controller: examTypeController, label: 'Exam type'),
                const SizedBox(height: 12),
                _FilterField(
                  controller: semesterController,
                  label: 'Semester',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _FilterField(
                  controller: academicYearController,
                  label: 'Academic year',
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(resultsProvider.notifier).clearFilters();
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(resultsProvider.notifier).applyFilters(
                            subject: subjectController.text,
                            examType: examTypeController.text,
                            semester: int.tryParse(semesterController.text.trim()),
                            academicYear: academicYearController.text,
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

class _SummaryCard extends StatelessWidget {
  final ResultSummary summary;

  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall performance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Percentage',
                  value: '${summary.percentage.toStringAsFixed(1)}%',
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Marks',
                  value:
                  '${summary.marksObtained.toStringAsFixed(0)}/${summary.totalMarks}',
                  color: AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Subjects',
                  value: summary.totalSubjects.toString(),
                  color: AppColors.onSurface,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Passed',
                  value: summary.passCount.toString(),
                  color: AppColors.navActiveText,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  label: 'Failed',
                  value: summary.failCount.toString(),
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

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final StudentResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final statusColor = result.resultStatus == 'PASS'
        ? AppColors.navActiveText
        : result.resultStatus == 'FAIL'
        ? AppColors.error
        : AppColors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                  result.subject,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _StatusPill(
                label: result.resultStatus,
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(icon: Icons.assignment_outlined, label: result.examType),
              if (result.semester != null)
                _MetaChip(icon: Icons.school_outlined, label: 'Sem ${result.semester}'),
              _MetaChip(icon: Icons.calendar_today_outlined, label: result.academicYear),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${result.marksObtained.toStringAsFixed(0)}/${result.maxMarks} marks',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '${result.percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 12),
              if (result.grade != null)
                Text(
                  result.grade!,
                  style: const TextStyle(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            ],
          ),
          if (result.remarks != null && result.remarks!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              result.remarks!,
              style: const TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
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
            const Icon(Icons.bar_chart_rounded, size: 54),
            const SizedBox(height: 12),
            const Text('No results found'),
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

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

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