-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Хост: h906161699.mysql
-- Время создания: Май 07 2025 г., 12:17
-- Версия сервера: 8.0.22-13
-- Версия PHP: 7.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `h906161699_catalogAuroraDSK`
--

-- --------------------------------------------------------

--
-- Структура таблицы `balconies`
--
-- Создание: Апр 29 2025 г., 14:03
--

DROP TABLE IF EXISTS `balconies`;
CREATE TABLE `balconies` (
  `ID` int NOT NULL,
  `project_id` int NOT NULL,
  `balcony_number` int NOT NULL,
  `balcony_size` decimal(10,2) NOT NULL COMMENT 'Площадь балкона (м²)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `bathrooms`
--
-- Создание: Апр 29 2025 г., 14:03
-- Последнее обновление: Май 03 2025 г., 14:41
--

DROP TABLE IF EXISTS `bathrooms`;
CREATE TABLE `bathrooms` (
  `ID` int NOT NULL,
  `project_id` int NOT NULL,
  `bathroom_number` int NOT NULL,
  `bathroom_size` decimal(10,2) NOT NULL COMMENT 'Площадь санузла (м²)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `bathrooms`
--

INSERT INTO `bathrooms` (`ID`, `project_id`, `bathroom_number`, `bathroom_size`) VALUES
(3, 12, 1, '2.07'),
(4, 12, 2, '4.83'),
(5, 12, 3, '2.07'),
(6, 12, 4, '4.83');

-- --------------------------------------------------------

--
-- Структура таблицы `bedrooms`
--
-- Создание: Апр 29 2025 г., 14:03
-- Последнее обновление: Май 03 2025 г., 14:41
--

DROP TABLE IF EXISTS `bedrooms`;
CREATE TABLE `bedrooms` (
  `ID` int NOT NULL,
  `project_id` int NOT NULL,
  `bedroom_number` int NOT NULL,
  `bedroom_size` decimal(10,2) NOT NULL COMMENT 'Площадь спальни (м²)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `bedrooms`
--

INSERT INTO `bedrooms` (`ID`, `project_id`, `bedroom_number`, `bedroom_size`) VALUES
(28, 12, 1, '10.80'),
(29, 12, 2, '17.10'),
(30, 12, 3, '13.20'),
(31, 12, 4, '10.80'),
(32, 12, 5, '17.10'),
(33, 12, 6, '13.20'),
(34, 12, 7, '10.80'),
(35, 12, 8, '17.10'),
(36, 12, 9, '13.20'),
(37, 12, 10, '10.80'),
(38, 12, 11, '17.10'),
(39, 12, 12, '13.20'),
(40, 12, 13, '10.80'),
(41, 12, 14, '17.10'),
(42, 12, 15, '13.20'),
(43, 12, 16, '10.80'),
(44, 12, 17, '17.10'),
(45, 12, 18, '13.20'),
(46, 12, 19, '10.80'),
(47, 12, 20, '17.10'),
(48, 12, 21, '13.20'),
(49, 12, 22, '10.80'),
(50, 12, 23, '17.10'),
(51, 12, 24, '13.20');

-- --------------------------------------------------------

--
-- Структура таблицы `projects`
--
-- Создание: Май 02 2025 г., 14:19
-- Последнее обновление: Май 03 2025 г., 14:41
--

DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `ID` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Описание проекта',
  `main_pic` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `floors` enum('1','2') COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_project` enum('Y','N') COLLATE utf8mb4_unicode_ci DEFAULT 'Y',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Примечания и особенности',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `model_3d_view` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ссылка на интерактивную 3D-модель',
  `model_3d_skp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Путь к файлу .skp модели',
  `embed_code` text COLLATE utf8mb4_unicode_ci,
  `rd_zip_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `projects`
--

INSERT INTO `projects` (`ID`, `name`, `description`, `main_pic`, `floors`, `has_project`, `notes`, `created_at`, `model_3d_view`, `model_3d_skp`, `embed_code`, `rd_zip_path`) VALUES
(7, 'Титан 101 м²', NULL, 'Uploads/6810dcd929ee7_Титан 101 с крышей и карнизами 2.png', '1', 'Y', '', '2025-04-29 14:06:17', NULL, NULL, NULL, NULL),
(8, 'Лагуна, 112', '', 'Uploads/6811b39983477_1. Общий вид на белом.png', '1', 'Y', '', '2025-04-30 05:22:33', NULL, NULL, NULL, NULL),
(9, 'Титан 124²', 'Домокомплект наружных стен из полистиролбетона Титан 124 м². \r\n\r\nВ наличии 3 комплекта, можно забрать в день оплаты.\r\nПлощадь внутренних помещений дома 124 м², размеры фундамента 12,0х12,0 с выступом под эркер 1,0х4,6 м.\r\n\r\nЕсли потребуется больше домокомплектов, отливка новых займет 5-7 дней на каждый.\r\n\r\nСтены толщиной 300 мм, высота стен 2,8 м.\r\nВозможны различные виды крыш - плоская, вальмовая или двускатная.\r\n\r\nБольше информации на сайте или по запросу.\r\nМожно съездить посмотреть эти дома в процессе строительства, некоторые уже подведенные под крышу с внутренними перегородками, некоторые - пустые коробки.\r\n\r\nВ стоимость включены только внешние несущие стены, не входит материал на внутренние перегородки, фундамент, перекрытия и крышу.\r\nСтоимость сборки на готовый фундамент около 100 тыс.руб., включая расходные материалы и стоимость крана без учета транспортировки до места монтажа.\r\n\r\nМонтаж наружных стен осуществляется за 1 рабочий день.\r\nМожно приехать в цех, посмотреть на готовые стенокомплекты, проверить комплектность и после оплаты сразу забрать.\r\n\r\nЯвляемся аккредитованным партнером ДомКлика, через нас можно одобрить ипотечный кредит и осуществить строительство дома.', 'Uploads/6813411f3cf68_Титан без гаража 124 м² со стропилами.png', '1', 'Y', '', '2025-05-01 09:38:39', NULL, NULL, NULL, NULL),
(12, 'Леонид', 'Двухэтажный большой дом с огромными окнами', 'Uploads/leonid/68161bbbd361b_Общий вид.png', '2', 'Y', '', '2025-05-03 13:34:17', 'https://skfb.ly/oLGOo', NULL, '<div class=\"sketchfab-embed-wrapper\"> <iframe title=\"Дом Леонида\" frameborder=\"0\" allowfullscreen mozallowfullscreen=\"true\" webkitallowfullscreen=\"true\" allow=\"autoplay; fullscreen; xr-spatial-tracking\" xr-spatial-tracking execution-while-out-of-viewport execution-while-not-rendered web-share src=\"https://sketchfab.com/models/2e647b50b53c4e11ba1e86e1fd5a16d1/embed\"> </iframe> <p style=\"font-size: 13px; font-weight: normal; margin: 5px; color: #4A4A4A;\"> <a href=\"https://sketchfab.com/3d-models/2e647b50b53c4e11ba1e86e1fd5a16d1?utm_medium=embed&utm_campaign=share-popup&utm_content=2e647b50b53c4e11ba1e86e1fd5a16d1\" target=\"_blank\" rel=\"nofollow\" style=\"font-weight: bold; color: #1CAAD9;\"> Дом Леонида </a> by <a href=\"https://sketchfab.com/AuroraDSK?utm_medium=embed&utm_campaign=share-popup&utm_content=2e647b50b53c4e11ba1e86e1fd5a16d1\" target=\"_blank\" rel=\"nofollow\" style=\"font-weight: bold; color: #1CAAD9;\"> Аврора ДСК </a> on <a href=\"https://sketchfab.com?utm_medium=embed&utm_campaign=share-popup&utm_content=2e647b50b53c4e11ba1e86e1fd5a16d1\" target=\"_blank\" rel=\"nofollow\" style=\"font-weight: bold; color: #1CAAD9;\">Sketchfab</a></p></div>', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `project_files`
--
-- Создание: Апр 29 2025 г., 13:36
-- Последнее обновление: Май 03 2025 г., 14:41
--

DROP TABLE IF EXISTS `project_files`;
CREATE TABLE `project_files` (
  `ID` int NOT NULL,
  `project_id` int NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Путь к файлу',
  `file_type` enum('pdf','dwg','3d','doc','xls','other') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Тип файла',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Оригинальное имя файла',
  `file_size` int DEFAULT NULL COMMENT 'Размер файла в байтах',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Описание файла',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `project_files`
--

INSERT INTO `project_files` (`ID`, `project_id`, `file_path`, `file_type`, `file_name`, `file_size`, `description`, `created_at`, `updated_at`) VALUES
(4, 7, 'Uploads/6810dcd92cc74_АР_Проект 2009_22.pdf', 'pdf', NULL, NULL, NULL, '2025-04-29 14:06:17', '2025-04-29 14:06:17'),
(5, 8, 'Uploads/6811b3998549f_Проект_Лагуна_КР_V_1_1.pdf', 'pdf', NULL, NULL, NULL, '2025-04-30 05:22:33', '2025-04-30 05:22:33'),
(6, 12, 'Uploads/leonid/68162b0d58720_Проект_КР_0211_2023_V_1_3.pdf', 'pdf', 'Проект_КР_0211_2023_V_1_3.pdf', NULL, NULL, '2025-05-03 14:41:17', '2025-05-03 14:41:17'),
(7, 12, 'Uploads/leonid/68162b0d59b82_Проект_АР_0211_2023_V_2.pdf', 'pdf', 'Проект_АР_0211_2023_V_2.pdf', NULL, NULL, '2025-05-03 14:41:17', '2025-05-03 14:41:17');

-- --------------------------------------------------------

--
-- Структура таблицы `project_images`
--
-- Создание: Апр 29 2025 г., 13:33
-- Последнее обновление: Май 03 2025 г., 14:41
--

DROP TABLE IF EXISTS `project_images`;
CREATE TABLE `project_images` (
  `ID` int NOT NULL,
  `project_id` int NOT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Альтернативный текст для изображения',
  `sort_order` int DEFAULT '0' COMMENT 'Порядок сортировки изображений',
  `is_main` enum('Y','N') COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT 'Является ли главным изображением',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `project_images`
--

INSERT INTO `project_images` (`ID`, `project_id`, `image_path`, `alt_text`, `sort_order`, `is_main`, `created_at`) VALUES
(17, 7, 'Uploads/6810dcd92b78b_Виз Титан Компакт 101 на белом обрезан.png', NULL, 0, 'N', '2025-04-29 14:06:17'),
(18, 7, 'Uploads/6810dcd92c346_Планировка Титан Компакт с размерами помещений и с сечением на белом.png', NULL, 0, 'N', '2025-04-29 14:06:17'),
(19, 7, 'Uploads/6810dcd92c438_Планировка Титан Компакт.png', NULL, 0, 'N', '2025-04-29 14:06:17'),
(20, 7, 'Uploads/6810dcd92c878_Титан Компакт 101 м² чистый плиты.png', NULL, 0, 'N', '2025-04-29 14:06:17'),
(21, 8, 'Uploads/6811b39983fe6_2. Общий вид на белом.png', NULL, 0, 'N', '2025-04-30 05:22:33'),
(22, 8, 'Uploads/6811b39984693_5. Планировка с сечением.png', NULL, 0, 'N', '2025-04-30 05:22:33'),
(23, 8, 'Uploads/6811b39984a97_7. С полным покрытием крышей.png', NULL, 0, 'N', '2025-04-30 05:22:33'),
(24, 12, 'Uploads/leonid/68162b0d55849_IMG-20240820-WA0029.jpg', NULL, 0, 'N', '2025-05-03 14:41:17'),
(25, 12, 'Uploads/leonid/68162b0d55ab4_Изображение WhatsApp 2024-11-06 в 16.42.53_17c7af5b.jpg', NULL, 0, 'N', '2025-05-03 14:41:17'),
(26, 12, 'Uploads/leonid/68162b0d55d7b_IMG_20241014_143925.jpg', NULL, 0, 'N', '2025-05-03 14:41:17'),
(27, 12, 'Uploads/leonid/68162b0d567e9_IMG_20241014_144157.jpg', NULL, 0, 'N', '2025-05-03 14:41:17'),
(28, 12, 'Uploads/leonid/68162b0d56ffc_IMG_20241014_145141.jpg', NULL, 0, 'N', '2025-05-03 14:41:17'),
(29, 12, 'Uploads/leonid/68162b0d57b2d_IMG_20241014_143610.jpg', NULL, 0, 'N', '2025-05-03 14:41:17');

-- --------------------------------------------------------

--
-- Структура таблицы `project_params`
--
-- Создание: Май 03 2025 г., 14:57
--

DROP TABLE IF EXISTS `project_params`;
CREATE TABLE `project_params` (
  `ID` int NOT NULL,
  `project_id` int NOT NULL,
  `foundation_shape` enum('Прямоугольный','Фигурный','Г-образный','П-образный','Другой') COLLATE utf8mb4_unicode_ci NOT NULL,
  `sizes` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Размеры по фундаменту (ДхШ)',
  `square_fund` decimal(10,2) DEFAULT NULL COMMENT 'Площадь фундамента (м²)',
  `total_area` decimal(10,2) DEFAULT '0.00',
  `square_1fl` decimal(10,2) DEFAULT NULL COMMENT 'Площадь 1 этажа (м²)',
  `square_2fl` decimal(10,2) DEFAULT NULL COMMENT 'Площадь 2 этажа (м²)',
  `square_terrace_1fl` decimal(10,2) DEFAULT NULL COMMENT 'Площадь террасы 1 этажа (м²)',
  `square_terrace_2fl` decimal(10,2) DEFAULT NULL COMMENT 'Площадь террасы 2 этажа (м²)',
  `kitchen_living_combined` enum('Y','N') COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT 'Совмещённая кухня-гостиная',
  `square_kitchen_living` decimal(10,2) DEFAULT NULL COMMENT 'Площадь кухни-гостиной (м²)',
  `square_kitchen` decimal(10,2) DEFAULT NULL COMMENT 'Площадь кухни (м²)',
  `square_living` decimal(10,2) DEFAULT NULL COMMENT 'Площадь гостиной (м²)',
  `master_bedroom` enum('Y','N') COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT 'Наличие мастер-спальни',
  `sq_master_bedroom` decimal(10,2) DEFAULT NULL COMMENT 'Площадь мастер-спальни (м²)',
  `dirt_room` decimal(10,2) DEFAULT NULL COMMENT 'Площадь постирочной (м²)',
  `tech_room` decimal(10,2) DEFAULT NULL COMMENT 'Площадь техпомещения (м²)',
  `sauna_room` enum('Y','N') COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT 'Наличие сауны',
  `sq_sauna_room` decimal(10,2) DEFAULT NULL COMMENT 'Площадь сауны (м²)',
  `ceiling_height` decimal(4,2) DEFAULT NULL COMMENT 'Высота потолков (м)',
  `roof_type` enum('Двускатная','Вальмовая','Плоская','Мансардная','Другая') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Тип крыши',
  `wall_material` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Материал стен',
  `foundation_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Тип фундамента',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Параметры проекта';

--
-- Дамп данных таблицы `project_params`
--

INSERT INTO `project_params` (`ID`, `project_id`, `foundation_shape`, `sizes`, `square_fund`, `total_area`, `square_1fl`, `square_2fl`, `square_terrace_1fl`, `square_terrace_2fl`, `kitchen_living_combined`, `square_kitchen_living`, `square_kitchen`, `square_living`, `master_bedroom`, `sq_master_bedroom`, `dirt_room`, `tech_room`, `sauna_room`, `sq_sauna_room`, `ceiling_height`, `roof_type`, `wall_material`, `foundation_type`, `created_at`, `updated_at`) VALUES
(3, 7, 'Прямоугольный', '10х12', '120.00', '0.00', '0.00', '0.00', '0.00', '0.00', 'Y', '0.00', '0.00', '0.00', 'Y', '19.00', '0.00', '0.00', 'N', '0.00', NULL, NULL, NULL, NULL, '2025-04-29 14:06:17', '2025-04-29 14:06:17'),
(4, 8, 'Прямоугольный', '10х12', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', 'N', '0.00', '0.00', '0.00', 'N', '0.00', '0.00', '0.00', 'N', '0.00', NULL, NULL, NULL, NULL, '2025-04-30 05:22:33', '2025-04-30 05:22:33'),
(5, 9, 'Фигурный', '10x13', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', 'Y', '46.00', '0.00', '0.00', 'Y', '19.00', '8.00', '7.00', 'N', '0.00', NULL, NULL, NULL, NULL, '2025-05-01 09:38:39', '2025-05-01 09:38:39'),
(8, 12, 'Прямоугольный', '', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', 'N', '0.00', '0.00', '0.00', 'N', '0.00', '0.00', '0.00', 'N', '0.00', NULL, NULL, NULL, NULL, '2025-05-03 13:34:17', '2025-05-03 13:34:17');

-- --------------------------------------------------------

--
-- Структура таблицы `project_sections`
--
-- Создание: Апр 29 2025 г., 14:03
-- Последнее обновление: Май 03 2025 г., 14:41
--

DROP TABLE IF EXISTS `project_sections`;
CREATE TABLE `project_sections` (
  `ID` int NOT NULL,
  `project_id` int NOT NULL,
  `section_code` enum('АР','КР','ЭОМ','ОВ','ВК','СС','ПОС') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `project_sections`
--

INSERT INTO `project_sections` (`ID`, `project_id`, `section_code`) VALUES
(1, 7, 'АР'),
(2, 8, 'АР'),
(3, 8, 'КР'),
(4, 9, 'АР'),
(5, 9, 'КР'),
(26, 12, 'АР'),
(27, 12, 'КР');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--
-- Создание: Май 02 2025 г., 16:04
-- Последнее обновление: Май 03 2025 г., 09:59
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','manager','user') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `role`, `created_at`) VALUES
(1, 'admin', '$2y$10$DDNBVd7sk.xaTruN8fYA9epE2NVJa2TyGysgUx4eUGf5F36TkIvPu', 'admin', '2025-05-02 16:05:13'),
(2, 'manager', '21596fb32a4cf219d6bbc55a27d38e1342edb5e637632a6aa8476a378c241a2f', 'manager', '2025-05-02 16:05:13'),
(3, 'user1', '05d49692b755f99c4504b510418efeeeebfd466892540f27acf9a31a326d6504', 'user', '2025-05-02 16:05:13'),
(4, 'MSM', '$2y$10$z0eI4MjGh1Be7AwH.nxfleXjcHJG7DEvOKh37WJ5IiRCLGHAOYZXa', 'admin', '2025-05-03 09:58:57'),
(5, 'Contributor', '$2y$10$wdmQK9YhlDwh1BJk0gRYo.auDT8Rfy3Ajc2qAzSpRH4gb19Q4r86a', 'admin', '2025-05-03 09:59:42');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `balconies`
--
ALTER TABLE `balconies`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `project_id` (`project_id`);

--
-- Индексы таблицы `bathrooms`
--
ALTER TABLE `bathrooms`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `project_id` (`project_id`);

--
-- Индексы таблицы `bedrooms`
--
ALTER TABLE `bedrooms`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `project_id` (`project_id`);

--
-- Индексы таблицы `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `idx_floors` (`floors`),
  ADD KEY `idx_has_project` (`has_project`);

--
-- Индексы таблицы `project_files`
--
ALTER TABLE `project_files`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `project_id` (`project_id`);

--
-- Индексы таблицы `project_images`
--
ALTER TABLE `project_images`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `project_id` (`project_id`);

--
-- Индексы таблицы `project_params`
--
ALTER TABLE `project_params`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `unique_project` (`project_id`);

--
-- Индексы таблицы `project_sections`
--
ALTER TABLE `project_sections`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `project_id` (`project_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `balconies`
--
ALTER TABLE `balconies`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `bathrooms`
--
ALTER TABLE `bathrooms`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `bedrooms`
--
ALTER TABLE `bedrooms`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT для таблицы `projects`
--
ALTER TABLE `projects`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `project_files`
--
ALTER TABLE `project_files`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `project_images`
--
ALTER TABLE `project_images`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT для таблицы `project_params`
--
ALTER TABLE `project_params`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `project_sections`
--
ALTER TABLE `project_sections`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `balconies`
--
ALTER TABLE `balconies`
  ADD CONSTRAINT `balconies_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`ID`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `bathrooms`
--
ALTER TABLE `bathrooms`
  ADD CONSTRAINT `bathrooms_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`ID`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `bedrooms`
--
ALTER TABLE `bedrooms`
  ADD CONSTRAINT `bedrooms_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`ID`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `project_files`
--
ALTER TABLE `project_files`
  ADD CONSTRAINT `project_files_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`ID`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `project_images`
--
ALTER TABLE `project_images`
  ADD CONSTRAINT `project_images_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`ID`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `project_params`
--
ALTER TABLE `project_params`
  ADD CONSTRAINT `project_params_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`ID`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `project_sections`
--
ALTER TABLE `project_sections`
  ADD CONSTRAINT `project_sections_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`ID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
