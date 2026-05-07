import 'package:flutter/material.dart';
import 'package:flutter/services.dart';







// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────
enum PostCategory { event, news, placement, achievement, sports, notice }

class PostModel {
  final String id;
  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final String timeAgo;
  final PostCategory category;
  final String title;
  final String body;
  final String? imageUrl;
  final String? tagLine;
  int likes;
  int comments;
  int shares;
  bool isLiked;
  bool isBookmarked;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.timeAgo,
    required this.category,
    required this.title,
    required this.body,
    this.imageUrl,
    this.tagLine,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isBookmarked = false,
  });
}

// ─────────────────────────────────────────────
//  MOCK DATA
// ─────────────────────────────────────────────
final List<PostModel> _mockPosts = [
  PostModel(
    id: '1',
    authorName: 'CSE Department',
    authorRole: 'Official',
    authorAvatar: 'CS',
    timeAgo: '2 min ago',
    category: PostCategory.event,
    title: 'Hackathon 2025 — Registrations Open!',
    body:
    'Get ready to code through the night! 24-hour hackathon with prizes worth ₹1,00,000. Teams of 2–4. Register before Nov 10.',
    imageUrl:
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&q=80',
    tagLine: '🏆 Prize Pool ₹1,00,000',
    likes: 248,
    comments: 43,
    shares: 91,
  ),
  PostModel(
    id: '2',
    authorName: 'Placement Cell',
    authorRole: 'Placement',
    authorAvatar: 'PC',
    timeAgo: '15 min ago',
    category: PostCategory.placement,
    title: 'TCS NQT Drive — 5th November',
    body:
    'TCS is visiting campus on Nov 5 for NQT recruitment. Eligible: All branches, 6.0+ CGPA, no active backlogs. Report to Seminar Hall by 9:00 AM.',
    imageUrl:
    'https://images.unsplash.com/photo-1560472355-536de3962603?w=800&q=80',
    tagLine: '💼 Package: 3.5 LPA',
    likes: 512,
    comments: 87,
    shares: 204,
  ),
  PostModel(
    id: '3',
    authorName: 'Sports Committee',
    authorRole: 'Committee',
    authorAvatar: 'SC',
    timeAgo: '1 hr ago',
    category: PostCategory.sports,
    title: 'Annual Sports Meet 2025 — Schedule Released',
    body:
    'The inter-department sports meet kicks off on Nov 12. Events include Cricket, Badminton, Chess, Table Tennis & Kabaddi. Register your team at the sports room.',
    imageUrl:
    'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800&q=80',
    tagLine: '⚽ 6 Sports | 12 Departments',
    likes: 178,
    comments: 29,
    shares: 56,
  ),
  PostModel(
    id: '4',
    authorName: 'Principal Office',
    authorRole: 'Administration',
    authorAvatar: 'PO',
    timeAgo: '3 hrs ago',
    category: PostCategory.notice,
    title: 'Holiday Notice — Diwali Break',
    body:
    'The college will remain closed from November 1–4 for Diwali holidays. Regular classes resume on November 5 (Monday). Wishing everyone a safe and joyful Diwali! 🪔',
    imageUrl: null,
    tagLine: '📅 Oct 31 – Nov 4',
    likes: 330,
    comments: 14,
    shares: 119,
  ),
  PostModel(
    id: '5',
    authorName: 'Cultural Club',
    authorRole: 'Club',
    authorAvatar: 'CC',
    timeAgo: '5 hrs ago',
    category: PostCategory.event,
    title: 'Aarohan Cultural Fest — Performers Wanted!',
    body:
    'Calling all talented students! Auditions for dance, music, drama and standup comedy for Aarohan 2025 are on Nov 7. Venue: Auditorium, 4:00 PM.',
    imageUrl:
    'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=800&q=80',
    tagLine: '🎭 Auditions: Nov 7, 4 PM',
    likes: 421,
    comments: 65,
    shares: 143,
  ),
  PostModel(
    id: '6',
    authorName: 'CSE Department',
    authorRole: 'Official',
    authorAvatar: 'CS',
    timeAgo: '8 hrs ago',
    category: PostCategory.achievement,
    title: 'Our Students Win Smart India Hackathon 2025!',
    body:
    'Congratulations to Team "CodeCraft" — Arjun, Priya, Ravi & Sneha — for winning the Smart India Hackathon 2025 Grand Finale in the Hardware Edition! 🎉',
    imageUrl:
    'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=800&q=80',
    tagLine: '🥇 National Champions',
    likes: 894,
    comments: 112,
    shares: 367,
  ),
  PostModel(
    id: '7',
    authorName: 'Library',
    authorRole: 'Administration',
    authorAvatar: 'LB',
    timeAgo: '1 day ago',
    category: PostCategory.notice,
    title: 'New Books Arrived — Semester 5 References',
    body:
    'The central library has received new editions of operating systems, DBMS, computer networks, and cloud computing textbooks. Available for issue from today.',
    imageUrl:
    'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=800&q=80',
    tagLine: '📚 75 New Titles',
    likes: 89,
    comments: 11,
    shares: 23,
  ),
];

