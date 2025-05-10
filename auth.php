<?php
session_start();

$host = 'pg4.sweb.ru';
$db   = 'dkaurorads';
$user = 'dkaurorads';
$pass = '5djStu6Bh'; // Replace with your PostgreSQL password
$port = '5433';

$dsn = "pgsql:host=$host;port=$port;dbname=$db";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    die(json_encode(['error' => 'Database connection error: ' . $e->getMessage()]));
}

$action = $_GET['action'] ?? '';

if ($action === 'login') {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $username = trim($_POST['username'] ?? '');
        $password = $_POST['password'] ?? '';

        $stmt = $pdo->prepare("SELECT id, password_hash, role, is_external, permissions FROM users WHERE username = ?");
        $stmt->execute([$username]);
        $user = $stmt->fetch();

        if (!$user) {
            echo json_encode(['error' => 'User not found']);
            exit;
        }

        if (password_verify($password, $user['password_hash'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['user_role'] = $user['role'];
            $_SESSION['is_external'] = $user['is_external'];
            $_SESSION['permissions'] = json_decode($user['permissions'], true);
            header('Location: project_list.php');
            exit;
        } else {
            echo json_encode(['error' => 'Invalid password']);
            exit;
        }
    } else {
        ?>
        <!DOCTYPE html>
        <html lang="ru">
        <head>
            <meta charset="UTF-8">
            <title>Login - Aurora DSK</title>
            <style>
                body { font-family: Arial, sans-serif; max-width: 400px; margin: 50px auto; }
                form { display: flex; flex-direction: column; gap: 10px; }
                input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
                button { background: #3498db; color: white; padding: 10px; border: none; border-radius: 4px; cursor: pointer; }
                button:hover { background: #2980b9; }
                .error { color: red; }
                .forgot-password { text-align: center; margin-top: 10px; }
            </style>
        </head>
        <body>
            <h2>Login</h2>
            <form method="POST" action="auth.php?action=login">
                <input type="text" name="username" placeholder="Username" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit">Login</button>
                <?php if (isset($error)) echo "<p class='error'>$error</p>"; ?>
            </form>
            <p class="forgot-password"><a href="auth.php?action=forgot_password">Forgot Password?</a></p>
        </body>
        </html>
        <?php
        exit;
    }
} elseif ($action === 'logout') {
    session_destroy();
    header('Location: catalogAuroraDSK.html');
    exit;
} elseif ($action === 'forgot_password') {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $email = trim($_POST['email'] ?? '');
        $stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetch()) {
            // In a real system, generate a reset token and send an email
            echo json_encode(['success' => true, 'message' => 'Password reset link sent to your email']);
        } else {
            echo json_encode(['error' => 'Email not found']);
        }
        exit;
    } else {
        ?>
        <!DOCTYPE html>
        <html lang="ru">
        <head>
            <meta charset="UTF-8">
            <title>Password Recovery - Aurora DSK</title>
            <style>
                body { font-family: Arial, sans-serif; max-width: 400px; margin: 50px auto; }
                form { display: flex; flex-direction: column; gap: 10px; }
                input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
                button { background: #3498db; color: white; padding: 10px; border: none; border-radius: 4px; cursor: pointer; }
                button:hover { background: #2980b9; }
                .error { color: red; }
            </style>
        </head>
        <body>
            <h2>Password Recovery</h2>
            <form method="POST" action="auth.php?action=forgot_password">
                <input type="email" name="email" placeholder="Email" required>
                <button type="submit">Send Reset Link</button>
            </form>
        </body>
        </html>
        <?php
        exit;
    }
} elseif ($action === 'create_user' && ($_SESSION['user_role'] ?? '') === 'admin') {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $username = trim($_POST['username'] ?? '');
        $password = $_POST['password'] ?? '';
        $email = trim($_POST['email'] ?? '');
        $role = $_POST['role'] ?? 'user';
        $is_external = $_POST['is_external'] === '1';
        $permissions = json_decode($_POST['permissions'] ?? '{}', true);

        if (empty($username) || empty($password) || empty($email)) {
            echo json_encode(['error' => 'Username, password, and email are required']);
            exit;
        }
        if (!in_array($role, ['admin', 'manager', 'user', 'external_user'])) {
            echo json_encode(['error' => 'Invalid role']);
            exit;
        }

        $stmt = $pdo->prepare("SELECT COUNT(*) FROM users WHERE username = ? OR email = ?");
        $stmt->execute([$username, $email]);
        if ($stmt->fetchColumn() > 0) {
            echo json_encode(['error' => 'Username or email already exists']);
            exit;
        }

        $password_hash = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $pdo->prepare("INSERT INTO users (username, password_hash, email, role, is_external, permissions) VALUES (?, ?, ?, ?, ?, ?)");
        try {
            $stmt->execute([$username, $password_hash, $email, $role, $is_external, json_encode($permissions)]);
            echo json_encode(['success' => true, 'message' => 'User created']);
        } catch (PDOException $e) {
            echo json_encode(['error' => 'Error creating user: ' . $e->getMessage()]);
        }
        exit;
    }
} elseif ($action === 'generate_api_token' && ($_SESSION['user_role'] ?? '') === 'admin') {
    $user_id = $_POST['user_id'] ?? 0;
    $token = bin2hex(random_bytes(32));
    $stmt = $pdo->prepare("UPDATE users SET permissions = permissions || jsonb_build_object('api_token', ?) WHERE id = ?");
    $stmt->execute([$token, $user_id]);
    echo json_encode(['success' => true, 'token' => $token]);
    exit;
} else {
    if (!isset($_SESSION['user_id'])) {
        header('Location: auth.php?action=login');
        exit;
    }
}

function restrictAccess($allowed_roles) {
    if (!in_array($_SESSION['user_role'] ?? '', $allowed_roles)) {
        echo json_encode(['error' => 'Access denied']);
        exit;
    }
    if ($_SESSION['is_external'] && $_SESSION['user_role'] === 'external_user') {
        // Restrict external users to their permitted projects
        $project_id = $_GET['id'] ?? 0;
        if ($project_id && !in_array($project_id, $_SESSION['permissions']['projects'] ?? [])) {
            echo json_encode(['error' => 'Access to this project denied']);
            exit;
        }
    }
}
?>