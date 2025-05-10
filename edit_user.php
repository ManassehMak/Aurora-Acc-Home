
<?php
require 'auth.php';
require 'db_connection.php';
if ($_SESSION['user_role'] != 'admin') die('Access denied');

$id = (int)$_GET['id'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $role = $_POST['role'];
    $password = $_POST['password'];

    if ($password) {
        $pass_hash = hash('sha256', $password);
        $stmt = $conn->prepare("UPDATE users SET role=?, password_hash=? WHERE id=?");
        $stmt->bind_param("ssi", $role, $pass_hash, $id);
    } else {
        $stmt = $conn->prepare("UPDATE users SET role=? WHERE id=?");
        $stmt->bind_param("si", $role, $id);
    }
    $stmt->execute();
    header('Location: users_console.php');
    exit;
}

$stmt = $conn->prepare("SELECT username, role FROM users WHERE id=?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->bind_result($username, $role);
$stmt->fetch();
$stmt->close();
?>
<form method="POST">
  Логин: <?=htmlspecialchars($username)?><br>
  Новая роль:
  <select name="role">
    <option value="admin" <?=$role=='admin'?'selected':''?>>admin</option>
    <option value="manager" <?=$role=='manager'?'selected':''?>>manager</option>
    <option value="user" <?=$role=='user'?'selected':''?>>user</option>
  </select><br>
  Новый пароль (если нужно сменить): <input name="password" type="password"><br>
  <input type="submit" value="Обновить">
</form>