// ─────────────────────────────────────────────
//  CATEGORY META
// ─────────────────────────────────────────────
extension CategoryMeta on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.event:
        return 'EVENT';
      case PostCategory.news:
        return 'NEWS';
      case PostCategory.placement:
        return 'PLACEMENT';
      case PostCategory.achievement:
        return 'ACHIEVEMENT';
      case PostCategory.sports:
        return 'SPORTS';
      case PostCategory.notice:
        return 'NOTICE';
    }
  }

  Color get color {
    switch (this) {
      case PostCategory.event:
        return const Color(0xFF24389C);
      case PostCategory.news:
        return const Color(0xFF004C44);
      case PostCategory.placement:
        return const Color(0xFF785900);
      case PostCategory.achievement:
        return const Color(0xFF7B1FA2);
      case PostCategory.sports:
        return const Color(0xFFB71C1C);
      case PostCategory.notice:
        return const Color(0xFF1565C0);
    }
  }
}

// ─────────────────────────────────────────────
//  FEED SCREEN
// ─────────────────────────────────────────────
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  final List<String> _tabs = [
    'All',
    'Events',
    'Placement',
    'Sports',
    'Notices',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<PostModel> _filteredPosts(int tabIndex) {
    if (tabIndex == 0) return _mockPosts;
    final map = {
      1: [PostCategory.event],
      2: [PostCategory.placement],
      3: [PostCategory.sports],
      4: [PostCategory.notice, PostCategory.news],
    };
    return _mockPosts
        .where((p) => map[tabIndex]!.contains(p.category))
        .toList();
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(innerBoxIsScrolled),
        ],
        body: TabBarView(
          controller: _tabController,
          children: List.generate(
            _tabs.length,
                (i) => _FeedList(
              posts: _filteredPosts(i),
              onRefresh: _onRefresh,
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      snap: true,
      pinned: false,
      forceElevated: innerBoxIsScrolled,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 3,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Logo
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF24389C), Color(0xFF004C44)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campus Feed',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1C1C),
                  letterSpacing: -0.4,
                  height: 1.1,
                ),
              ),
              Text(
                'Stay updated · Stay ahead',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF454652),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Color(0xFF454652)),
          onPressed: () {},
          tooltip: 'Search',
        ),
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined, color: Color(0xFF454652)),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBA1A1A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Column(
          children: [
            const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8EE)),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              indicatorColor: const Color(0xFF24389C),
              indicatorWeight: 2.5,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: const Color(0xFF24389C),
              unselectedLabelColor: const Color(0xFF454652),
              labelStyle: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              dividerColor: Colors.transparent,
              tabs: _tabs.map((t) => Tab(text: t, height: 46)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => _showStoryUploadSheet(context),
      backgroundColor: const Color(0xFF24389C),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text(
        'Post',
        style: TextStyle(
          fontFamily: 'WorkSans',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.3,
        ),
      ),
      elevation: 4,
    );
  }

  void _showStoryUploadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _PostCreationSheet(),
    );
  }
}

// ─────────────────────────────────────────────
//  FEED LIST
// ─────────────────────────────────────────────
class _FeedList extends StatelessWidget {
  final List<PostModel> posts;
  final Future<void> Function() onRefresh;

  const _FeedList({required this.posts, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const _EmptyFeed();

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFF24389C),
      strokeWidth: 2.5,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return _FeedCard(post: posts[index], index: index);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FEED CARD (Way2News-style)
// ─────────────────────────────────────────────
class _FeedCard extends StatefulWidget {
  final PostModel post;
  final int index;

  const _FeedCard({required this.post, required this.index});

  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeCtrl;
  late Animation<double> _likeScale;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _likeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      widget.post.isLiked = !widget.post.isLiked;
      widget.post.likes += widget.post.isLiked ? 1 : -1;
    });
    _likeCtrl.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  void _toggleBookmark() {
    setState(() => widget.post.isBookmarked = !widget.post.isBookmarked);
    HapticFeedback.selectionClick();
  }

