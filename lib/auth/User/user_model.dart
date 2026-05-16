class User {
  final String   id;
  final String   collegeId;
  final String   email;
  final String   fullName;
  final String   role;
  final bool     isActive;
  final DateTime createdAt;
  // student-specific fields (nullable — admin/faculty won't have these)
  final String?  rollNo;
  final String?  className;
  final String?  sec;
  final String? imageUrl;

  final int?     startingYear;
  final int?     endingYear;
  final String?  branch;
  final int?     year;

  const User({
    required this.id,
    required this.collegeId,
    required this.email,
    required this.fullName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.rollNo,
    this.imageUrl,

    this.className,
    this.sec,
    this.startingYear,
    this.endingYear,
    this.branch,
    this.year,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:           json['id']          as String,
      collegeId:    json['college_id']  as String,
      email:        json['email']       as String,
      fullName:     json['full_name']   as String,
      role:         json['role']        as String,
      isActive:     json['is_active']   as bool,
      createdAt:    DateTime.parse(json['created_at'] as String),
      imageUrl: json['image_url'] as String?,

      rollNo:       json['roll_no']     as String?,
      className:    json['class']       as String?,
      sec:          json['sec']         as String?,
      startingYear: json['starting_year'] as int?,
      endingYear:   json['ending_year']   as int?,
      branch:       json['branch']      as String?,
      year:         json['year']        as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':           id,
    'college_id':   collegeId,
    'email':        email,
    'full_name':    fullName,
    'role':         role,
    'is_active':    isActive,
    'image_url':    imageUrl,

    'created_at':   createdAt.toIso8601String(),
    'roll_no':      rollNo,
    'class':        className,
    'sec':          sec,
    'starting_year': startingYear,
    'ending_year':   endingYear,
    'branch':       branch,
    'year':         year,
  };

  User copyWith({
    String? id, String? collegeId, String? email, String? fullName,
    String? role, bool? isActive, DateTime? createdAt,
    String? rollNo, String? className, String? sec,
    int? startingYear, int? endingYear, String? branch, int? year,
  }) {
    return User(
      id: id ?? this.id, collegeId: collegeId ?? this.collegeId,
      email: email ?? this.email, fullName: fullName ?? this.fullName,
      role: role ?? this.role, isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt, rollNo: rollNo ?? this.rollNo,
      className: className ?? this.className, sec: sec ?? this.sec,
      startingYear: startingYear ?? this.startingYear,
      endingYear: endingYear ?? this.endingYear,
      branch: branch ?? this.branch, year: year ?? this.year,
    );
  }
}