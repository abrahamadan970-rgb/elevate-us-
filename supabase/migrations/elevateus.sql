-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2026 at 08:46 AM
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
-- Database: `elevateus`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_log`
--

INSERT INTO `activity_log` (`id`, `user_id`, `action`, `entity_type`, `entity_id`, `details`, `ip_address`, `created_at`) VALUES
(1, 1, 'add_member', 'members', 5, 'Added member: Tallia Natembea', '::1', '2026-05-01 21:02:55'),
(2, 1, 'delete_member', 'members', 4, 'Deleted member #4', '::1', '2026-05-01 21:05:36'),
(3, 1, 'delete_member', 'members', 1, 'Deleted member #1', '::1', '2026-05-01 21:05:40'),
(4, 1, 'delete_member', 'members', 2, 'Deleted member #2', '::1', '2026-05-01 21:05:44'),
(5, 1, 'delete_member', 'members', 3, 'Deleted member #3', '::1', '2026-05-01 21:05:47'),
(6, 1, 'add_member', 'members', 6, 'Added member: Dan  Simiyu', '::1', '2026-05-01 21:08:25'),
(7, 1, 'add_member', 'members', 7, 'Added member: Marcelinah Machiba', '::1', '2026-05-01 21:10:35'),
(8, 1, 'add_member', 'members', 8, 'Added member: Anthony cyril', '::1', '2026-05-01 21:12:50'),
(9, 1, 'add_member', 'members', 9, 'Added member: simiyu munialo', '::1', '2026-05-01 21:14:34'),
(10, 1, 'add_member', 'members', 10, 'Added member: okanga  cyril', '::1', '2026-05-01 21:15:50'),
(11, 1, 'add_member', 'members', 11, 'Added member: kenneth Okomba', '::1', '2026-05-01 21:16:35'),
(12, 1, 'record_subscription', 'subscriptions', 5, 'Subscription recorded for member #8', '::1', '2026-05-01 21:20:17'),
(13, 1, 'record_subscription', 'subscriptions', 6, 'Subscription recorded for member #6', '::1', '2026-05-01 21:21:11'),
(14, 1, 'record_subscription', 'subscriptions', 7, 'Subscription recorded for member #7', '::1', '2026-05-01 21:21:35'),
(15, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-01 21:22:12'),
(16, 1, 'record_subscription', 'subscriptions', 8, 'Subscription recorded for member #11', '::1', '2026-05-01 21:22:43'),
(17, 1, 'record_subscription', 'subscriptions', 9, 'Subscription recorded for member #8', '::1', '2026-05-01 21:24:03'),
(18, 1, 'record_subscription', 'subscriptions', 10, 'Subscription recorded for member #6', '::1', '2026-05-01 21:25:13'),
(19, 1, 'record_subscription', 'subscriptions', 11, 'Subscription recorded for member #11', '::1', '2026-05-01 21:25:52'),
(20, 1, 'record_subscription', 'subscriptions', 12, 'Subscription recorded for member #7', '::1', '2026-05-01 21:26:25'),
(21, 1, 'record_subscription', 'subscriptions', 13, 'Subscription recorded for member #6', '::1', '2026-05-01 21:28:24'),
(22, 1, 'record_subscription', 'subscriptions', 14, 'Subscription recorded for member #8', '::1', '2026-05-01 21:28:49'),
(23, 1, 'record_subscription', 'subscriptions', 15, 'Subscription recorded for member #11', '::1', '2026-05-01 21:29:31'),
(24, 1, 'record_subscription', 'subscriptions', 16, 'Subscription recorded for member #7', '::1', '2026-05-01 21:30:12'),
(25, 1, 'record_subscription', 'subscriptions', 17, 'Subscription recorded for member #8', '::1', '2026-05-01 21:31:23'),
(26, 1, 'record_subscription', 'subscriptions', 18, 'Subscription recorded for member #6', '::1', '2026-05-01 21:34:11'),
(27, 1, 'record_subscription', 'subscriptions', 19, 'Subscription recorded for member #11', '::1', '2026-05-01 21:34:40'),
(28, 1, 'record_subscription', 'subscriptions', 20, 'Subscription recorded for member #7', '::1', '2026-05-01 21:35:07'),
(29, 1, 'record_subscription', 'subscriptions', 21, 'Subscription recorded for member #8', '::1', '2026-05-01 21:36:34'),
(30, 1, 'record_subscription', 'subscriptions', 22, 'Subscription recorded for member #6', '::1', '2026-05-01 21:37:02'),
(31, 1, 'record_subscription', 'subscriptions', 23, 'Subscription recorded for member #11', '::1', '2026-05-01 21:37:46'),
(32, 1, 'record_subscription', 'subscriptions', 24, 'Subscription recorded for member #7', '::1', '2026-05-01 21:38:17'),
(33, 1, 'record_subscription', 'subscriptions', 25, 'Subscription recorded for member #8', '::1', '2026-05-01 21:39:47'),
(34, 1, 'record_subscription', 'subscriptions', 26, 'Subscription recorded for member #6', '::1', '2026-05-01 21:40:10'),
(35, 1, 'record_subscription', 'subscriptions', 27, 'Subscription recorded for member #11', '::1', '2026-05-01 21:40:27'),
(36, 1, 'record_subscription', 'subscriptions', 28, 'Subscription recorded for member #7', '::1', '2026-05-01 21:40:43'),
(37, 1, 'record_subscription', 'subscriptions', 29, 'Subscription recorded for member #8', '::1', '2026-05-01 21:42:10'),
(38, 1, 'record_subscription', 'subscriptions', 30, 'Subscription recorded for member #6', '::1', '2026-05-01 21:42:36'),
(39, 1, 'record_subscription', 'subscriptions', 31, 'Subscription recorded for member #11', '::1', '2026-05-01 21:43:04'),
(40, 1, 'record_subscription', 'subscriptions', 32, 'Subscription recorded for member #7', '::1', '2026-05-01 21:43:26'),
(41, 1, 'edit_member', 'members', 10, 'Updated member #10', '::1', '2026-05-01 21:44:56'),
(42, 1, 'edit_member', 'members', 5, 'Updated member #5', '::1', '2026-05-01 21:45:04'),
(43, 1, 'record_subscription', 'subscriptions', 33, 'Subscription recorded for member #8', '::1', '2026-05-01 21:45:39'),
(44, 1, 'record_subscription', 'subscriptions', 34, 'Subscription recorded for member #6', '::1', '2026-05-01 21:46:09'),
(45, 1, 'record_subscription', 'subscriptions', 35, 'Subscription recorded for member #11', '::1', '2026-05-01 21:46:35'),
(46, 1, 'record_subscription', 'subscriptions', 36, 'Subscription recorded for member #7', '::1', '2026-05-01 21:46:57'),
(47, 1, 'record_subscription', 'subscriptions', 37, 'Subscription recorded for member #10', '::1', '2026-05-01 21:47:53'),
(48, 1, 'record_subscription', 'subscriptions', 38, 'Subscription recorded for member #5', '::1', '2026-05-01 21:48:16'),
(49, 1, 'record_subscription', 'subscriptions', 39, 'Subscription recorded for member #8', '::1', '2026-05-01 21:49:20'),
(50, 1, 'record_subscription', 'subscriptions', 40, 'Subscription recorded for member #6', '::1', '2026-05-01 21:49:53'),
(51, 1, 'record_subscription', 'subscriptions', 41, 'Subscription recorded for member #11', '::1', '2026-05-01 21:50:20'),
(52, 1, 'record_subscription', 'subscriptions', 42, 'Subscription recorded for member #7', '::1', '2026-05-01 21:50:59'),
(53, 1, 'record_subscription', 'subscriptions', 43, 'Subscription recorded for member #10', '::1', '2026-05-01 21:51:29'),
(54, 1, 'record_subscription', 'subscriptions', 44, 'Subscription recorded for member #9', '::1', '2026-05-01 21:51:56'),
(55, 1, 'record_subscription', 'subscriptions', 45, 'Subscription recorded for member #5', '::1', '2026-05-01 21:52:25'),
(56, 1, 'record_subscription', 'subscriptions', 46, 'Subscription recorded for member #8', '::1', '2026-05-01 21:55:12'),
(57, 1, 'record_subscription', 'subscriptions', 47, 'Subscription recorded for member #6', '::1', '2026-05-01 21:55:35'),
(58, 1, 'record_subscription', 'subscriptions', 48, 'Subscription recorded for member #11', '::1', '2026-05-01 21:55:57'),
(59, 1, 'record_subscription', 'subscriptions', 49, 'Subscription recorded for member #7', '::1', '2026-05-01 21:56:26'),
(60, 1, 'record_subscription', 'subscriptions', 50, 'Subscription recorded for member #10', '::1', '2026-05-01 21:57:23'),
(61, 1, 'record_subscription', 'subscriptions', 51, 'Subscription recorded for member #9', '::1', '2026-05-01 21:57:48'),
(62, 1, 'record_subscription', 'subscriptions', 52, 'Subscription recorded for member #5', '::1', '2026-05-01 21:58:33'),
(63, 1, 'record_subscription', 'subscriptions', 53, 'Subscription recorded for member #8', '::1', '2026-05-01 22:02:16'),
(64, 1, 'record_subscription', 'subscriptions', 54, 'Subscription recorded for member #6', '::1', '2026-05-01 22:02:39'),
(65, 1, 'record_subscription', 'subscriptions', 55, 'Subscription recorded for member #11', '::1', '2026-05-01 22:03:02'),
(66, 1, 'record_subscription', 'subscriptions', 56, 'Subscription recorded for member #10', '::1', '2026-05-01 22:03:55'),
(67, 1, 'record_subscription', 'subscriptions', 57, 'Subscription recorded for member #9', '::1', '2026-05-01 22:04:23'),
(68, 1, 'record_subscription', 'subscriptions', 58, 'Subscription recorded for member #5', '::1', '2026-05-01 22:04:46'),
(69, 1, 'record_subscription', 'subscriptions', 59, 'Subscription recorded for member #7', '::1', '2026-05-01 22:05:36'),
(70, 1, 'record_subscription', 'subscriptions', 60, 'Subscription recorded for member #8', '::1', '2026-05-01 22:06:17'),
(71, 1, 'record_subscription', 'subscriptions', 61, 'Subscription recorded for member #6', '::1', '2026-05-01 22:06:49'),
(72, 1, 'record_subscription', 'subscriptions', 62, 'Subscription recorded for member #11', '::1', '2026-05-01 22:07:28'),
(73, 1, 'record_subscription', 'subscriptions', 63, 'Subscription recorded for member #7', '::1', '2026-05-01 22:07:48'),
(74, 1, 'record_subscription', 'subscriptions', 64, 'Subscription recorded for member #10', '::1', '2026-05-01 22:08:06'),
(75, 1, 'record_subscription', 'subscriptions', 65, 'Subscription recorded for member #9', '::1', '2026-05-01 22:08:29'),
(76, 1, 'record_subscription', 'subscriptions', 66, 'Subscription recorded for member #5', '::1', '2026-05-01 22:08:50'),
(77, 1, 'record_subscription', 'subscriptions', 67, 'Subscription recorded for member #8', '::1', '2026-05-01 22:09:38'),
(78, 1, 'record_subscription', 'subscriptions', 68, 'Subscription recorded for member #6', '::1', '2026-05-01 22:10:05'),
(79, 1, 'record_subscription', 'subscriptions', 69, 'Subscription recorded for member #11', '::1', '2026-05-01 22:10:33'),
(80, 1, 'record_subscription', 'subscriptions', 70, 'Subscription recorded for member #7', '::1', '2026-05-01 22:10:58'),
(81, 1, 'record_subscription', 'subscriptions', 71, 'Subscription recorded for member #10', '::1', '2026-05-01 22:11:24'),
(82, 1, 'record_subscription', 'subscriptions', 72, 'Subscription recorded for member #9', '::1', '2026-05-01 22:11:53'),
(83, 1, 'record_subscription', 'subscriptions', 73, 'Subscription recorded for member #5', '::1', '2026-05-01 22:12:16'),
(84, 1, 'record_subscription', 'subscriptions', 74, 'Subscription recorded for member #8', '::1', '2026-05-01 22:13:24'),
(85, 1, 'record_subscription', 'subscriptions', 75, 'Subscription recorded for member #6', '::1', '2026-05-01 22:13:49'),
(86, 1, 'record_subscription', 'subscriptions', 76, 'Subscription recorded for member #11', '::1', '2026-05-01 22:14:08'),
(87, 1, 'record_subscription', 'subscriptions', 77, 'Subscription recorded for member #7', '::1', '2026-05-01 22:14:45'),
(88, 1, 'record_subscription', 'subscriptions', 78, 'Subscription recorded for member #10', '::1', '2026-05-01 22:15:02'),
(89, 1, 'record_subscription', 'subscriptions', 79, 'Subscription recorded for member #9', '::1', '2026-05-01 22:15:50'),
(90, 1, 'record_subscription', 'subscriptions', 80, 'Subscription recorded for member #5', '::1', '2026-05-01 22:16:05'),
(91, 1, 'record_subscription', 'subscriptions', 81, 'Subscription recorded for member #8', '::1', '2026-05-01 22:16:53'),
(92, 1, 'record_subscription', 'subscriptions', 82, 'Subscription recorded for member #6', '::1', '2026-05-01 22:17:06'),
(93, 1, 'record_subscription', 'subscriptions', 83, 'Subscription recorded for member #11', '::1', '2026-05-01 22:17:23'),
(94, 1, 'record_subscription', 'subscriptions', 84, 'Subscription recorded for member #7', '::1', '2026-05-01 22:17:40'),
(95, 1, 'record_subscription', 'subscriptions', 85, 'Subscription recorded for member #10', '::1', '2026-05-01 22:18:00'),
(96, 1, 'record_subscription', 'subscriptions', 86, 'Subscription recorded for member #9', '::1', '2026-05-01 22:18:21'),
(97, 1, 'record_subscription', 'subscriptions', 87, 'Subscription recorded for member #5', '::1', '2026-05-01 22:19:03'),
(98, 1, 'record_subscription', 'subscriptions', 88, 'Subscription recorded for member #5', '::1', '2026-05-01 22:19:35'),
(99, 1, 'record_subscription', 'subscriptions', 89, 'Subscription recorded for member #9', '::1', '2026-05-01 22:19:53'),
(100, 1, 'record_subscription', 'subscriptions', 90, 'Subscription recorded for member #10', '::1', '2026-05-01 22:20:06'),
(101, 1, 'record_subscription', 'subscriptions', 91, 'Subscription recorded for member #7', '::1', '2026-05-01 22:20:25'),
(102, 1, 'record_subscription', 'subscriptions', 92, 'Subscription recorded for member #6', '::1', '2026-05-01 22:20:49'),
(103, 1, 'record_subscription', 'subscriptions', 93, 'Subscription recorded for member #8', '::1', '2026-05-01 22:21:08'),
(104, 1, 'record_subscription', 'subscriptions', 94, 'Subscription recorded for member #8', '::1', '2026-05-01 22:25:59'),
(105, 1, 'record_subscription', 'subscriptions', 95, 'Subscription recorded for member #6', '::1', '2026-05-01 22:26:20'),
(106, 1, 'record_subscription', 'subscriptions', 96, 'Subscription recorded for member #7', '::1', '2026-05-01 22:26:47'),
(107, 1, 'record_subscription', 'subscriptions', 97, 'Subscription recorded for member #10', '::1', '2026-05-01 22:27:13'),
(108, 1, 'record_subscription', 'subscriptions', 98, 'Subscription recorded for member #5', '::1', '2026-05-01 22:27:30'),
(109, 1, 'record_subscription', 'subscriptions', 99, 'Subscription recorded for member #9', '::1', '2026-05-01 22:27:49'),
(110, 1, 'record_subscription', 'subscriptions', 100, 'Subscription recorded for member #10', '::1', '2026-05-01 22:28:26'),
(111, 1, 'record_subscription', 'subscriptions', 101, 'Subscription recorded for member #7', '::1', '2026-05-01 22:28:40'),
(112, 1, 'record_subscription', 'subscriptions', 102, 'Subscription recorded for member #8', '::1', '2026-05-01 22:31:04'),
(113, 1, 'add_fine', 'fines', 1, 'Fine added for member #11', '::1', '2026-05-01 22:37:59'),
(114, 1, 'fine_paid', 'fines', 1, 'Fine marked as paid', '::1', '2026-05-01 22:38:12'),
(115, 1, 'add_fine', 'fines', 2, 'Fine added for member #11', '::1', '2026-05-01 22:39:40'),
(116, 1, 'fine_paid', 'fines', 2, 'Fine marked as paid', '::1', '2026-05-01 22:39:43'),
(117, 1, 'add_fine', 'fines', 3, 'Fine added for member #11', '::1', '2026-05-01 22:40:25'),
(118, 1, 'fine_paid', 'fines', 3, 'Fine marked as paid', '::1', '2026-05-01 22:40:30'),
(119, 1, 'add_fine', 'fines', 4, 'Fine added for member #7', '::1', '2026-05-01 22:41:21'),
(120, 1, 'fine_paid', 'fines', 4, 'Fine marked as paid', '::1', '2026-05-01 22:41:23'),
(121, 1, 'add_fine', 'fines', 5, 'Fine added for member #11', '::1', '2026-05-01 22:42:41'),
(122, 1, 'fine_paid', 'fines', 5, 'Fine marked as paid', '::1', '2026-05-01 22:42:47'),
(123, 1, 'add_fine', 'fines', 6, 'Fine added for member #7', '::1', '2026-05-01 22:43:43'),
(124, 1, 'fine_paid', 'fines', 6, 'Fine marked as paid', '::1', '2026-05-01 22:43:44'),
(125, 1, 'add_fine', 'fines', 7, 'Fine added for member #7', '::1', '2026-05-01 22:44:33'),
(126, 1, 'fine_paid', 'fines', 7, 'Fine marked as paid', '::1', '2026-05-01 22:44:37'),
(127, 1, 'add_fine', 'fines', 8, 'Fine added for member #11', '::1', '2026-05-01 22:45:49'),
(128, 1, 'fine_paid', 'fines', 8, 'Fine marked as paid', '::1', '2026-05-01 22:45:56'),
(129, 1, 'add_expense', 'expenses', 1, 'Expense: Ksh 400', '::1', '2026-05-01 22:49:08'),
(130, 1, 'add_expense', 'expenses', 2, 'Expense: Ksh 200', '::1', '2026-05-01 22:50:22'),
(131, 1, 'add_expense', 'expenses', 3, 'Expense: Ksh 400', '::1', '2026-05-01 22:51:11'),
(132, 1, 'add_expense', 'expenses', 4, 'Expense: Ksh 200', '::1', '2026-05-01 22:51:37'),
(133, 1, 'add_expense', 'expenses', 5, 'Expense: Ksh 400', '::1', '2026-05-01 22:52:30'),
(134, 1, 'add_expense', 'expenses', 6, 'Expense: Ksh 1500', '::1', '2026-05-01 22:54:03'),
(135, 1, 'add_expense', 'expenses', 7, 'Expense: Ksh 1500', '::1', '2026-05-01 22:54:48'),
(136, 1, 'add_expense', 'expenses', 8, 'Expense: Ksh 1400', '::1', '2026-05-01 22:55:27'),
(137, 1, 'add_expense', 'expenses', 9, 'Expense: Ksh 1750', '::1', '2026-05-01 22:56:21'),
(138, 1, 'add_expense', 'expenses', 10, 'Expense: Ksh 174', '::1', '2026-05-01 22:57:24'),
(139, 1, 'add_expense', 'expenses', 11, 'Expense: Ksh 500', '::1', '2026-05-01 22:58:24'),
(140, 1, 'add_event', 'events', 2, 'Event: end of april meeting', '::1', '2026-05-01 23:01:38'),
(141, 1, 'update_leadership', 'leadership', 5, 'Leadership updated: chairperson', '::1', '2026-05-01 23:03:32'),
(142, 1, 'update_leadership', 'leadership', 6, 'Leadership updated: secretary', '::1', '2026-05-01 23:04:16'),
(143, 1, 'update_leadership', 'leadership', 7, 'Leadership updated: treasurer', '::1', '2026-05-01 23:06:42'),
(144, 1, 'update_leadership', 'leadership', 8, 'Leadership updated: organizing_secretary', '::1', '2026-05-01 23:07:39'),
(145, 1, 'update_leadership', 'leadership', 9, 'Leadership updated: special_person', '::1', '2026-05-01 23:08:37'),
(146, 1, 'update_reserve', 'settings', NULL, 'Reserve set to 30%', '::1', '2026-05-01 23:15:35'),
(147, 1, 'update_reserve', 'settings', NULL, 'Reserve set to 25%', '::1', '2026-05-01 23:15:51'),
(148, 1, 'edit_member', 'members', 6, 'Updated member #6', '::1', '2026-05-02 09:57:33'),
(149, 1, 'issue_loan', 'loans', 1, 'Loan LOAN-2026-0001 issued: Ksh 6500 to member #6', '::1', '2026-05-02 09:58:11'),
(150, 1, 'issue_loan', 'loans', 2, 'Loan LOAN-2026-0001 issued: Ksh 6500 to member #6', '::1', '2026-05-02 10:01:32'),
(151, 1, 'issue_loan', 'loans', 3, 'Loan LOAN-2026-0002 issued: Ksh 505 to member #8', '::1', '2026-05-02 10:03:40'),
(152, 1, 'issue_loan', 'loans', 4, 'Loan LOAN-2026-0003 issued: Ksh 3000 to member #7', '::1', '2026-05-02 10:07:13'),
(153, 1, 'edit_member', 'members', 5, 'Updated member #5', '::1', '2026-05-02 10:11:41'),
(154, 1, 'issue_loan', 'loans', 5, 'Loan LOAN-2026-0004 issued: Ksh 3600 to member #5', '::1', '2026-05-02 10:12:19'),
(155, 1, 'issue_loan', 'loans', 6, 'Loan LOAN-2026-0005 issued: Ksh 4000 to member #9', '::1', '2026-05-02 10:14:39'),
(156, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-02 10:16:07'),
(157, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-02 10:19:00'),
(158, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-02 10:19:21'),
(159, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-02 10:21:41'),
(160, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-02 10:22:43'),
(161, 1, 'loan_repayment', 'loans', 3, 'Repayment of Ksh 542.25 for loan #3', '::1', '2026-05-02 10:32:23'),
(162, 1, 'loan_repayment', 'loans', 5, 'Repayment of Ksh 3837.00 for loan #5', '::1', '2026-05-02 10:45:33'),
(163, 1, 'record_interest', 'interest_payments', 1, 'Interest Ksh 325 (+ penalty Ksh 0) on loan #LOAN-2026-0001', '::1', '2026-05-02 10:47:26'),
(164, 1, 'update_reserve', 'settings', NULL, 'Reserve set to 25%', '::1', '2026-05-02 10:49:49'),
(165, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Anthony cyril (2026)', '::1', '2026-05-02 11:09:55'),
(166, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Dan Simiyu (2026)', '::1', '2026-05-02 11:10:43'),
(167, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for kenneth Okomba (2026)', '::1', '2026-05-02 11:11:04'),
(168, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Marcelinah Machiba (2024)', '::1', '2026-05-02 11:11:40'),
(169, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for kenneth Okomba (2024)', '::1', '2026-05-02 11:12:15'),
(170, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Dan Simiyu (2024)', '::1', '2026-05-02 11:12:39'),
(171, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Anthony cyril (2024)', '::1', '2026-05-02 11:12:54'),
(172, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Anthony cyril (2025)', '::1', '2026-05-02 11:13:40'),
(173, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Dan Simiyu (2025)', '::1', '2026-05-02 11:13:57'),
(174, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for kenneth Okomba (2025)', '::1', '2026-05-02 11:14:11'),
(175, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Marcelinah Machiba (2026)', '::1', '2026-05-02 11:14:24'),
(176, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Marcelinah Machiba (2025)', '::1', '2026-05-02 11:14:49'),
(177, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for okanga cyril (2025)', '::1', '2026-05-02 11:15:32'),
(178, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for simiyu munialo (2025)', '::1', '2026-05-02 11:15:51'),
(179, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Tallia Natembea (2025)', '::1', '2026-05-02 11:16:04'),
(180, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for okanga cyril (2026)', '::1', '2026-05-02 11:16:39'),
(181, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for simiyu munialo (2026)', '::1', '2026-05-02 11:16:45'),
(182, 1, 'membership_fee', 'membership_fees', 0, 'Membership fee Ksh 100 for Tallia Natembea (2026)', '::1', '2026-05-02 11:16:53'),
(183, 1, 'send_email', 'email', 6, 'Email to: simiyudan715@gmail.com', '::1', '2026-05-02 11:36:35'),
(184, 1, 'issue_loan', 'loans', 9, 'Loan LOAN-2026-0001 issued: Ksh 6500 to member #6', '::1', '2026-05-02 11:50:37'),
(185, 1, 'issue_loan', 'loans', 10, 'Loan LOAN-2026-0002 issued: Ksh 505 to member #8', '::1', '2026-05-02 11:51:52'),
(186, 1, 'issue_loan', 'loans', 11, 'Loan LOAN-2026-0003 issued: Ksh 3000 to member #7', '::1', '2026-05-02 11:53:28'),
(187, 1, 'issue_loan', 'loans', 12, 'Loan LOAN-2026-0004 issued: Ksh 3600 to member #5', '::1', '2026-05-02 11:54:27'),
(188, 1, 'issue_loan', 'loans', 13, 'Loan LOAN-2026-0005 issued: Ksh 4000 to member #9', '::1', '2026-05-02 11:55:35'),
(189, 1, 'record_subscription', 'subscriptions', 103, 'Subscription recorded for member #11', '::1', '2026-05-02 13:43:22'),
(190, 1, 'record_subscription', 'subscriptions', 104, 'Subscription recorded for member #11', '::1', '2026-05-02 13:44:35'),
(191, 1, 'issue_loan', 'loans', 14, 'Loan LOAN-2026-0006 issued: Ksh 5000 to member #11', '::1', '2026-05-02 13:46:40'),
(192, 1, 'bulk_interest', 'interest_payments', 2, 'Bulk interest January 2025: Ksh 33 (int=32 mpesa=1 pen=0)', '::1', '2026-05-02 17:50:31'),
(193, 1, 'bulk_interest', 'interest_payments', 3, 'Bulk interest January 2025: Ksh 33 (int=33 mpesa=0 pen=0)', '::1', '2026-05-03 14:05:37'),
(194, 1, 'bulk_interest', 'interest_payments', 4, 'Bulk interest February 2025: Ksh 251 (int=251 mpesa=0 pen=0)', '::1', '2026-05-03 14:06:10'),
(195, 1, 'bulk_interest', 'interest_payments', 5, 'Bulk interest March 2025: Ksh 402 (int=402 mpesa=0 pen=0)', '::1', '2026-05-03 14:06:32'),
(196, 1, 'bulk_interest', 'interest_payments', 6, 'Bulk interest April 2025: Ksh 275 (int=0 mpesa=0 pen=275)', '::1', '2026-05-03 14:06:49'),
(197, 1, 'bulk_interest', 'interest_payments', 7, 'Bulk interest May 2025: Ksh 275 (int=275 mpesa=0 pen=0)', '::1', '2026-05-03 14:07:10'),
(198, 1, 'bulk_interest', 'interest_payments', 8, 'Bulk interest June 2025: Ksh 166 (int=166 mpesa=0 pen=0)', '::1', '2026-05-03 14:07:34'),
(199, 1, 'bulk_interest', 'interest_payments', 9, 'Bulk interest July 2025: Ksh 400 (int=400 mpesa=0 pen=0)', '::1', '2026-05-03 14:07:52'),
(200, 1, 'bulk_interest', 'interest_payments', 10, 'Bulk interest August 2025: Ksh 450 (int=450 mpesa=0 pen=0)', '::1', '2026-05-03 14:08:11'),
(201, 1, 'bulk_interest', 'interest_payments', 11, 'Bulk interest September 2025: Ksh 1049 (int=1049 mpesa=0 pen=0)', '::1', '2026-05-03 14:08:31'),
(202, 1, 'bulk_interest', 'interest_payments', 12, 'Bulk interest October 2025: Ksh 426 (int=426 mpesa=0 pen=0)', '::1', '2026-05-03 14:08:56'),
(203, 1, 'bulk_interest', 'interest_payments', 13, 'Bulk interest November 2025: Ksh 979 (int=979 mpesa=0 pen=0)', '::1', '2026-05-03 14:09:13'),
(204, 1, 'bulk_interest', 'interest_payments', 14, 'Bulk interest December 2025: Ksh 702 (int=702 mpesa=0 pen=0)', '::1', '2026-05-03 14:09:39'),
(205, 1, 'bulk_interest', 'interest_payments', 15, 'Bulk interest January 2026: Ksh 1042 (int=1042 mpesa=0 pen=0)', '::1', '2026-05-03 14:10:03'),
(206, 1, 'bulk_interest', 'interest_payments', 16, 'Bulk interest February 2026: Ksh 3752 (int=3752 mpesa=0 pen=0)', '::1', '2026-05-03 14:10:27'),
(207, 1, 'bulk_interest', 'interest_payments', 17, 'Bulk interest April 2026: Ksh 951 (int=951 mpesa=0 pen=0)', '::1', '2026-05-03 14:16:23'),
(208, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-03 14:29:49'),
(209, 1, 'edit_member', 'members', 11, 'Updated member #11', '::1', '2026-05-03 15:02:49'),
(210, 1, 'update_reserve', 'settings', NULL, 'Reserve set to 25%', '::1', '2026-05-03 15:13:50'),
(211, 1, 'send_email', 'email', 8, 'Email to: cyrilanthony298@gmail.com', '::1', '2026-05-03 19:49:23'),
(212, 1, 'send_email', 'email', 7, 'Email to: machicelina@gmail.com', '::1', '2026-05-03 19:49:42'),
(213, 1, 'send_email', 'email', 7, 'Email to: machicelina@gmail.com', '::1', '2026-05-03 19:49:47'),
(214, 1, 'send_email', 'email', 7, 'Email to: machicelina@gmail.com', '::1', '2026-05-03 19:49:50'),
(215, 1, 'update_reserve', 'settings', NULL, 'Reserve set to 20%', '::1', '2026-05-09 17:38:18'),
(216, 1, 'add_event', 'events', 3, 'Event: may Monthly meeting ', '::1', '2026-05-27 05:05:12');

-- --------------------------------------------------------

--
-- Table structure for table `email_log`
--

CREATE TABLE `email_log` (
  `id` int(11) NOT NULL,
  `to_email` varchar(100) NOT NULL,
  `to_name` varchar(100) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `status` enum('sent','failed','pending') DEFAULT 'pending',
  `error_message` text DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `sent_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `email_log`
