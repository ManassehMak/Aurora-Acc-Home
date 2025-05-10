<?php
require_once 'auth.php';
restrictAccess(['admin', 'manager']);
?><!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Список проектов - Аврора ДСК</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .project-list { max-width: 800px; margin: 0 auto; }
        .project-item { 
            padding: 15px; border: 1px solid #ddd; margin-bottom: 10px; 
            border-radius: 5px; display: flex; justify-content: space-between;
            align-items: center;
        }
        .actions a { margin-left: 10px; text-decoration: none; }
        .add-new { display: block; margin: 20px 0; text-align: center; }
    </style>
</head>
<body>
    <div class="project-list">
        <h1>Список проектов</h1>
        <a href="contracat.html" class="add-new">+ Добавить новый проект</a>
        <?php
        $projects = $pdo->query("SELECT ID, name, created_at FROM projects ORDER BY created_at DESC")->fetchAll();
        if (empty($projects)) {
            echo "<p>Нет проектов в базе данных</p>";
        } else {
            foreach ($projects as $project) {
                echo "<div class='project-item'>";
                echo "<div><strong>" . htmlspecialchars($project['name']) . "</strong><br>";
                echo "<small>Создан: " . date('d.m.Y H:i', strtotime($project['created_at'])) . "</small></div>";
                echo "<div class='actions'>";
                echo "<a href='contracat.html?id={$project['ID']}'>Редактировать</a>";
                echo "<a href='project_api.php?action=delete&id={$project['ID']}' onclick='return confirm(\"Удалить проект?\");'>Удалить</a>";
                echo "</div></div>";
            }
        }
        ?>
    </div>
</body>
</html>