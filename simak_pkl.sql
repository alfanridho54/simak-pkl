-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 30, 2025 at 04:45 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `simak_pkl`
--

-- --------------------------------------------------------

--
-- Table structure for table `absen`
--

CREATE TABLE `absen` (
  `id` int(11) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `status` enum('hadir','izin','alfa') NOT NULL,
  `date` date NOT NULL,
  `data_pkl_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `absen`
--

INSERT INTO `absen` (`id`, `location`, `status`, `date`, `data_pkl_id`, `created_at`, `updated_at`) VALUES
(1, 'Kantor Pusat', 'hadir', '2025-04-01', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, 'Kantor Pusat', 'izin', '2025-04-02', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, 'Kantor Pusat', 'alfa', '2025-04-03', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35');

-- --------------------------------------------------------

--
-- Table structure for table `data_pkl`
--

CREATE TABLE `data_pkl` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `company_address` text NOT NULL,
  `contact_person` varchar(255) NOT NULL,
  `dosen_pembimbing` bigint(20) UNSIGNED NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL,
  `users_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `data_pkl`
--

INSERT INTO `data_pkl` (`id`, `company_name`, `company_address`, `contact_person`, `dosen_pembimbing`, `status`, `users_id`, `created_at`, `updated_at`) VALUES
(1, 'PT Maju Jaya', 'Jl. Sudirman No. 1', 'Pak Joko', 2, 'pending', 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(2, 'CV Sukses Selalu', 'Jl. Merdeka No. 99', 'Bu Rina', 2, 'approved', 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(3, 'PT Teknologi Hebat', 'Jl. Kemerdekaan No. 123', 'Pak Dedi', 2, 'rejected', 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09');

-- --------------------------------------------------------

--
-- Table structure for table `komentar_laporan`
--

CREATE TABLE `komentar_laporan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `laporan_pkl_id` bigint(20) UNSIGNED NOT NULL,
  `dosen_id` bigint(20) UNSIGNED NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `komentar_laporan`
--

INSERT INTO `komentar_laporan` (`id`, `laporan_pkl_id`, `dosen_id`, `comment`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Laporan bagus, lanjutkan!', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, 1, 2, 'Perbaiki bagian metodologi.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, 2, 2, 'Sudah lengkap.', '2025-04-30 02:44:35', '2025-04-30 02:44:35');

-- --------------------------------------------------------

--
-- Table structure for table `komentar_logbook`
--

CREATE TABLE `komentar_logbook` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `logbook_id` bigint(20) UNSIGNED NOT NULL,
  `dosen_id` bigint(20) UNSIGNED NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `komentar_logbook`
--

INSERT INTO `komentar_logbook` (`id`, `logbook_id`, `dosen_id`, `comment`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Isi logbook masih kurang lengkap.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, 2, 2, 'Bagus, dokumentasi jelas.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, 3, 2, 'Tolong tambahkan ringkasan mingguan.', '2025-04-30 02:44:35', '2025-04-30 02:44:35');

-- --------------------------------------------------------

--
-- Table structure for table `laporan_pkl`
--

CREATE TABLE `laporan_pkl` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `report_date` date NOT NULL,
  `file_attachment` varchar(255) NOT NULL,
  `status` enum('submitted','reviewed','revised') NOT NULL,
  `users_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `laporan_pkl`
--

INSERT INTO `laporan_pkl` (`id`, `report_date`, `file_attachment`, `status`, `users_id`, `created_at`, `updated_at`) VALUES
(1, '2025-04-01', 'laporan1.pdf', 'submitted', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, '2025-04-08', 'laporan2.pdf', 'reviewed', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, '2025-04-15', 'laporan3.pdf', 'revised', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35');

-- --------------------------------------------------------

--
-- Table structure for table `logbook`
--

CREATE TABLE `logbook` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `week_number` int(11) NOT NULL,
  `file_pdf` varchar(255) NOT NULL,
  `data_pkl_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `logbook`
--

INSERT INTO `logbook` (`id`, `week_number`, `file_pdf`, `data_pkl_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'logbook1.pdf', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, 2, 'logbook2.pdf', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, 3, 'logbook3.pdf', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2025_04_29_233603_create_users_table', 1),
(2, '2025_04_29_233604_create_data_pkl_table', 1),
(3, '2025_04_29_233604_create_laporan_pkl_table', 1),
(4, '2025_04_29_233604_create_logbook_table', 1),
(5, '2025_04_29_233605_create_notification_table', 1),
(6, '2025_04_30_000423_create_komentar_logbook_table', 1),
(7, '2025_04_30_000432_create_komentar_laporan_table', 1),
(8, '2025_04_30_002240_create_personal_access_tokens_table', 1),
(9, '2025_04_30_023653_create_absen_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `status` enum('read','unread') NOT NULL,
  `users_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `message`, `status`, `users_id`, `created_at`) VALUES
(1, 'Laporan kamu sudah direview.', 'read', 1, '2025-04-30 02:44:35'),
(2, 'Logbook minggu ke-2 ditolak.', 'unread', 1, '2025-04-30 02:44:35'),
(3, 'PKL kamu disetujui.', 'unread', 1, '2025-04-30 02:44:35');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('mahasiswa','dosen','admin') NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Andi Mahasiswa', 'andi@example.com', NULL, '$2y$10$test1passwordhash', 'mahasiswa', 'token1', '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(2, 'Budi Dosen', 'budi@example.com', NULL, '$2y$10$test2passwordhash', 'dosen', 'token2', '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(3, 'Citra Admin', 'citra@example.com', NULL, '$2y$10$test3passwordhash', 'admin', 'token3', '2025-04-30 02:36:09', '2025-04-30 02:36:09');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absen`
--
ALTER TABLE `absen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `data_pkl_id` (`data_pkl_id`);

--
-- Indexes for table `data_pkl`
--
ALTER TABLE `data_pkl`
  ADD PRIMARY KEY (`id`),
  ADD KEY `data_pkl_dosen_pembimbing_foreign` (`dosen_pembimbing`),
  ADD KEY `data_pkl_users_id_foreign` (`users_id`);

--
-- Indexes for table `komentar_laporan`
--
ALTER TABLE `komentar_laporan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `komentar_laporan_laporan_pkl_id_foreign` (`laporan_pkl_id`),
  ADD KEY `komentar_laporan_dosen_id_foreign` (`dosen_id`);

--
-- Indexes for table `komentar_logbook`
--
ALTER TABLE `komentar_logbook`
  ADD PRIMARY KEY (`id`),
  ADD KEY `komentar_logbook_logbook_id_foreign` (`logbook_id`),
  ADD KEY `komentar_logbook_dosen_id_foreign` (`dosen_id`);

--
-- Indexes for table `laporan_pkl`
--
ALTER TABLE `laporan_pkl`
  ADD PRIMARY KEY (`id`),
  ADD KEY `laporan_pkl_users_id_foreign` (`users_id`);

--
-- Indexes for table `logbook`
--
ALTER TABLE `logbook`
  ADD PRIMARY KEY (`id`),
  ADD KEY `logbook_data_pkl_id_foreign` (`data_pkl_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notification_users_id_foreign` (`users_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absen`
--
ALTER TABLE `absen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `data_pkl`
--
ALTER TABLE `data_pkl`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `komentar_laporan`
--
ALTER TABLE `komentar_laporan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `komentar_logbook`
--
ALTER TABLE `komentar_logbook`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `laporan_pkl`
--
ALTER TABLE `laporan_pkl`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `logbook`
--
ALTER TABLE `logbook`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absen`
--
ALTER TABLE `absen`
  ADD CONSTRAINT `absen_ibfk_1` FOREIGN KEY (`data_pkl_id`) REFERENCES `data_pkl` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `data_pkl`
--
ALTER TABLE `data_pkl`
  ADD CONSTRAINT `data_pkl_dosen_pembimbing_foreign` FOREIGN KEY (`dosen_pembimbing`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `data_pkl_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `komentar_laporan`
--
ALTER TABLE `komentar_laporan`
  ADD CONSTRAINT `komentar_laporan_dosen_id_foreign` FOREIGN KEY (`dosen_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `komentar_laporan_laporan_pkl_id_foreign` FOREIGN KEY (`laporan_pkl_id`) REFERENCES `laporan_pkl` (`id`);

--
-- Constraints for table `komentar_logbook`
--
ALTER TABLE `komentar_logbook`
  ADD CONSTRAINT `komentar_logbook_dosen_id_foreign` FOREIGN KEY (`dosen_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `komentar_logbook_logbook_id_foreign` FOREIGN KEY (`logbook_id`) REFERENCES `logbook` (`id`);

--
-- Constraints for table `laporan_pkl`
--
ALTER TABLE `laporan_pkl`
  ADD CONSTRAINT `laporan_pkl_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `logbook`
--
ALTER TABLE `logbook`
  ADD CONSTRAINT `logbook_data_pkl_id_foreign` FOREIGN KEY (`data_pkl_id`) REFERENCES `data_pkl` (`id`);

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
