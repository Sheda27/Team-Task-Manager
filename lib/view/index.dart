// Dart core library for debugging and logging
export 'dart:developer';

// Firebase authentication package
export 'package:firebase_auth/firebase_auth.dart';
// Flutter material design widgets, hiding Flow to avoid conflicts
export 'package:flutter/material.dart' hide Flow;
// GetX package for state management and navigation
export 'package:get/get.dart';
// Firebase core initialization
export 'package:firebase_core/firebase_core.dart';
// Shared models used across the app
export 'package:team_task_manager/models/shared.dart';
// Authentication screens
export 'package:team_task_manager/view/auth/login.dart';
export 'package:team_task_manager/view/auth/sign_up.dart';
export 'package:team_task_manager/view/auth/waiting_verify.dart';
// Home and team management screens
export 'package:team_task_manager/view/home/all_team_page.dart';
export 'package:team_task_manager/view/profile/profile.dart';
export 'package:team_task_manager/view/home/add_team.dart';
// Firebase configuration options
export 'package:team_task_manager/firebase_options.dart';
// Cloud Firestore database
export 'package:cloud_firestore/cloud_firestore.dart';
// Custom UI components and color definitions
export 'package:team_task_manager/models/componants.dart';
export 'package:team_task_manager/models/colors.dart';
// Team and task management screens
export 'package:team_task_manager/view/home/edit_team.dart';
export 'package:team_task_manager/view/team/members.dart';
export 'package:team_task_manager/view/task/add_task.dart';
export 'package:team_task_manager/view/task/edit_task.dart';
export 'package:team_task_manager/view/task/tasks_page.dart';
export 'package:team_task_manager/view/team/add_member.dart';
// Third-party sign-in button UI
export 'package:sign_button/sign_button.dart';
// Google sign-in integration
export 'package:google_sign_in/google_sign_in.dart';
// Main app controller
export 'package:team_task_manager/controller.dart/controller.dart';
// Dart async utilities
export 'dart:async';
// Flutter services for platform-specific features
export 'package:flutter/services.dart';
// Image picker for selecting images from gallery/camera
export 'package:image_picker/image_picker.dart';
// Firebase storage for file uploads
export 'package:firebase_storage/firebase_storage.dart';
// Dart IO library, hiding HeaderValue to avoid conflicts
export 'dart:io' hide HeaderValue;
// Responsive UI utilities
export 'package:flutter_screenutil/flutter_screenutil.dart';
// Local notifications (commented out)
// export 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Firebase messaging for push notifications
export 'package:firebase_messaging/firebase_messaging.dart';