  void _share() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${widget.post.title}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF24389C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          _buildHeader(post),

          // ── Hero Image ──
          if (post.imageUrl != null) _buildHeroImage(post),

          // ── Content ──
          _buildContent(post),

          // ── Tag Line Banner ──
          if (post.tagLine != null) _buildTagLine(post),

          // ── Divider ──
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Color(0xFFF0F0F5)),

          // ── Action Bar ──
          _buildActionBar(post),
        ],
      ),
    );
  }

  Widget _buildHeader(PostModel post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  post.category.color,
                  post.category.color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                post.authorAvatar,
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Author info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1C1C),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (post.authorRole == 'Official' ||
                        post.authorRole == 'Placement')
                      const Icon(Icons.verified_rounded,
                          size: 14, color: Color(0xFF24389C)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _CategoryPill(category: post.category),
                    const SizedBox(width: 6),
                    Text(
                      post.timeAgo,
                      style: const TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF757684),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bookmark
          GestureDetector(
            onTap: _toggleBookmark,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                post.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                key: ValueKey(post.isBookmarked),
                size: 22,
                color: post.isBookmarked
                    ? const Color(0xFF24389C)
                    : const Color(0xFF9E9EAE),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showMoreOptions(context, post),
            child: const Icon(Icons.more_vert_rounded,
                size: 20, color: Color(0xFF9E9EAE)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(PostModel post) {
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: Hero(
        tag: 'post_image_${post.id}',
        child: ClipRRect(
          child: Image.network(
            post.imageUrl!,
            height: 210,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                height: 210,
                color: const Color(0xFFF0F2F8),
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                        : null,
                    color: const Color(0xFF24389C),
                    strokeWidth: 2,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              height: 210,
              color: const Color(0xFFF0F2F8),
              child: Center(
                child: Icon(Icons.image_not_supported_outlined,
                    size: 40,
                    color: const Color(0xFF24389C).withOpacity(0.3)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PostModel post) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14, post.imageUrl != null ? 12 : 0, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1C1C),
              letterSpacing: -0.3,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedCrossFade(
            firstChild: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF454652),
                height: 1.5,
              ),
            ),
            secondChild: Text(
              post.body,
              style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: Color(0xFF454652),
                height: 1.5,
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Read less ▲' : 'Read more ▼',
              style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF24389C),
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagLine(PostModel post) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: post.category.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: post.category.color.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Text(
        post.tagLine!,
        style: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: post.category.color,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildActionBar(PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          // Like
          _ActionButton(
            icon: AnimatedBuilder(
              animation: _likeScale,
              builder: (_, child) =>
                  Transform.scale(scale: _likeScale.value, child: child),
              child: Icon(
                post.isLiked
                    ? Icons.thumb_up_rounded
                    : Icons.thumb_up_outlined,
                size: 19,
                color: post.isLiked
                    ? const Color(0xFF24389C)
                    : const Color(0xFF9E9EAE),
              ),
            ),
            label: _formatCount(post.likes),
            labelColor:
            post.isLiked ? const Color(0xFF24389C) : const Color(0xFF9E9EAE),
            onTap: _toggleLike,
          ),

          // Comment
          _ActionButton(
            icon: const Icon(Icons.mode_comment_outlined,
                size: 19, color: Color(0xFF9E9EAE)),
            label: _formatCount(post.comments),
            labelColor: const Color(0xFF9E9EAE),
            onTap: () => _showCommentsSheet(context, post),
          ),

          // Share
          _ActionButton(
            icon: const Icon(Icons.reply_rounded,
                size: 20, color: Color(0xFF9E9EAE)),
            label: _formatCount(post.shares),
            labelColor: const Color(0xFF9E9EAE),
            onTap: _share,
          ),

          const Spacer(),

          // WhatsApp Share
          _IconActionButton(
            icon: Icons.message,
            color: const Color(0xFF25D366),
            onTap: _share,
            tooltip: 'Share on WhatsApp',
          ),

          // Copy link
          _IconActionButton(
            icon: Icons.link_rounded,
            color: const Color(0xFF9E9EAE),
            onTap: () {
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Link copied!'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFF1A1C1C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Copy link',
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  void _showMoreOptions(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _OptionTile(
                icon: Icons.report_outlined,
                label: 'Report Post',
                color: const Color(0xFFBA1A1A)),
            _OptionTile(
                icon: Icons.hide_source_rounded,
                label: 'Hide This Post',
                color: const Color(0xFF454652)),
            _OptionTile(
                icon: Icons.share_outlined,
                label: 'Share',
                color: const Color(0xFF24389C)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (_, ctrl) => _CommentsSheet(
          post: post,
          scrollController: ctrl,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CATEGORY PILL
// ─────────────────────────────────────────────
class _CategoryPill extends StatelessWidget {
  final PostCategory category;

  const _CategoryPill({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.label,
        style: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: category.color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ACTION BUTTON
// ─────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _IconActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COMMENTS SHEET
// ─────────────────────────────────────────────
class _CommentsSheet extends StatefulWidget {
  final PostModel post;
  final ScrollController scrollController;

  const _CommentsSheet(
      {required this.post, required this.scrollController});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _commentCtrl = TextEditingController();
  final List<Map<String, String>> _comments = [
    {'name': 'Arjun K.', 'text': 'This is amazing! Can\'t wait 🔥', 'time': '5 min ago'},
    {'name': 'Priya R.', 'text': 'Already registered. See you all there 👋', 'time': '12 min ago'},
    {'name': 'Ravi M.', 'text': 'Is this open for all departments?', 'time': '20 min ago'},
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 4),
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Text(
                'Comments (${widget.post.comments})',
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1C1C),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF0F0F5)),
        // Comments list
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: _comments.length,
            itemBuilder: (_, i) {
              final c = _comments[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF24389C).withOpacity(0.12),
                      child: Text(
                        c['name']![0],
                        style: const TextStyle(
                          color: Color(0xFF24389C),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(c['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1C1C),
                                  )),
                              const SizedBox(width: 6),
                              Text(c['time']!,
                                  style: const TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 11,
                                    color: Color(0xFF757684),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(c['text']!,
                              style: const TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 13.5,
                                color: Color(0xFF454652),
                                height: 1.4,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Input
        Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF0F0F5))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentCtrl,
                  style: const TextStyle(
                      fontFamily: 'WorkSans', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Write a comment…',
                    hintStyle: const TextStyle(
                        color: Color(0xFF9E9EAE), fontSize: 14),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_commentCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _comments.insert(0, {
                      'name': 'You',
                      'text': _commentCtrl.text.trim(),
                      'time': 'Just now',
                    });
                    _commentCtrl.clear();
                  });
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF24389C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  POST CREATION SHEET
// ─────────────────────────────────────────────
class _PostCreationSheet extends StatefulWidget {
  const _PostCreationSheet();

  @override
  State<_PostCreationSheet> createState() => _PostCreationSheetState();
}

class _PostCreationSheetState extends State<_PostCreationSheet> {
  PostCategory _selectedCategory = PostCategory.event;
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Create Post',
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C1C),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF454652),
                      )),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F5)),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chips
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF454652),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PostCategory.values.map((cat) {
                      final selected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected
                                ? cat.color
                                : cat.color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? cat.color
                                  : cat.color.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            cat.label,
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: selected ? Colors.white : cat.color,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text('Title',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF454652),
                        letterSpacing: 0.4,
                      )),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleCtrl,
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Enter post title…',
                      hintStyle: const TextStyle(
                          color: Color(0xFFBBBBC8), fontSize: 15),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Body
                  const Text('Description',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF454652),
                        letterSpacing: 0.4,
                      )),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _bodyCtrl,
                    maxLines: 5,
                    style: const TextStyle(
                        fontFamily: 'WorkSans', fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Write your post content…',
                      hintStyle: const TextStyle(
                          color: Color(0xFFBBBBC8), fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Add image placeholder
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF24389C).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF24389C).withOpacity(0.2),
                          width: 1.5,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 28, color: Color(0xFF24389C)),
                            SizedBox(height: 6),
                            Text(
                              'Add Image (optional)',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF24389C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Post submitted for review!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF004C44),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF24389C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Submit Post',
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  OPTION TILE (More sheet)
// ─────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'WorkSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      onTap: () => Navigator.pop(context),
      dense: true,
    );
  }
}

// ─────────────────────────────────────────────
//  EMPTY FEED
// ─────────────────────────────────────────────
class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 56,
              color: const Color(0xFF24389C).withOpacity(0.25)),
          const SizedBox(height: 16),
          const Text(
            'Nothing here yet',
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF454652),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Check back later for updates',
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 13,
              color: Color(0xFF9E9EAE),
            ),
          ),
        ],
      ),
    );
  }
}
