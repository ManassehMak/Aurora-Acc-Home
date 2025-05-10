<?php
$host = 'pg4.sweb.ru';
$db   = 'dkaurorads';
$user = 'dkaurorads';
$pass = '5djStu6Bh'; // Replace with your PostgreSQL password
$port = '5432';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset;port=3306";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
    echo "Подключение к базе данных успешно!";
} catch (PDOException $e) {
    die("Ошибка подключения: " . $e->getMessage());
}
?>