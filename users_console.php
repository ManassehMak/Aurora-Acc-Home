
<?php
require 'auth.php';
require 'db_connection.php';
if ($_SESSION['user_role'] != 'admin') die('Access denied');

$result = $conn->query("SELECT id, username, role FROM users");
echo "<a href='add_user.php'>Добавить пользователя</a><br><br>";
echo "<table border='1'><tr><th>Логин</th><th>Роль</th><th>Действия</th></tr>";
while ($row = $result->fetch_assoc()) {
    echo "<tr><td>{$row['username']}</td><td>{$row['role']}</td><td>
          <a href='edit_user.php?id={$row['id']}'>Изменить</a> |
          <a href='delete_user.php?id={$row['id']}'>Удалить</a></td></tr>";
}
echo "</table>";
?>