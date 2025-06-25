-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 22 Jun 2025 pada 03.27
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

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
-- Struktur dari tabel `absen`
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
-- Dumping data untuk tabel `absen`
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
(9, 'Kantor Pusat', 'hadir', '2025-05-08', 7, '2025-05-08 18:31:32', '2025-05-08 18:31:32'),
(10, 'PT Abcd', 'izin', '2025-06-02', 10, '2025-06-01 17:48:14', '2025-06-01 17:50:25'),
(11, 'Kantor Pusat', 'izin', '2025-06-04', 10, '2025-06-03 23:37:20', '2025-06-03 23:37:26'),
(12, 'Jln. tes', 'hadir', '2025-06-22', 11, '2025-06-21 18:03:10', '2025-06-21 18:03:10');

-- --------------------------------------------------------

--
-- Struktur dari tabel `data_pkl`
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
-- Dumping data untuk tabel `data_pkl`
--

INSERT INTO `data_pkl` (`id`, `company_name`, `company_address`, `contact_person`, `dosen_pembimbing`, `users_id`, `created_at`, `updated_at`) VALUES
(1, 'PT Maju Jaya', 'Jl. Sudirman No. 1', 'Pak Joko', 2, 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(2, 'CV Sukses Selalu', 'Jl. Merdeka No. 99', 'Bu Rina', 2, 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(3, 'PT Teknologi Hebat', 'Jl. Kemerdekaan No. 123', 'Pak Dedi', 2, 1, '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(4, 'PT Mencari Cinta Sejati', 'jln. cinta sejati', 'Pak Bowo', 4, 1, NULL, NULL),
(5, 'PT Hebat', 'Jl. Merdeka 10', 'Pak Rudi', 7, 1, '2025-05-05 03:45:43', '2025-05-05 03:45:43'),
(6, 'PT Hebat', 'Jl. Merdeka 10', 'Pak Rudi', 7, 6, '2025-05-07 19:56:23', '2025-05-07 19:56:23'),
(7, 'PT Sejahtera', 'Jl. Boan', 'Pak Rusdi', 9, 10, '2025-05-08 17:10:32', '2025-05-08 17:10:32'),
(8, 'PT Sejahtera', 'Jl. Boan RT 05', 'Pak Rusdi', 7, 11, '2025-05-13 17:07:14', '2025-05-13 17:07:14'),
(10, 'PT. ABCD', 'JL. ABCD', 'Pak Bambang', 7, 12, '2025-06-01 17:30:22', '2025-06-03 23:37:00'),
(11, 'PT. Tes', 'jln. tes', 'Pak bambang', 7, 14, '2025-06-21 18:02:55', '2025-06-21 18:14:40');

-- --------------------------------------------------------

--
-- Struktur dari tabel `komentar_laporan`
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
-- Dumping data untuk tabel `komentar_laporan`
--

INSERT INTO `komentar_laporan` (`id`, `laporan_pkl_id`, `dosen_id`, `comment`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Laporan bagus, lanjutkan!', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, 1, 2, 'Perbaiki bagian metodologi.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, 2, 2, 'Sudah lengkap.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(4, 1, 2, 'Revisi bagian penutup.', '2025-05-05 03:49:27', '2025-05-05 03:49:27'),
(8, 11, 9, 'Revisi bagian penutup.', '2025-05-17 17:07:46', '2025-05-17 17:07:46'),
(9, 12, 7, 'Revisi bagian penutup.', '2025-05-17 17:17:53', '2025-05-17 17:17:53'),
(10, 13, 7, 'Revisi bagian penutup.', '2025-05-19 01:23:26', '2025-05-19 01:23:26'),
(11, 14, 7, 'tess', '2025-06-19 04:12:17', '2025-06-19 04:12:17');

-- --------------------------------------------------------

--
-- Struktur dari tabel `komentar_logbook`
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
-- Dumping data untuk tabel `komentar_logbook`
--

INSERT INTO `komentar_logbook` (`id`, `logbook_id`, `dosen_id`, `comment`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Isi logbook masih kurang lengkap.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, 2, 2, 'Bagus, dokumentasi jelas.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, 3, 2, 'Tolong tambahkan ringkasan mingguan.', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(4, 1, 2, 'Dokumentasi minggu ini sudah baik.', '2025-05-05 03:49:49', '2025-05-05 03:49:49'),
(5, 5, 7, 'Dokumentasi minggu ini sudah baik.', '2025-05-17 18:25:31', '2025-05-17 18:25:31'),
(6, 5, 7, 'Dokumentasi minggu ini sudah baik.', '2025-05-19 01:24:26', '2025-05-19 01:24:26'),
(7, 13, 9, 'ress', '2025-06-10 17:45:22', '2025-06-10 17:45:22'),
(8, 5, 7, 'Tes', '2025-06-10 18:10:28', '2025-06-10 18:10:28'),
(9, 14, 7, 'tes komentar', '2025-06-13 01:19:56', '2025-06-13 01:19:56'),
(10, 15, 7, 'tess', '2025-06-21 18:15:28', '2025-06-21 18:15:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_pkl`
--

CREATE TABLE `laporan_pkl` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `data_pkl_id` bigint(20) UNSIGNED DEFAULT NULL,
  `users_id` bigint(20) UNSIGNED DEFAULT NULL,
  `report_date` date NOT NULL,
  `file_attachment` varchar(255) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `laporan_pkl`
--

INSERT INTO `laporan_pkl` (`id`, `data_pkl_id`, `users_id`, `report_date`, `file_attachment`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, '2025-04-01', 'laporan1.pdf', 'submitted', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, NULL, NULL, '2025-04-08', 'laporan2.pdf', 'reviewed', '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(10, 8, 11, '2025-05-16', 'laporan4.pdf', 'submitted', '2025-05-17 02:08:35', '2025-05-17 02:08:35'),
(11, 7, 10, '2025-05-16', 'laporan5.pdf', 'submitted', '2025-05-17 17:06:39', '2025-05-17 17:06:39'),
(12, 8, 11, '2025-05-16', 'laporan6.pdf', 'submitted', '2025-05-17 17:15:39', '2025-05-17 17:15:39'),
(13, 6, 6, '2025-05-16', 'laporan6.pdf', 'submitted', '2025-05-19 01:21:31', '2025-05-19 01:21:31'),
(14, 6, 6, '2025-06-19', 'laporan_pkl/laporan_pkl_1750328789_BoM87SBM55VllhH5is5lEGl3oz18sS2fVPH1LlsE.pdf', 'Diajukan', '2025-06-19 03:26:29', '2025-06-19 03:26:29'),
(15, 11, 14, '2025-06-22', 'laporan_pkl/laporan_pkl_1750554247_ZtDEEshMMoLrpuSpS7zYPYxfgwvHFXNJuAl8or5P.pdf', 'Diajukan', '2025-06-21 18:04:07', '2025-06-21 18:04:07');

-- --------------------------------------------------------

--
-- Struktur dari tabel `logbook`
--

CREATE TABLE `logbook` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `week_number` int(11) NOT NULL,
  `kegiatan` text DEFAULT NULL,
  `file_pdf` varchar(255) NOT NULL,
  `data_pkl_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `logbook`
--

INSERT INTO `logbook` (`id`, `week_number`, `kegiatan`, `file_pdf`, `data_pkl_id`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, 'logbook1.pdf', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(2, 2, NULL, 'logbook2.pdf', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(3, 3, NULL, 'logbook3.pdf', 1, '2025-04-30 02:44:35', '2025-04-30 02:44:35'),
(4, 4, NULL, 'logbook4.pdf', 1, '2025-05-04 18:01:16', '2025-05-04 18:02:41'),
(5, 6, NULL, 'logbook5.pdf', 6, '2025-05-17 17:52:49', '2025-05-17 17:55:17'),
(9, 1, NULL, 'generated_on_request', 6, '2025-06-09 17:12:54', '2025-06-09 17:12:54'),
(10, 2, NULL, 'generated_on_request', 6, '2025-06-09 17:45:53', '2025-06-09 17:45:53'),
(11, 3, '1233', 'generated_on_request', 6, '2025-06-09 17:57:23', '2025-06-09 18:15:36'),
(12, 1, 'sdsdsds', 'generated_on_request', 6, '2025-06-10 17:20:37', '2025-06-10 17:20:37'),
(13, 1, 'rteess', 'generated_on_request', 7, '2025-06-10 17:42:58', '2025-06-10 17:42:58'),
(14, 4, 'Logbook', 'generated_on_request', 6, '2025-06-13 01:18:42', '2025-06-13 01:18:42'),
(15, 1, 'tesss', 'generated_on_request', 11, '2025-06-21 18:03:28', '2025-06-21 18:03:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
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
(13, '2025_05_17_084848_add_users_id_to_laporan_pkl_table', 6),
(14, '2025_06_20_021603_add_avatar_to_users_table', 7),
(15, '2025_06_22_004902_add_nim_to_users_table', 8);

-- --------------------------------------------------------

--
-- Struktur dari tabel `notification`
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
-- Dumping data untuk tabel `notification`
--

INSERT INTO `notification` (`id`, `message`, `status`, `users_id`, `created_at`, `updated_at`) VALUES
(1, 'Laporan kamu sudah direview.', 'read', 1, NULL, NULL),
(2, 'Logbook minggu ke-2 ditolak.', 'unread', 1, NULL, NULL),
(3, 'PKL kamu disetujui.', 'unread', 1, NULL, NULL),
(4, 'PKL disetujui.', 'unread', 1, '2025-05-05 03:55:06', '2025-05-05 03:55:06');

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
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
-- Dumping data untuk tabel `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(7, 'App\\Models\\User', 8, 'auth_token', '3e7565f7040697585a7995dfd8ed99a06275a3d0865391105d7836ee6cb31527', '[\"*\"]', NULL, NULL, '2025-05-07 20:13:35', '2025-05-07 20:13:35'),
(8, 'App\\Models\\User', 8, 'auth_token', '8bd38fe255912ae2c7b231866bbb1ecdbdb48fbb4dd24e175b7ba9126aa7b181', '[\"*\"]', '2025-05-07 20:14:28', NULL, '2025-05-07 20:14:19', '2025-05-07 20:14:28'),
(9, 'App\\Models\\User', 8, 'auth_token', '656ee2ea3e24e23149d8136c17e87c8f6065095928c5b33919c1f0249c485b96', '[\"*\"]', NULL, NULL, '2025-05-07 20:17:19', '2025-05-07 20:17:19'),
(37, 'App\\Models\\User', 11, 'auth_token', '332421373394725f295e8c41e3b4b930e1179a3a10f5422701ce625e231250cd', '[\"*\"]', NULL, NULL, '2025-05-13 17:06:02', '2025-05-13 17:06:02'),
(38, 'App\\Models\\User', 11, 'auth_token', 'aea4b9ced7265ebb6fbc570689ce3aa5fd0edc6e1ede96c2ec8d0c108d7260d6', '[\"*\"]', '2025-05-17 02:08:35', NULL, '2025-05-13 17:06:22', '2025-05-17 02:08:35'),
(47, 'App\\Models\\User', 11, 'auth_token', '4e6fccdb6e8c4faab67262a172ec0607b510dc0f08a4fa96cee40693a475101a', '[\"*\"]', '2025-05-17 17:12:43', NULL, '2025-05-17 17:12:35', '2025-05-17 17:12:43'),
(49, 'App\\Models\\User', 11, 'auth_token', 'f4746c886576a432683a4a2381efae8ad59d376993748fe4536a2e4a9bb4755b', '[\"*\"]', '2025-05-17 17:15:47', NULL, '2025-05-17 17:14:40', '2025-05-17 17:15:47'),
(51, 'App\\Models\\User', 11, 'auth_token', '140b766f20adae9c8355ecfcd6658a35f7149c3fa1dcfcdca8a82a06edf2744f', '[\"*\"]', NULL, NULL, '2025-05-17 17:17:00', '2025-05-17 17:17:00'),
(52, 'App\\Models\\User', 11, 'auth_token', '4bbef33f705cab625d736d8f7424232f66b9c43378c5d08975173d87faa18ced', '[\"*\"]', '2025-05-17 17:34:14', NULL, '2025-05-17 17:18:56', '2025-05-17 17:34:14'),
(62, 'App\\Models\\User', 11, 'auth_token', 'a68eedf7ff8da7ec128c0c78121893681b9c2a70584655987945e960e24ababa', '[\"*\"]', '2025-05-18 02:28:09', NULL, '2025-05-18 02:24:57', '2025-05-18 02:28:09'),
(63, 'App\\Models\\User', 11, 'auth_token', 'ad5c8c2ff9c2c43cf6292c4692b97d3a314a8ab97de81b1309ab96de791bc281', '[\"*\"]', '2025-05-19 01:07:26', NULL, '2025-05-19 01:07:07', '2025-05-19 01:07:26'),
(126, 'App\\Models\\User', 6, 'auth_token', '04811b88002e1ead7cee0938ba5f120fd367cee478f72cdcdc7b16ec82a35d1e', '[\"*\"]', '2025-06-21 18:19:46', NULL, '2025-06-21 18:19:43', '2025-06-21 18:19:46');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `nim` varchar(255) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('mahasiswa','dosen','admin') NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `nim`, `email`, `email_verified_at`, `password`, `role`, `avatar`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Andi Mahasiswa', NULL, 'andi@example.com', NULL, '$2y$10$test1passwordhash', 'mahasiswa', NULL, 'token1', '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(2, 'Budi Dosen', NULL, 'budi@example.com', NULL, '$2y$10$test2passwordhash', 'dosen', NULL, 'token2', '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(3, 'Citra Admin', NULL, 'citra@example.com', NULL, '$2y$10$test3passwordhash', 'admin', NULL, 'token3', '2025-04-30 02:36:09', '2025-04-30 02:36:09'),
(4, 'Asep Dosen', NULL, 'asep@gmail.com', NULL, 'dospem123', 'dosen', NULL, 'token23', NULL, NULL),
(5, 'Alfan', NULL, 'alfan@example.com', NULL, 'alfan123', 'mahasiswa', NULL, NULL, '2025-05-04 17:12:35', '2025-05-04 17:12:35'),
(6, 'akun1', NULL, 'akun1@gmail.com', NULL, '$2y$12$1cUiAXEfV8Ccg7ug8TgUBOuwoQwqBlq0AzPEvMxx3lP2cNhSuh5ya', 'mahasiswa', 'avatars/6_1750399953.jpg', NULL, '2025-05-07 19:01:04', '2025-06-19 23:12:33'),
(7, 'dosen1', NULL, 'dosen1@gmail.com', NULL, '$2y$12$w1ROjNZj2UFf18.pVkPnF.ZRMuXUaUWEKM3GTD67UNm.f9gNiFmv2', 'dosen', NULL, NULL, '2025-05-07 20:01:43', '2025-05-07 20:01:43'),
(8, 'admin1', NULL, 'admin1@gmail.com', NULL, '$2y$12$Z0TpDcFCDhXFIqmcdyH2COgIVMoKwD0tVCxBD2hiTIdc7tDWBVUrG', 'admin', NULL, NULL, '2025-05-07 20:13:35', '2025-05-07 20:13:35'),
(9, 'dosen2', NULL, 'dosen2@gmail.com', NULL, '$2y$12$ysOMSJCEya9qRO.5vN7OpOOmm1xF0HZfnjuQwc8nctKmx768sLIF2', 'dosen', NULL, NULL, '2025-05-08 17:03:32', '2025-05-08 17:03:32'),
(10, 'mahasiswa2', NULL, 'akun2@gmail.com', NULL, '$2y$12$eikEi6Esfk7fJnGt4lEyJeIOjd3FfcpPH6q4hrGAqvXRnlXhGFbzW', 'mahasiswa', NULL, NULL, '2025-05-08 17:05:04', '2025-05-08 17:05:04'),
(11, 'mahasiswa3', NULL, 'akun3@gmail.com', NULL, '$2y$12$P0EJz6uqSdd/DUtKMTFonuHTWi6r4nLjBDULT8WjsLzjHVnK6OTDS', 'mahasiswa', NULL, NULL, '2025-05-13 17:06:02', '2025-05-13 17:06:02'),
(12, 'Muhammad Alfan Ridho', NULL, 'akun4@gmail.com', NULL, '$2y$12$lGrAJMtuHvzibINCx50TwOPZCA87lCBUMMeHbxV.K7yAP/CAQQXaG', 'mahasiswa', NULL, NULL, '2025-06-01 16:46:42', '2025-06-21 16:46:07'),
(13, 'admin', NULL, 'admin@gmail.com', NULL, '$2y$12$aa79K8Qpw.j2J1UbLgNHiuHQfk8qgr1f9uRqTX01VutTlTY0RSsZ6', 'admin', NULL, NULL, '2025-06-21 16:44:19', '2025-06-21 16:44:19'),
(14, 'alfan2', '0110222092', 'alfan2@gmail.com', NULL, '$2y$12$0xKnRL9sYAXlBye6I/eiQ.wbqUADXff38Buic.jVSAHDejdQx9uDy', 'mahasiswa', NULL, NULL, '2025-06-21 18:01:58', '2025-06-21 18:01:58');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `absen`
--
ALTER TABLE `absen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `data_pkl_id` (`data_pkl_id`);

--
-- Indeks untuk tabel `data_pkl`
--
ALTER TABLE `data_pkl`
  ADD PRIMARY KEY (`id`),
  ADD KEY `data_pkl_dosen_pembimbing_foreign` (`dosen_pembimbing`),
  ADD KEY `data_pkl_users_id_foreign` (`users_id`);

--
-- Indeks untuk tabel `komentar_laporan`
--
ALTER TABLE `komentar_laporan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `komentar_laporan_laporan_pkl_id_foreign` (`laporan_pkl_id`),
  ADD KEY `komentar_laporan_dosen_id_foreign` (`dosen_id`);

--
-- Indeks untuk tabel `komentar_logbook`
--
ALTER TABLE `komentar_logbook`
  ADD PRIMARY KEY (`id`),
  ADD KEY `komentar_logbook_logbook_id_foreign` (`logbook_id`),
  ADD KEY `komentar_logbook_dosen_id_foreign` (`dosen_id`);

--
-- Indeks untuk tabel `laporan_pkl`
--
ALTER TABLE `laporan_pkl`
  ADD PRIMARY KEY (`id`),
  ADD KEY `laporan_pkl_data_pkl_id_foreign` (`data_pkl_id`),
  ADD KEY `laporan_pkl_users_id_foreign` (`users_id`);

--
-- Indeks untuk tabel `logbook`
--
ALTER TABLE `logbook`
  ADD PRIMARY KEY (`id`),
  ADD KEY `logbook_data_pkl_id_foreign` (`data_pkl_id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notification_users_id_foreign` (`users_id`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_nim_unique` (`nim`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `absen`
--
ALTER TABLE `absen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `data_pkl`
--
ALTER TABLE `data_pkl`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `komentar_laporan`
--
ALTER TABLE `komentar_laporan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `komentar_logbook`
--
ALTER TABLE `komentar_logbook`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `laporan_pkl`
--
ALTER TABLE `laporan_pkl`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `logbook`
--
ALTER TABLE `logbook`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `notification`
--
ALTER TABLE `notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `absen`
--
ALTER TABLE `absen`
  ADD CONSTRAINT `absen_ibfk_1` FOREIGN KEY (`data_pkl_id`) REFERENCES `data_pkl` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `data_pkl`
--
ALTER TABLE `data_pkl`
  ADD CONSTRAINT `data_pkl_dosen_pembimbing_foreign` FOREIGN KEY (`dosen_pembimbing`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `data_pkl_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);

--
-- Ketidakleluasaan untuk tabel `komentar_laporan`
--
ALTER TABLE `komentar_laporan`
  ADD CONSTRAINT `komentar_laporan_dosen_id_foreign` FOREIGN KEY (`dosen_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `komentar_laporan_laporan_pkl_id_foreign` FOREIGN KEY (`laporan_pkl_id`) REFERENCES `laporan_pkl` (`id`);

--
-- Ketidakleluasaan untuk tabel `komentar_logbook`
--
ALTER TABLE `komentar_logbook`
  ADD CONSTRAINT `komentar_logbook_dosen_id_foreign` FOREIGN KEY (`dosen_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `komentar_logbook_logbook_id_foreign` FOREIGN KEY (`logbook_id`) REFERENCES `logbook` (`id`);

--
-- Ketidakleluasaan untuk tabel `laporan_pkl`
--
ALTER TABLE `laporan_pkl`
  ADD CONSTRAINT `laporan_pkl_data_pkl_id_foreign` FOREIGN KEY (`data_pkl_id`) REFERENCES `data_pkl` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `laporan_pkl_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `logbook`
--
ALTER TABLE `logbook`
  ADD CONSTRAINT `logbook_data_pkl_id_foreign` FOREIGN KEY (`data_pkl_id`) REFERENCES `data_pkl` (`id`);

--
-- Ketidakleluasaan untuk tabel `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
