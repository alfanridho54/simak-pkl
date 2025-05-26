-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2025 at 03:41 PM
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
(3, 'Kantor Pusat', 'alfa', '2025-04-03', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(4, 'Kantor Kelurahan', 'hadir', '2025-05-06', 1, '2025-05-04 16:57:05', '2025-05-04 17:02:46'),
(5, 'Kantor Pusat', 'hadir', '2025-05-05', 6, '2025-05-08 16:54:46', '2025-05-08 16:54:46'),
(6, 'Kantor Pusat', 'izin', '2025-05-05', 6, '2025-05-08 16:58:06', '2025-05-08 16:58:06'),
(7, 'Kantor Pusat', 'izin', '2025-05-05', 7, '2025-05-08 17:11:31', '2025-05-08 17:11:31'),
(8, 'Kantor Pusat', 'izin', '2025-05-07', 7, '2025-05-08 17:57:40', '2025-05-08 17:57:40'),
(9, 'Kantor Pusat', 'hadir', '2025-05-08', 7, '2025-05-08 18:31:32', '2025-05-08 18:31:32');

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
  `users_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `data_pkl`
--

INSERT INTO `data_pkl` (`id`, `company_name`, `company_address`, `contact_person`, `dosen_pembimbing`, `users_id`, `created_at`, `updated_at`) VALUES
(1, 'PT Maju Jaya', 'Jl. Sudirman No. 1', 'Pak Joko', 2, 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(2, 'CV Sukses Selalu', 'Jl. Merdeka No. 99', 'Bu Rina', 2, 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(3, 'PT Teknologi Hebat', 'Jl. Kemerdekaan No. 123', 'Pak Dedi', 2, 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(4, 'PT Mencari Cinta Sejati', 'jln. cinta sejati', 'Pak Bowo', 4, 1, NULL, NULL),
(5, 'PT Hebat', 'Jl. Merdeka 10', 'Pak Rudi', 7, 1, '2025-05-05 03:45:43', '2025-05-05 03:45:43'),
(6, 'PT Hebat', 'Jl. Merdeka 10', 'Pak Rudi', 7, 6, '2025-05-07 19:56:23', '2025-05-07 19:56:23'),
(7, 'PT Sejahtera', 'Jl. Boan', 'Pak Rusdi', 9, 10, '2025-05-08 17:10:32', '2025-05-08 17:10:32'),
(8, 'PT Sejahtera', 'Jl. Boan RT 05', 'Pak Rusdi', 7, 11, '2025-05-13 17:07:14', '2025-05-13 17:07:14');

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
(3, 2, 2, 'Sudah lengkap.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(4, 1, 2, 'Revisi bagian penutup.', '2025-05-05 03:49:27', '2025-05-05 03:49:27'),
(8, 11, 9, 'Revisi bagian penutup.', '2025-05-17 17:07:46', '2025-05-17 17:07:46'),
(9, 12, 7, 'Revisi bagian penutup.', '2025-05-17 17:17:53', '2025-05-17 17:17:53'),
(10, 13, 7, 'Revisi bagian penutup.', '2025-05-19 01:23:26', '2025-05-19 01:23:26');

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
(3, 3, 2, 'Tolong tambahkan ringkasan mingguan.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(4, 1, 2, 'Dokumentasi minggu ini sudah baik.', '2025-05-05 03:49:49', '2025-05-05 03:49:49'),
(5, 5, 7, 'Dokumentasi minggu ini sudah baik.', '2025-05-17 18:25:31', '2025-05-17 18:25:31'),
(6, 5, 7, 'Dokumentasi minggu ini sudah baik.', '2025-05-19 01:24:26', '2025-05-19 01:24:26');

-- --------------------------------------------------------

--
-- Table structure for table `laporan_pkl`
--

CREATE TABLE `laporan_pkl` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `data_pkl_id` bigint(20) UNSIGNED DEFAULT NULL,
  `users_id` bigint(20) UNSIGNED DEFAULT NULL,
  `report_date` date NOT NULL,
  `file_attachment` varchar(255) NOT NULL,
  `status` enum('submitted','reviewed','revised') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `laporan_pkl`
--

INSERT INTO `laporan_pkl` (`id`, `data_pkl_id`, `users_id`, `report_date`, `file_attachment`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, '2025-04-01', 'laporan1.pdf', 'submitted', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, NULL, NULL, '2025-04-08', 'laporan2.pdf', 'reviewed', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(10, 8, 11, '2025-05-16', 'laporan4.pdf', 'submitted', '2025-05-17 02:08:35', '2025-05-17 02:08:35'),
(11, 7, 10, '2025-05-16', 'laporan5.pdf', 'submitted', '2025-05-17 17:06:39', '2025-05-17 17:06:39'),
(12, 8, 11, '2025-05-16', 'laporan6.pdf', 'submitted', '2025-05-17 17:15:39', '2025-05-17 17:15:39'),
(13, 6, 6, '2025-05-16', 'laporan6.pdf', 'submitted', '2025-05-19 01:21:31', '2025-05-19 01:21:31');

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
(3, 3, 'logbook3.pdf', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(4, 4, 'logbook4.pdf', 1, '2025-05-04 18:01:16', '2025-05-04 18:02:41'),
(5, 6, 'logbook5.pdf', 6, '2025-05-17 17:52:49', '2025-05-17 17:55:17');

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
(9, '2025_04_30_023653_create_absen_table', 2),
(10, '2025_05_05_105342_add_timestamps_to_notification_table', 3),
(11, '2025_05_13_232328_add_data_pkl_id_to_laporan_pkl_table', 4),
(12, '2025_05_13_233657_update_laporan_pkl_add_data_pkl_id_and_drop_users_id', 5),
(13, '2025_05_17_084848_add_users_id_to_laporan_pkl_table', 6);

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `status` enum('read','unread') NOT NULL,
  `users_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `message`, `status`, `users_id`, `created_at`, `updated_at`) VALUES