--

INSERT INTO `email_log` (`id`, `to_email`, `to_name`, `subject`, `body`, `status`, `error_message`, `sent_at`, `sent_by`, `created_at`) VALUES
(1, 'simiyudan715@gmail.com', 'Dan Simiyu', 'Welcome to ElevateUS Association!', 'Dear {{member_name}},\r\n\r\nWelcome to the ElevateUS Association! We are thrilled to have you as part of our growing family.\r\n\r\nMotto: &quot;Rise together, achieve more&quot;\r\n\r\nYour membership number is: {{member_number}}\r\nJoin Date: {{join_date}}\r\n\r\nPlease ensure your monthly contributions are paid on time.\r\n\r\nBest Regards,\r\nElevateUS Association', 'sent', '', '2026-05-02 11:36:35', 1, '2026-05-02 11:36:35'),
(2, 'cyrilanthony298@gmail.com', 'Anthony cyril', 'Monthly Subscription Reminder - ElevateUS', 'Dear {{member_name}},\r\n\r\nThis is a friendly reminder that your monthly subscription of Ksh {{amount}} for {{month}} is due.\r\n\r\nPlease make your payment at the earliest convenience to avoid penalties.\r\n\r\nBest Regards,\r\nElevateUS Treasurer', 'sent', '', '2026-05-03 19:49:23', 1, '2026-05-03 19:49:23'),
(3, 'machicelina@gmail.com', 'Marcelinah Machiba', 'Monthly Subscription Reminder - ElevateUS', 'Dear {{member_name}},\r\n\r\nThis is a friendly reminder that your monthly subscription of Ksh {{amount}} for {{month}} is due.\r\n\r\nPlease make your payment at the earliest convenience to avoid penalties.\r\n\r\nBest Regards,\r\nElevateUS Treasurer', 'sent', '', '2026-05-03 19:49:42', 1, '2026-05-03 19:49:42'),
(4, 'machicelina@gmail.com', 'Marcelinah Machiba', 'Monthly Subscription Reminder - ElevateUS', 'Dear {{member_name}},\r\n\r\nThis is a friendly reminder that your monthly subscription of Ksh {{amount}} for {{month}} is due.\r\n\r\nPlease make your payment at the earliest convenience to avoid penalties.\r\n\r\nBest Regards,\r\nElevateUS Treasurer', 'sent', '', '2026-05-03 19:49:46', 1, '2026-05-03 19:49:46'),
(5, 'machicelina@gmail.com', 'Marcelinah Machiba', 'Monthly Subscription Reminder - ElevateUS', 'Dear {{member_name}},\r\n\r\nThis is a friendly reminder that your monthly subscription of Ksh {{amount}} for {{month}} is due.\r\n\r\nPlease make your payment at the earliest convenience to avoid penalties.\r\n\r\nBest Regards,\r\nElevateUS Treasurer', 'sent', '', '2026-05-03 19:49:50', 1, '2026-05-03 19:49:50');

