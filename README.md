# BALZOUG | بالزوق

Android starter for the Eastern Sudan University for Medical Sciences and Technology learning library.

## Technology
- Kotlin 2.2.20
- Jetpack Compose / Material 3
- Android Gradle Plugin 8.13.2
- Supabase planned for authentication, PostgreSQL and file storage

## Open locally
Open the `BALZOUG` folder in a recent Android Studio, allow Gradle sync, then run the `app` configuration on an Android device/emulator.

## Build APK using GitHub Actions (no local computer required)
The repository includes `.github/workflows/android.yml`. After pushing the project to the `main` branch:
1. Open the repository's **Actions** tab.
2. Select **Build BALZOUG Android APK**.
3. If needed, choose **Run workflow** and confirm.
4. Wait for the run to complete successfully.
5. Open the completed run and download the `BALZOUG-debug-apk` artifact.

The workflow builds `BALZOUG/app` and uploads the debug APK. A successful workflow is required before an APK exists.

## Supabase setup
The initial database outline is in `supabase/schema.sql`. Review it and apply it in the Supabase SQL Editor only after creating your Supabase project. Row Level Security is enabled and intentionally has no permissive policies yet. Before using real student data, implement and test policies for approved students, college-scoped supervisors, admins and super admins. Never place a Supabase service-role key in the Android app.

## Current implementation status
- Implemented starter UI and sample navigation: home, college, department, level, course, file categories and sample file cards.
- Sample university data is local/demo data in `app/src/main/java/com/balzoug/app/data/UniversityData.kt`.
- This is not yet a production-ready connected application. Authentication/approval, real upload/review, ratings, search, notifications, timetable management, and role enforcement still require implementation and testing.
- Homework/assignments are intentionally excluded from the first release, per product decision.
- Lecture timetable entry is available from the main menu only, per product decision.
- Official university logo has not been embedded; add the original high-resolution asset without altering it when supplied.

## Package
`com.balzoug.app`