(1, 'Laporan kamu sudah direview.', 'read', 1, NULL, NULL),
(2, 'Logbook minggu ke-2 ditolak.', 'unread', 1, NULL, NULL),
(3, 'PKL kamu disetujui.', 'unread', 1, NULL, NULL),
(4, 'PKL disetujui.', 'unread', 1, '2025-05-05 03:55:06', '2025-05-05 03:55:06');

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

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(7, 'App\\Models\\User', 8, 'auth_token', '3e7565f7040697585a7995dfd8ed99a06275a3d0865391105d7836ee6cb31527', '[\"*\"]', NULL, NULL, '2025-05-07 20:13:35', '2025-05-07 20:13:35'),
(8, 'App\\Models\\User', 8, 'auth_token', '8bd38fe255912ae2c7b231866bbb1ecdbdb48fbb4dd24e175b7ba9126aa7b181', '[\"*\"]', '2025-05-07 20:14:28', NULL, '2025-05-07 20:14:19', '2025-05-07 20:14:28'),
(9, 'App\\Models\\User', 8, 'auth_token', '656ee2ea3e24e23149d8136c17e87c8f6065095928c5b33919c1f0249c485b96', '[\"*\"]', NULL, NULL, '2025-05-07 20:17:19', '2025-05-07 20:17:19'),
(18, 'App\\Models\\User', 9, 'auth_token', 'ff77f77cb6f0b5f1b20c33dac276a11d36abd486a35e1c4500ead563df04857d', '[\"*\"]', NULL, NULL, '2025-05-08 17:03:32', '2025-05-08 17:03:32'),
(19, 'App\\Models\\User', 9, 'auth_token', 'f2cd0d09bed79746a84ddfb3110f9670837f4af7dd83842d13d0dd965260bbfd', '[\"*\"]', NULL, NULL, '2025-05-08 17:03:42', '2025-05-08 17:03:42'),
(20, 'App\\Models\\User', 9, 'auth_token', 'e912dcb1151c984b4a7bc0ed3acdd27736e55172193de1da5d2da562d513ab11', '[\"*\"]', '2025-05-08 17:04:30', NULL, '2025-05-08 17:04:13', '2025-05-08 17:04:30'),
(23, 'App\\Models\\User', 9, 'auth_token', 'a09d4d764855020a8afeaf2ce8d72263f38b18a242fa24e7630898182f3091c4', '[\"*\"]', '2025-05-08 18:31:39', NULL, '2025-05-08 17:12:20', '2025-05-08 18:31:39'),
(26, 'App\\Models\\User', 9, 'auth_token', '61f4a0c747f6bbd5eb7c22a3a2306f810244132f46a58cc6e587518bee1189c8', '[\"*\"]', '2025-05-08 18:33:09', NULL, '2025-05-08 18:32:24', '2025-05-08 18:33:09'),
(37, 'App\\Models\\User', 11, 'auth_token', '332421373394725f295e8c41e3b4b930e1179a3a10f5422701ce625e231250cd', '[\"*\"]', NULL, NULL, '2025-05-13 17:06:02', '2025-05-13 17:06:02'),
(38, 'App\\Models\\User', 11, 'auth_token', 'aea4b9ced7265ebb6fbc570689ce3aa5fd0edc6e1ede96c2ec8d0c108d7260d6', '[\"*\"]', '2025-05-17 02:08:35', NULL, '2025-05-13 17:06:22', '2025-05-17 02:08:35'),
(42, 'App\\Models\\User', 9, 'auth_token', '7fce8803403442aabd9812bc493bb3f5943e7967314609c684983b372df1f001', '[\"*\"]', '2025-05-17 17:05:19', NULL, '2025-05-17 17:05:08', '2025-05-17 17:05:19'),
(44, 'App\\Models\\User', 9, 'auth_token', '7c008939e8f21ef3263fa0af9499dd4c8e6511ae0c5807d279ba120c1d096073', '[\"*\"]', '2025-05-17 17:07:46', NULL, '2025-05-17 17:07:06', '2025-05-17 17:07:46'),
(47, 'App\\Models\\User', 11, 'auth_token', '4e6fccdb6e8c4faab67262a172ec0607b510dc0f08a4fa96cee40693a475101a', '[\"*\"]', '2025-05-17 17:12:43', NULL, '2025-05-17 17:12:35', '2025-05-17 17:12:43'),
(49, 'App\\Models\\User', 11, 'auth_token', 'f4746c886576a432683a4a2381efae8ad59d376993748fe4536a2e4a9bb4755b', '[\"*\"]', '2025-05-17 17:15:47', NULL, '2025-05-17 17:14:40', '2025-05-17 17:15:47'),
(51, 'App\\Models\\User', 11, 'auth_token', '140b766f20adae9c8355ecfcd6658a35f7149c3fa1dcfcdca8a82a06edf2744f', '[\"*\"]', NULL, NULL, '2025-05-17 17:17:00', '2025-05-17 17:17:00'),
(52, 'App\\Models\\User', 11, 'auth_token', '4bbef33f705cab625d736d8f7424232f66b9c43378c5d08975173d87faa18ced', '[\"*\"]', '2025-05-17 17:34:14', NULL, '2025-05-17 17:18:56', '2025-05-17 17:34:14'),
(53, 'App\\Models\\User', 9, 'auth_token', '24b2630cc787ea9ba29c98e8835a5c217791e324d453d66f5705c296b5bc77b1', '[\"*\"]', '2025-05-17 17:34:07', NULL, '2025-05-17 17:24:23', '2025-05-17 17:34:07'),
(62, 'App\\Models\\User', 11, 'auth_token', 'a68eedf7ff8da7ec128c0c78121893681b9c2a70584655987945e960e24ababa', '[\"*\"]', '2025-05-18 02:28:09', NULL, '2025-05-18 02:24:57', '2025-05-18 02:28:09'),
(63, 'App\\Models\\User', 11, 'auth_token', 'ad5c8c2ff9c2c43cf6292c4692b97d3a314a8ab97de81b1309ab96de791bc281', '[\"*\"]', '2025-05-19 01:07:26', NULL, '2025-05-19 01:07:07', '2025-05-19 01:07:26');

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
(3, 'Citra Admin', 'citra@example.com', NULL, '$2y$10$test3passwordhash', 'admin', 'token3', '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(4, 'Asep Dosen', 'asep@gmail.com', NULL, 'dospem123', 'dosen', 'token23', NULL, NULL),
(5, 'Alfan', 'alfan@example.com', NULL, 'alfan123', 'mahasiswa', NULL, '2025-05-04 17:12:35', '2025-05-04 17:12:35'),
(6, 'akun1', 'akun1@gmail.com', NULL, '$2y$12$1cUiAXEfV8Ccg7ug8TgUBOuwoQwqBlq0AzPEvMxx3lP2cNhSuh5ya', 'mahasiswa', NULL, '2025-05-07 19:01:04', '2025-05-07 19:01:04'),
(7, 'dosen1', 'dosen1@gmail.com', NULL, '$2y$12$w1ROjNZj2UFf18.pVkPnF.ZRMuXUaUWEKM3GTD67UNm.f9gNiFmv2', 'dosen', NULL, '2025-05-07 20:01:43', '2025-05-07 20:01:43'),
(8, 'admin1', 'admin1@gmail.com', NULL, '$2y$12$Z0TpDcFCDhXFIqmcdyH2COgIVMoKwD0tVCxBD2hiTIdc7tDWBVUrG', 'admin', NULL, '2025-05-07 20:13:35', '2025-05-07 20:13:35'),
(9, 'dosen2', 'dosen2@gmail.com', NULL, '$2y$12$ysOMSJCEya9qRO.5vN7OpOOmm1xF0HZfnjuQwc8nctKmx768sLIF2', 'dosen', NULL, '2025-05-08 17:03:32', '2025-05-08 17:03:32'),
(10, 'mahasiswa2', 'akun2@gmail.com', NULL, '$2y$12$eikEi6Esfk7fJnGt4lEyJeIOjd3FfcpPH6q4hrGAqvXRnlXhGFbzW', 'mahasiswa', NULL, '2025-05-08 17:05:04', '2025-05-08 17:05:04'),
(11, 'mahasiswa3', 'akun3@gmail.com', NULL, '$2y$12$P0EJz6uqSdd/DUtKMTFonuHTWi6r4nLjBDULT8WjsLzjHVnK6OTDS', 'mahasiswa', NULL, '2025-05-13 17:06:02', '2025-05-13 17:06:02');

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
  ADD KEY `laporan_pkl_data_pkl_id_foreign` (`data_pkl_id`),
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `data_pkl`
--
ALTER TABLE `data_pkl`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `komentar_laporan`
--
ALTER TABLE `komentar_laporan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `komentar_logbook`
--
ALTER TABLE `komentar_logbook`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `laporan_pkl`
--
ALTER TABLE `laporan_pkl`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `logbook`
--
ALTER TABLE `logbook`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
  ADD CONSTRAINT `laporan_pkl_data_pkl_id_foreign` FOREIGN KEY (`data_pkl_id`) REFERENCES `data_pkl` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `laporan_pkl_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