-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE `email_templates` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `variables` text DEFAULT NULL COMMENT 'JSON list of available variables',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `email_templates`
--

INSERT INTO `email_templates` (`id`, `name`, `subject`, `body`, `variables`, `created_at`, `updated_at`) VALUES
(1, 'Welcome', 'Welcome to ElevateUS Association!', 'Dear {{member_name}},\n\nWelcome to the ElevateUS Association! We are thrilled to have you as part of our growing family.\n\nMotto: \"Rise together, achieve more\"\n\nYour membership number is: {{member_number}}\nJoin Date: {{join_date}}\n\nPlease ensure your monthly contributions are paid on time.\n\nBest Regards,\nElevateUS Association', '[\"member_name\",\"member_number\",\"join_date\"]', '2026-05-01 20:54:14', '2026-05-01 20:54:14'),
(2, 'Subscription Reminder', 'Monthly Subscription Reminder - ElevateUS', 'Dear {{member_name}},\n\nThis is a friendly reminder that your monthly subscription of Ksh {{amount}} for {{month}} is due.\n\nPlease make your payment at the earliest convenience to avoid penalties.\n\nBest Regards,\nElevateUS Treasurer', '[\"member_name\",\"amount\",\"month\"]', '2026-05-01 20:54:14', '2026-05-01 20:54:14'),
(3, 'Loan Approved', 'Loan Approved - ElevateUS', 'Dear {{member_name}},\n\nYour loan application of Ksh {{amount}} has been approved.\n\nLoan Details:\n- Principal: Ksh {{principal}}\n- Interest (5%/month): Ksh {{interest}}\n- M-Pesa Cost: Ksh {{mpesa_cost}}\n- Total Payable: Ksh {{total_payable}}\n- Due Date: {{due_date}}\n\nBest Regards,\nElevateUS Association', '[\"member_name\",\"amount\",\"principal\",\"interest\",\"mpesa_cost\",\"total_payable\",\"due_date\"]', '2026-05-01 20:54:14', '2026-05-01 20:54:14');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `event_type` enum('agm','board_meeting','general_meeting','special_meeting','social','other') DEFAULT 'general_meeting',
  `description` text DEFAULT NULL,
  `event_date` date NOT NULL,
  `event_time` time DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `status` enum('scheduled','completed','cancelled','postponed') DEFAULT 'scheduled',
  `minutes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `title`, `event_type`, `description`, `event_date`, `event_time`, `location`, `status`, `minutes`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'Founding Meeting - ElevateUS Launch', 'special_meeting', 'The inaugural meeting of ElevateUS Association where founding members formalized the association, elected leadership, and agreed on the constitution and financial rules.', '2024-11-01', '14:00:00', 'Nairobi, Kenya', 'completed', NULL, 1, '2026-05-01 20:54:14', '2026-05-01 20:54:14'),
(2, 'end of april meeting', 'general_meeting', '', '2026-05-03', '09:30:00', 'google meet', 'scheduled', '', 1, '2026-05-01 23:01:38', '2026-05-02 17:29:04'),
(3, 'may Monthly meeting', 'general_meeting', 'end of may meeting', '2026-06-06', '21:00:00', 'google meet', 'scheduled', NULL, 1, '2026-05-27 05:05:12', '2026-05-27 05:05:12');

-- --------------------------------------------------------

--
-- Table structure for table `event_attendance`
--

CREATE TABLE `event_attendance` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `status` enum('present','absent','excused') DEFAULT 'present',
  `notes` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `description` text NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `expense_date` date NOT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `receipt_number` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `category_id`, `description`, `amount`, `expense_date`, `approved_by`, `receipt_number`, `notes`, `recorded_by`, `created_at`, `updated_at`) VALUES
(3, 4, 'fruits', 400.00, '2025-04-02', 1, '001', 'get well token', 1, '2026-05-01 22:51:11', '2026-05-01 22:51:11'),
(4, 4, 'fruits', 200.00, '2025-05-02', 1, '002', '', 1, '2026-05-01 22:51:37', '2026-05-01 22:51:37'),
(5, 2, 'soda sharing', 400.00, '2025-10-02', 1, '003', '', 1, '2026-05-01 22:52:30', '2026-05-01 22:52:30'),
(6, 2, 'graduation gift for Linah', 1500.00, '2025-11-02', 1, '004', '', 1, '2026-05-01 22:54:03', '2026-05-01 22:54:03'),
(7, 2, 'graduation gifts for cyril', 1500.00, '2026-12-15', 1, '005', '', 1, '2026-05-01 22:54:48', '2026-05-01 22:54:48'),
(8, 2, 'christmas tokens', 1400.00, '2025-12-25', 1, '006', '', 1, '2026-05-01 22:55:27', '2026-05-01 22:55:27'),
(9, 2, 'valentine token', 1750.00, '2026-02-14', 1, '007', '', 1, '2026-05-01 22:56:21', '2026-05-01 22:56:21'),
(10, 1, 'book', 174.00, '2026-03-02', 1, '008', '', 1, '2026-05-01 22:57:24', '2026-05-01 22:57:24'),
(11, 4, 'Get well token for linah', 500.00, '2026-03-02', 1, '009', '', 1, '2026-05-01 22:58:24', '2026-05-01 22:58:24');

-- --------------------------------------------------------

--
-- Table structure for table `expense_categories`
--

CREATE TABLE `expense_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `expense_categories`
--

INSERT INTO `expense_categories` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'Operations', 'Day to day operational expenses', '2026-05-01 20:54:14'),
(2, 'Events', 'Expenses related to events and meetings', '2026-05-01 20:54:14'),
(3, 'Communication', 'Phone, internet, printing', '2026-05-01 20:54:14'),
(4, 'Welfare', 'Member welfare activities', '2026-05-01 20:54:14'),
(5, 'Emergency', 'Emergency fund expenses', '2026-05-01 20:54:14'),
(6, 'Other', 'Miscellaneous expenses', '2026-05-01 20:54:14');

-- --------------------------------------------------------

--
-- Table structure for table `fines`
--

CREATE TABLE `fines` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `fine_type` enum('lateness','absence','misconduct','other') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reason` text NOT NULL,
  `fine_date` date NOT NULL,
  `status` enum('pending','paid','waived') DEFAULT 'pending',
  `paid_date` date DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fines`
--

INSERT INTO `fines` (`id`, `member_id`, `fine_type`, `amount`, `reason`, `fine_date`, `status`, `paid_date`, `recorded_by`, `created_at`, `updated_at`) VALUES
(2, 11, 'absence', 50.00, 'meeting absence', '2025-12-02', 'paid', '2026-05-02', 1, '2026-05-01 22:39:40', '2026-05-01 22:39:43'),
(3, 11, 'lateness', 9.00, 'late payment', '2025-05-02', 'paid', '2026-05-02', 1, '2026-05-01 22:40:25', '2026-05-01 22:40:30'),
(5, 11, 'lateness', 1101.00, 'default loan', '2026-01-15', 'paid', '2026-05-02', 1, '2026-05-01 22:42:41', '2026-05-01 22:42:47'),
(7, 7, 'lateness', 20.00, 'surpass account spenditure', '2025-12-02', 'paid', '2026-05-02', 1, '2026-05-01 22:44:33', '2026-05-01 22:44:37'),
(8, 11, 'lateness', 400.00, 'default loan', '2026-03-02', 'paid', '2026-05-02', 1, '2026-05-01 22:45:49', '2026-05-01 22:45:56');

-- --------------------------------------------------------

--
-- Table structure for table `interest_payments`
--

CREATE TABLE `interest_payments` (
  `id` int(11) NOT NULL,
  `loan_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `interest_month` date DEFAULT NULL,
  `principal_amount` decimal(10,2) NOT NULL COMMENT 'Loan principal at time of interest payment',
  `interest_rate` decimal(5,2) NOT NULL COMMENT '% per month',
  `interest_amount` decimal(10,2) NOT NULL COMMENT 'Actual interest collected',
  `penalty_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'Late penalty collected',
  `mpesa_cost` decimal(10,2) DEFAULT 0.00,
  `payment_date` date NOT NULL,
  `payment_method` enum('cash','mpesa','bank','other') DEFAULT 'cash',
  `mpesa_code` varchar(20) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `entry_type` varchar(50) DEFAULT 'individual',
  `total_earned` decimal(10,2) GENERATED ALWAYS AS (`interest_amount` + `penalty_amount`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `interest_payments`
--

INSERT INTO `interest_payments` (`id`, `loan_id`, `member_id`, `interest_month`, `principal_amount`, `interest_rate`, `interest_amount`, `penalty_amount`, `mpesa_cost`, `payment_date`, `payment_method`, `mpesa_code`, `notes`, `description`, `recorded_by`, `created_at`, `entry_type`) VALUES
(3, NULL, NULL, '2025-01-01', 0.00, 5.00, 33.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:05:37', 'bulk'),
(4, NULL, NULL, '2025-02-01', 0.00, 5.00, 251.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:06:10', 'bulk'),
(5, NULL, NULL, '2025-03-01', 0.00, 5.00, 402.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:06:32', 'bulk'),
(6, NULL, NULL, '2025-04-01', 0.00, 5.00, 0.00, 275.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:06:49', 'bulk'),
(7, NULL, NULL, '2025-05-01', 0.00, 5.00, 275.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:07:10', 'bulk'),
(8, NULL, NULL, '2025-06-01', 0.00, 5.00, 166.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:07:34', 'bulk'),
(9, NULL, NULL, '2025-07-01', 0.00, 5.00, 400.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:07:52', 'bulk'),
(10, NULL, NULL, '2025-08-01', 0.00, 5.00, 450.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:08:11', 'bulk'),
(11, NULL, NULL, '2025-09-01', 0.00, 5.00, 1049.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:08:31', 'bulk'),
(12, NULL, NULL, '2025-10-01', 0.00, 5.00, 426.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:08:56', 'bulk'),
(13, NULL, NULL, '2025-11-01', 0.00, 5.00, 979.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:09:13', 'bulk'),
(14, NULL, NULL, '2025-12-01', 0.00, 5.00, 702.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:09:39', 'bulk'),
(15, NULL, NULL, '2026-01-01', 0.00, 5.00, 1042.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:10:02', 'bulk'),
(16, NULL, NULL, '2026-02-01', 0.00, 5.00, 3752.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:10:27', 'bulk'),
(17, NULL, NULL, '2026-04-01', 0.00, 5.00, 951.00, 0.00, 0.00, '2026-05-03', 'cash', '', '', '', 1, '2026-05-03 14:16:23', 'bulk');

-- --------------------------------------------------------

--
-- Table structure for table `leadership`
--

CREATE TABLE `leadership` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `position` enum('chairperson','secretary','treasurer','organizing_secretary','special_person','vice_chairperson','other') NOT NULL,
  `position_label` varchar(100) DEFAULT NULL,
  `functions` text DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leadership`
--

INSERT INTO `leadership` (`id`, `member_id`, `position`, `position_label`, `functions`, `start_date`, `end_date`, `is_current`, `created_at`) VALUES
(5, 6, 'chairperson', 'MR', 'Will be the overall leader of the society.\r\nWill chair all meetings of the society.\r\nWill approve all minutes and announcements before being passed to members.\r\nWill be the signatory of the society’s account.\r\nWill be the spokesperson of the association', '2024-11-01', NULL, 1, '2026-05-01 23:03:32'),
(6, 8, 'secretary', 'MR', 'Will write the minutes of the meetings held.\r\nWill be in charge of keeping all records of the society.\r\nWill make announcements to members.\r\nWill be the signatory of society’s account.\r\nWill be in-charge of taking care and protecting property of the society.', '2024-11-01', NULL, 1, '2026-05-01 23:04:16'),
(7, 7, 'treasurer', 'Miss', 'Will keep accurate financial records of the association \r\nWill give comprehensive financial reports during meetings.\r\nWill be a signatory of the association’s account.\r\nWill be in charge of disbursing and receiving loans and savings from members.', '2024-11-01', NULL, 1, '2026-05-01 23:06:42'),
(8, 11, 'organizing_secretary', 'MR', 'Coordinate and organize all activities of the society.\r\nGive updates of upcoming activities \r\nArrange all activities of the association.', '2024-11-01', NULL, 1, '2026-05-01 23:07:39'),
(9, 5, 'special_person', 'Miss', 'Will be the first of communication between members and the committee \r\nWill establish the extent of the problems.\r\nWill make follow up on members and leaders.\r\nPreside over the daily operations of the association.', '2026-02-02', NULL, 1, '2026-05-01 23:08:37');

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `id` int(11) NOT NULL,
  `loan_number` varchar(20) NOT NULL,
  `member_id` int(11) NOT NULL,
  `principal_amount` decimal(10,2) NOT NULL,
  `interest_rate` decimal(5,2) DEFAULT 5.00 COMMENT 'Percent per month',
  `mpesa_cost` decimal(10,2) DEFAULT 0.00,
  `total_payable` decimal(10,2) NOT NULL,
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('active','paid','overdue','defaulted','cancelled') DEFAULT 'active',
  `purpose` text DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `total_earned` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`id`, `loan_number`, `member_id`, `principal_amount`, `interest_rate`, `mpesa_cost`, `total_payable`, `issue_date`, `due_date`, `status`, `purpose`, `approved_by`, `created_at`, `updated_at`, `total_earned`) VALUES
(9, 'LOAN-2026-0001', 6, 6500.00, 5.00, 78.00, 6903.00, '2026-05-24', '2026-06-24', 'overdue', '', 1, '2026-05-02 11:50:37', '2026-06-25 03:21:35', 0.00),
(10, 'LOAN-2026-0002', 8, 505.00, 5.00, 13.00, 543.25, '2026-05-20', '2026-06-20', 'overdue', '', 1, '2026-05-02 11:51:51', '2026-06-25 03:21:35', 0.00),
(11, 'LOAN-2026-0003', 7, 3000.00, 5.00, 53.00, 3203.00, '2026-04-14', '2026-05-14', 'overdue', '', 1, '2026-05-02 11:53:28', '2026-05-27 05:02:36', 0.00),
(12, 'LOAN-2026-0004', 5, 3600.00, 5.00, 57.00, 3837.00, '2026-04-22', '2026-05-22', 'overdue', '', 1, '2026-05-02 11:54:27', '2026-05-27 05:02:36', 0.00),
(13, 'LOAN-2026-0005', 9, 4000.00, 5.00, 57.00, 4257.00, '2026-04-09', '2026-05-09', 'overdue', '', 1, '2026-05-02 11:55:35', '2026-05-27 05:02:36', 0.00),
(14, 'LOAN-2026-0006', 11, 5000.00, 5.00, 57.00, 5307.00, '2026-05-02', '2026-06-02', 'overdue', '', 1, '2026-05-02 13:46:40', '2026-06-25 03:21:35', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `loan_repayments`
--

CREATE TABLE `loan_repayments` (
  `id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `principal_paid` decimal(10,2) DEFAULT 0.00,
  `interest_paid` decimal(10,2) DEFAULT 0.00,
  `payment_date` date NOT NULL,
  `payment_method` enum('cash','mpesa','bank','other') DEFAULT 'cash',
  `mpesa_code` varchar(20) DEFAULT NULL,
  `penalty_applied` decimal(10,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `repayment_type` enum('partial','full','topup_clearance') DEFAULT 'partial',
  `topup_id` int(11) DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loan_topups`
--

CREATE TABLE `loan_topups` (
  `id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `topup_number` varchar(30) NOT NULL COMMENT 'e.g. TOPUP-2025-0001',
  `original_principal` decimal(10,2) NOT NULL,
  `topup_amount` decimal(10,2) NOT NULL COMMENT 'The extra amount added (max 50% of original principal)',
  `new_principal` decimal(10,2) NOT NULL COMMENT 'original_principal + topup_amount',
  `interest_rate` decimal(5,2) DEFAULT 5.00,
  `mpesa_cost` decimal(10,2) DEFAULT 0.00,
  `new_total_payable` decimal(10,2) NOT NULL,
  `new_due_date` date NOT NULL,
  `topup_date` date NOT NULL,
  `purpose` text DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `member_number` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `id_number` varchar(20) DEFAULT NULL,
  `join_date` date NOT NULL,
  `leave_date` date DEFAULT NULL,
  `status` enum('active','inactive','suspended','left') DEFAULT 'active',
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `member_number`, `first_name`, `last_name`, `phone`, `email`, `id_number`, `join_date`, `leave_date`, `status`, `notes`, `created_by`, `created_at`, `updated_at`) VALUES
(5, 'ELV-005', 'Tallia', 'Natembea', '254114388008', 'natembeatallia@gmail.com', '42709400', '2025-07-02', NULL, 'active', '', 1, '2026-05-01 21:02:55', '2026-05-02 10:11:41'),
(6, 'ELV-006', 'Dan', 'Simiyu', '0113068059', 'simiyudan715@gmail.com', '40275633', '2024-11-02', NULL, 'active', '', 1, '2026-05-01 21:08:25', '2026-05-02 09:57:32'),
(7, 'ELV-007', 'Marcelinah', 'Machiba', '0706927241', 'machicelina@gmail.com', '39966853', '2024-11-01', NULL, 'active', '', 1, '2026-05-01 21:10:35', '2026-05-01 21:10:35'),
(8, 'ELV-008', 'Anthony', 'cyril', '0769292171', 'cyrilanthony298@gmail.com', '40217276', '2024-12-01', NULL, 'active', '', 1, '2026-05-01 21:12:50', '2026-05-01 21:12:50'),
(9, 'ELV-009', 'simiyu', 'munialo', '0734900367', 'okellodanstar@gmail.com', '40275634', '2025-08-01', NULL, 'active', '', 1, '2026-05-01 21:14:34', '2026-05-01 21:14:34'),
(10, 'ELV-010', 'okanga', 'cyril', '+254700000007', 'okangacyril@gmail.com', '40217276', '2025-07-02', NULL, 'active', '', 1, '2026-05-01 21:15:50', '2026-05-01 21:44:56'),
(11, 'ELV-011', 'kenneth', 'Okomba', '+254700000008', 'kenethokomba@gmail.com', '42709401', '2024-11-02', '2026-04-01', 'active', '', 1, '2026-05-01 21:16:35', '2026-05-03 15:02:49');

-- --------------------------------------------------------

--
-- Table structure for table `membership_fees`
--

CREATE TABLE `membership_fees` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `fee_type_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `fee_year` year(4) NOT NULL COMMENT 'The year this fee covers',
  `payment_date` date NOT NULL,
  `payment_method` enum('cash','mpesa','bank','other') DEFAULT 'cash',
  `mpesa_code` varchar(20) DEFAULT NULL,
  `status` enum('paid','pending','waived') DEFAULT 'paid',
  `notes` text DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `membership_fees`
--

INSERT INTO `membership_fees` (`id`, `member_id`, `fee_type_id`, `amount`, `fee_year`, `payment_date`, `payment_method`, `mpesa_code`, `status`, `notes`, `recorded_by`, `created_at`, `updated_at`) VALUES
(1, 8, 1, 100.00, '2026', '2024-12-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:09:55', '2026-05-02 11:09:55'),
(2, 6, 1, 100.00, '2026', '2024-12-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:10:43', '2026-05-02 11:10:43'),
(3, 11, 1, 100.00, '2026', '2024-12-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:11:04', '2026-05-02 11:11:04'),
(8, 8, 1, 100.00, '2025', '2024-01-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:13:40', '2026-05-02 11:13:40'),
(9, 6, 1, 100.00, '2025', '2024-01-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:13:57', '2026-05-02 11:13:57'),
(10, 11, 1, 100.00, '2025', '2024-01-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:14:11', '2026-05-02 11:14:11'),
(11, 7, 1, 100.00, '2026', '2024-01-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:14:24', '2026-05-02 11:14:24'),
(12, 7, 1, 100.00, '2025', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:14:49', '2026-05-02 11:14:49'),
(13, 10, 1, 100.00, '2025', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:15:32', '2026-05-02 11:15:32'),
(14, 9, 1, 100.00, '2025', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:15:51', '2026-05-02 11:15:51'),
(15, 5, 1, 100.00, '2025', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:16:04', '2026-05-02 11:16:04'),
(16, 10, 1, 100.00, '2026', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:16:39', '2026-05-02 11:16:39'),
(17, 9, 1, 100.00, '2026', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:16:45', '2026-05-02 11:16:45'),
(18, 5, 1, 100.00, '2026', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-02 11:16:53', '2026-05-02 11:16:53');

-- --------------------------------------------------------

--
-- Table structure for table `membership_fee_types`
--

CREATE TABLE `membership_fee_types` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'e.g. Annual Membership Fee',
  `amount` decimal(10,2) NOT NULL,
  `effective_from` date NOT NULL,
  `effective_to` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `membership_fee_types`
--

INSERT INTO `membership_fee_types` (`id`, `name`, `amount`, `effective_from`, `effective_to`, `is_active`, `created_by`, `created_at`) VALUES
(1, 'Annual Membership Fee', 500.00, '2024-11-01', NULL, 0, NULL, '2026-05-02 10:39:17'),
(2, 'Annual Membership Fee', 100.00, '2024-11-01', NULL, 1, 1, '2026-05-02 11:10:30'),
(3, 'Annual Membership Fee', 500.00, '2024-11-01', NULL, 1, NULL, '2026-05-02 17:22:45');

-- --------------------------------------------------------

--
-- Table structure for table `reserve_settings`
--

CREATE TABLE `reserve_settings` (
  `id` int(11) NOT NULL,
  `percentage` decimal(5,2) DEFAULT 25.00,
  `effective_from` date NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reserve_settings`
--

INSERT INTO `reserve_settings` (`id`, `percentage`, `effective_from`, `created_by`, `created_at`) VALUES
(1, 25.00, '2024-11-01', NULL, '2026-05-01 20:54:14'),
(2, 30.00, '2026-05-02', 1, '2026-05-01 23:15:35'),
(3, 25.00, '2026-05-02', 1, '2026-05-01 23:15:51'),
(4, 25.00, '2026-05-02', 1, '2026-05-02 10:49:49'),
(5, 25.00, '2024-11-01', NULL, '2026-05-02 17:22:45'),
(6, 25.00, '2026-05-03', 1, '2026-05-03 15:13:50'),
(7, 20.00, '2026-05-09', 1, '2026-05-09 17:38:18');

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_month` date NOT NULL COMMENT 'First day of the month this covers',
  `payment_date` date NOT NULL,
  `payment_method` enum('cash','mpesa','bank','other') DEFAULT 'cash',
  `mpesa_code` varchar(20) DEFAULT NULL,
  `status` enum('paid','partial','pending') DEFAULT 'paid',
  `notes` text DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `member_id`, `amount`, `payment_month`, `payment_date`, `payment_method`, `mpesa_code`, `status`, `notes`, `recorded_by`, `created_at`, `updated_at`) VALUES
(5, 8, 200.00, '2024-12-01', '2024-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:20:17', '2026-05-01 21:20:17'),
(6, 6, 200.00, '2024-12-01', '2024-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:21:11', '2026-05-01 21:21:11'),
(7, 7, 200.00, '2024-12-01', '2026-05-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:21:35', '2026-05-01 21:21:35'),
(8, 11, 200.00, '2024-12-01', '2024-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:22:43', '2026-05-01 21:22:43'),
(9, 8, 250.00, '2025-01-01', '2025-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:24:03', '2026-05-01 21:24:03'),
(10, 6, 250.00, '2025-01-01', '2025-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:25:13', '2026-05-01 21:25:13'),
(11, 11, 250.00, '2025-01-01', '2025-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:25:52', '2026-05-01 21:25:52'),
(12, 7, 250.00, '2025-01-01', '2025-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:26:25', '2026-05-01 21:26:25'),
(13, 6, 250.00, '2025-02-01', '2025-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:28:24', '2026-05-01 21:28:24'),
(14, 8, 250.00, '2025-02-01', '2025-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:28:49', '2026-05-01 21:28:49'),
(15, 11, 250.00, '2025-02-01', '2025-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:29:31', '2026-05-01 21:29:31'),
(16, 7, 250.00, '2025-02-01', '2025-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:30:12', '2026-05-01 21:30:12'),
(17, 8, 250.00, '2025-03-01', '2025-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:31:23', '2026-05-01 21:31:23'),
(18, 6, 250.00, '2025-03-01', '2025-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:34:11', '2026-05-01 21:34:11'),
(19, 11, 250.00, '2025-03-01', '2025-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:34:40', '2026-05-01 21:34:40'),
(20, 7, 250.00, '2025-03-01', '2025-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:35:07', '2026-05-01 21:35:07'),
(21, 8, 250.00, '2025-04-01', '2025-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:36:34', '2026-05-01 21:36:34'),
(22, 6, 250.00, '2025-04-01', '2025-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:37:02', '2026-05-01 21:37:02'),
(23, 11, 250.00, '2025-04-01', '2025-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:37:46', '2026-05-01 21:37:46'),
(24, 7, 250.00, '2025-04-01', '2025-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:38:17', '2026-05-01 21:38:17'),
(25, 8, 250.00, '2025-05-01', '2025-05-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:39:47', '2026-05-01 21:39:47'),
(26, 6, 250.00, '2025-05-01', '2025-05-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:40:10', '2026-05-01 21:40:10'),
(27, 11, 250.00, '2025-05-01', '2025-05-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:40:27', '2026-05-01 21:40:27'),
(28, 7, 250.00, '2025-05-01', '2025-05-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:40:43', '2026-05-01 21:40:43'),
(29, 8, 300.00, '2025-06-01', '2025-06-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:42:10', '2026-05-01 21:42:10'),
(30, 6, 300.00, '2025-06-01', '2025-06-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:42:36', '2026-05-01 21:42:36'),
(31, 11, 300.00, '2025-06-01', '2025-06-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:43:04', '2026-05-01 21:43:04'),
(32, 7, 300.00, '2025-06-01', '2025-06-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:43:26', '2026-05-01 21:43:26'),
(33, 8, 300.00, '2025-07-01', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:45:39', '2026-05-01 21:45:39'),
(34, 6, 300.00, '2025-07-01', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:46:09', '2026-05-01 21:46:09'),
(35, 11, 300.00, '2025-07-01', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:46:35', '2026-05-01 21:46:35'),
(36, 7, 300.00, '2025-07-01', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:46:57', '2026-05-01 21:46:57'),
(37, 10, 300.00, '2025-07-01', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:47:53', '2026-05-01 21:47:53'),
(38, 5, 300.00, '2025-07-01', '2025-07-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:48:16', '2026-05-01 21:48:16'),
(39, 8, 300.00, '2025-08-01', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:49:20', '2026-05-01 21:49:20'),
(40, 6, 300.00, '2025-08-01', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:49:53', '2026-05-01 21:49:53'),
(41, 11, 300.00, '2025-08-01', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:50:20', '2026-05-01 21:50:20'),
(42, 7, 300.00, '2025-08-01', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:50:59', '2026-05-01 21:50:59'),
(43, 10, 300.00, '2025-08-01', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:51:29', '2026-05-01 21:51:29'),
(44, 9, 300.00, '2025-08-01', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:51:56', '2026-05-01 21:51:56'),
(45, 5, 300.00, '2025-08-01', '2025-08-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:52:25', '2026-05-01 21:52:25'),
(46, 8, 300.00, '2025-09-01', '2025-09-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:55:12', '2026-05-01 21:55:12'),
(47, 6, 300.00, '2025-09-01', '2025-09-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:55:35', '2026-05-01 21:55:35'),
(48, 11, 300.00, '2025-09-01', '2025-09-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:55:57', '2026-05-01 21:55:57'),
(49, 7, 300.00, '2025-09-01', '2025-09-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:56:26', '2026-05-01 21:56:26'),
(50, 10, 300.00, '2025-09-01', '2025-09-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:57:23', '2026-05-01 21:57:23'),
(51, 9, 300.00, '2025-09-01', '2025-09-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:57:48', '2026-05-01 21:57:48'),
(52, 5, 300.00, '2025-09-01', '2025-09-02', 'cash', '', 'paid', '', 1, '2026-05-01 21:58:33', '2026-05-01 21:58:33'),
(53, 8, 350.00, '2025-10-01', '2025-10-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:02:16', '2026-05-01 22:02:16'),
(54, 6, 350.00, '2025-10-01', '2025-10-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:02:39', '2026-05-01 22:02:39'),
(55, 11, 350.00, '2025-10-01', '2025-10-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:03:02', '2026-05-01 22:03:02'),
(56, 10, 350.00, '2025-10-01', '2025-10-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:03:55', '2026-05-01 22:03:55'),
(57, 9, 350.00, '2025-10-01', '2025-10-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:04:23', '2026-05-01 22:04:23'),
(58, 5, 350.00, '2025-10-01', '2025-10-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:04:46', '2026-05-01 22:04:46'),
(59, 7, 350.00, '2025-10-01', '2025-10-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:05:36', '2026-05-01 22:05:36'),
(60, 8, 350.00, '2025-11-01', '2025-11-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:06:17', '2026-05-01 22:06:17'),
(61, 6, 350.00, '2025-11-01', '2025-11-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:06:49', '2026-05-01 22:06:49'),
(62, 11, 350.00, '2025-11-01', '2025-11-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:07:28', '2026-05-01 22:07:28'),
(63, 7, 350.00, '2025-11-01', '2025-11-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:07:48', '2026-05-01 22:07:48'),
(64, 10, 350.00, '2025-11-01', '2025-11-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:08:06', '2026-05-01 22:08:06'),
(65, 9, 350.00, '2025-11-01', '2025-11-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:08:29', '2026-05-01 22:08:29'),
(66, 5, 350.00, '2025-11-01', '2025-11-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:08:50', '2026-05-01 22:08:50'),
(67, 8, 350.00, '2025-12-01', '2025-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:09:38', '2026-05-01 22:09:38'),
(68, 6, 350.00, '2025-12-01', '2025-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:10:05', '2026-05-01 22:10:05'),
(69, 11, 350.00, '2025-12-01', '2025-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:10:33', '2026-05-01 22:10:33'),
(70, 7, 350.00, '2025-12-01', '2025-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:10:58', '2026-05-01 22:10:58'),
(71, 10, 350.00, '2025-12-01', '2025-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:11:24', '2026-05-01 22:11:24'),
(72, 9, 350.00, '2025-12-01', '2025-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:11:53', '2026-05-01 22:11:53'),
(73, 5, 350.00, '2025-12-01', '2025-12-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:12:16', '2026-05-01 22:12:16'),
(74, 8, 350.00, '2026-01-01', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:13:24', '2026-05-01 22:13:24'),
(75, 6, 350.00, '2026-01-01', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:13:49', '2026-05-01 22:13:49'),
(76, 11, 350.00, '2026-01-01', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:14:08', '2026-05-01 22:14:08'),
(77, 7, 350.00, '2026-01-01', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:14:45', '2026-05-01 22:14:45'),
(78, 10, 350.00, '2026-01-01', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:15:02', '2026-05-01 22:15:02'),
(79, 9, 350.00, '2026-01-01', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:15:50', '2026-05-01 22:15:50'),
(80, 5, 350.00, '2026-01-01', '2026-01-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:16:05', '2026-05-01 22:16:05'),
(81, 8, 350.00, '2026-02-01', '2026-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:16:53', '2026-05-01 22:16:53'),
(82, 6, 350.00, '2026-02-01', '2026-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:17:06', '2026-05-01 22:17:06'),
(83, 11, 350.00, '2026-02-01', '2026-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:17:23', '2026-05-01 22:17:23'),
(84, 7, 350.00, '2026-02-01', '2026-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:17:40', '2026-05-01 22:17:40'),
(85, 10, 350.00, '2026-02-01', '2026-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:18:00', '2026-05-01 22:18:00'),
(86, 9, 350.00, '2026-02-01', '2026-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:18:21', '2026-05-01 22:18:21'),
(87, 5, 350.00, '2026-02-01', '2026-02-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:19:03', '2026-05-01 22:19:03'),
(88, 5, 350.00, '2026-03-01', '2026-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:19:35', '2026-05-01 22:19:35'),
(89, 9, 350.00, '2026-03-01', '2026-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:19:53', '2026-05-01 22:19:53'),
(90, 10, 350.00, '2026-03-01', '2026-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:20:06', '2026-05-01 22:20:06'),
(91, 7, 350.00, '2026-03-01', '2026-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:20:25', '2026-05-01 22:20:25'),
(92, 6, 350.00, '2026-03-01', '2026-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:20:49', '2026-05-01 22:20:49'),
(93, 8, 350.00, '2026-03-01', '2026-03-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:21:08', '2026-05-01 22:21:08'),
(95, 6, 350.00, '2026-04-01', '2026-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:26:20', '2026-05-01 22:26:20'),
(98, 5, 350.00, '2026-04-01', '2026-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:27:30', '2026-05-01 22:27:30'),
(99, 9, 350.00, '2026-04-01', '2026-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:27:49', '2026-05-01 22:27:49'),
(100, 10, 350.00, '2026-04-01', '2026-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:28:26', '2026-05-01 22:28:26'),
(101, 7, 350.00, '2026-04-01', '2026-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:28:40', '2026-05-01 22:28:40'),
(102, 8, 350.00, '2026-04-01', '2026-04-02', 'cash', '', 'paid', '', 1, '2026-05-01 22:31:04', '2026-05-01 22:31:04');

-- --------------------------------------------------------

--
-- Table structure for table `subscription_rates`
--

CREATE TABLE `subscription_rates` (
  `id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `effective_from` date NOT NULL,
  `effective_to` date DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscription_rates`
--

INSERT INTO `subscription_rates` (`id`, `amount`, `effective_from`, `effective_to`, `created_by`, `created_at`) VALUES
(1, 200.00, '2024-12-01', '2026-05-02', NULL, '2026-05-01 20:54:14'),
(2, 200.00, '2024-12-01', '2026-05-02', 1, '2026-05-01 21:19:05'),
(3, 250.00, '2025-01-01', '2026-05-02', 1, '2026-05-01 21:23:36'),
(4, 300.00, '2025-06-01', '2026-05-02', 1, '2026-05-01 21:41:47'),
(5, 350.00, '2025-10-01', '2026-05-09', 1, '2026-05-01 22:01:42'),
(6, 400.00, '2026-05-01', '2026-05-09', 1, '2026-05-09 17:38:36'),
(7, 400.00, '2026-05-01', NULL, 1, '2026-05-09 17:38:41');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','leader','member') DEFAULT 'member',
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `last_ip` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `member_id`, `username`, `email`, `password_hash`, `role`, `is_active`, `last_login`, `last_ip`, `created_at`, `updated_at`) VALUES
(1, NULL, 'admin', 'elevateuskenya@gmail.com', '$2y$10$8K9VpXnEVD9S2I7.p9G2uOnM7pYf1vG8Wz4H6rJ9K2L3M4N5O6P7Q', 'admin', 1, NULL, NULL, '2026-05-01 20:54:14', '2026-05-01 20:58:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `email_log`
--
ALTER TABLE `email_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sent_by` (`sent_by`);

--
-- Indexes for table `email_templates`
--
ALTER TABLE `email_templates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `event_attendance`
--
ALTER TABLE `event_attendance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_attendance` (`event_id`,`member_id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `recorded_by` (`recorded_by`);

--
-- Indexes for table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `recorded_by` (`recorded_by`);

--
-- Indexes for table `interest_payments`
--
ALTER TABLE `interest_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loan_id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `recorded_by` (`recorded_by`);

--
-- Indexes for table `leadership`
--
ALTER TABLE `leadership`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `loan_number` (`loan_number`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loan_id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `recorded_by` (`recorded_by`),
  ADD KEY `fk_repayment_topup` (`topup_id`);

--
-- Indexes for table `loan_topups`
--
ALTER TABLE `loan_topups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `topup_number` (`topup_number`),
  ADD KEY `loan_id` (`loan_id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `member_number` (`member_number`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `membership_fees`
--
ALTER TABLE `membership_fees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_member_year` (`member_id`,`fee_year`),
  ADD KEY `fee_type_id` (`fee_type_id`),
  ADD KEY `recorded_by` (`recorded_by`);

--
-- Indexes for table `membership_fee_types`
--
ALTER TABLE `membership_fee_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `reserve_settings`
--
ALTER TABLE `reserve_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_member_month` (`member_id`,`payment_month`),
  ADD KEY `recorded_by` (`recorded_by`);

--
-- Indexes for table `subscription_rates`
--
ALTER TABLE `subscription_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=217;

--
-- AUTO_INCREMENT for table `email_log`
--
ALTER TABLE `email_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `email_templates`
--
ALTER TABLE `email_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `event_attendance`
--
ALTER TABLE `event_attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `expense_categories`
--
ALTER TABLE `expense_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `fines`
--
ALTER TABLE `fines`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `interest_payments`
--
ALTER TABLE `interest_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `leadership`
--
ALTER TABLE `leadership`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `loan_topups`
--
ALTER TABLE `loan_topups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `membership_fees`
--
ALTER TABLE `membership_fees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `membership_fee_types`
--
ALTER TABLE `membership_fee_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `reserve_settings`
--
ALTER TABLE `reserve_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `subscription_rates`
--
ALTER TABLE `subscription_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `email_log`
--
ALTER TABLE `email_log`
  ADD CONSTRAINT `email_log_ibfk_1` FOREIGN KEY (`sent_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `event_attendance`
--
ALTER TABLE `event_attendance`
  ADD CONSTRAINT `event_attendance_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `event_attendance_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `expense_categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `expenses_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `expenses_ibfk_3` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `fines`
--
ALTER TABLE `fines`
  ADD CONSTRAINT `fines_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fines_ibfk_2` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `interest_payments`
--
ALTER TABLE `interest_payments`
  ADD CONSTRAINT `interest_payments_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `interest_payments_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `interest_payments_ibfk_3` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `leadership`
--
ALTER TABLE `leadership`
  ADD CONSTRAINT `leadership_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  ADD CONSTRAINT `loans_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  ADD CONSTRAINT `fk_repayment_topup` FOREIGN KEY (`topup_id`) REFERENCES `loan_topups` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `loan_repayments_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_repayments_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_repayments_ibfk_3` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `loan_topups`
--
ALTER TABLE `loan_topups`
  ADD CONSTRAINT `loan_topups_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_topups_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_topups_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `members_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `membership_fees`
--
ALTER TABLE `membership_fees`
  ADD CONSTRAINT `membership_fees_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `membership_fees_ibfk_2` FOREIGN KEY (`fee_type_id`) REFERENCES `membership_fee_types` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `membership_fees_ibfk_3` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `membership_fee_types`
--
ALTER TABLE `membership_fee_types`
  ADD CONSTRAINT `membership_fee_types_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reserve_settings`
--
ALTER TABLE `reserve_settings`
  ADD CONSTRAINT `reserve_settings_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `subscriptions_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscriptions_ibfk_2` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `subscription_rates`
--
ALTER TABLE `subscription_rates`
  ADD CONSTRAINT `subscription_rates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
