<?php
// Start output buffering
ob_start();

// Set JSON content type
header('Content-Type: application/json; charset=utf-8');

// Disable error display
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(E_ALL);

// Include authentication
require_once 'auth.php';

// Debug logging function
function logDebug($message) {
    file_put_contents('debug_post.log', date('Y-m-d H:i:s') . " - $message\n", FILE_APPEND);
}
logDebug("project_api.php started");

// Response function
function respond($success, $message = '', $data = []) {
    ob_end_clean();
    echo json_encode(['success' => $success, 'message' => $message, 'data' => $data], JSON_UNESCAPED_UNICODE);
    exit;
}

// Get action
$action = $_GET['action'] ?? '';
logDebug("Action requested: $action");

if ($action === 'save') {
    restrictAccess(['admin', 'manager', 'external_user']);

    // Check if form data is received
    if (empty($_POST) && empty($_FILES)) {
        logDebug("Empty POST and FILES received");
        respond(false, 'Empty request, no form data received');
    }

    logDebug("POST: " . print_r($_POST, true));
    logDebug("FILES: " . print_r($_FILES, true));

    // Extract form data
    $project_id = isset($_POST['project_id']) && !empty($_POST['project_id']) ? intval($_POST['project_id']) : null;
    $name = trim($_POST['name'] ?? '');
    $description = trim($_POST['projectDescription'] ?? '');
    $floors = intval($_POST['floors'] ?? 1);
    $has_project = $_POST['has_project'] ?? 'N';
    $model_3d_view = trim($_POST['model3DView'] ?? '');
    $embed_code = trim($_POST['embedCode'] ?? '');
    $notes = trim($_POST['projectNotes'] ?? '');
    $custom_fields = json_decode($_POST['customFields'] ?? '{}', true) ?: [];
    $total_area = floatval($_POST['totalArea'] ?? 0);
    $sizes = trim($_POST['sizes'] ?? '');
    $square_fund = floatval($_POST['squareFund'] ?? 0);
    $foundation_shape = trim($_POST['foundation_shape'] ?? 'Прямоугольный');
    $square_1fl = floatval($_POST['square1fl'] ?? 0);
    $square_terrace_1fl = floatval($_POST['squareTerrace1fl'] ?? 0);
    $square_2fl = floatval($_POST['square2fl'] ?? 0);
    $square_terrace_2fl = floatval($_POST['squareTerrace2fl'] ?? 0);
    $kitchen_living_combined = $_POST['kitchen_living_combined'] ?? 'N';
    $square_kitchen_living = floatval($_POST['squareKitchenLiving'] ?? 0);
    $square_kitchen = floatval($_POST['squareKitchen'] ?? 0);
    $square_living = floatval($_POST['squareLiving'] ?? 0);
    $master_bedroom = $_POST['master_bedroom'] ?? 'N';
    $sq_master_bedroom = floatval($_POST['sqMasterBedroom'] ?? 0);
    $dirt_room = floatval($_POST['dirtRoom'] ?? 0);
    $tech_room = floatval($_POST['techRoom'] ?? 0);
    $sauna_room = $_POST['sauna_room'] ?? 'N';
    $sq_sauna_room = floatval($_POST['sqSaunaRoom'] ?? 0);
    $custom_params = json_decode($_POST['customParams'] ?? '{}', true) ?: [];
    $bedrooms = array_filter($_POST['bedrooms'] ?? [], function($value) { return $value !== ''; });
    $bathrooms = array_filter($_POST['bathrooms'] ?? [], function($value) { return $value !== ''; });
    $balconies = array_filter($_POST['balconies'] ?? [], function($value) { return $value !== ''; });
    $project_sections = array_unique($_POST['project_sections'] ?? []);
    $tags = array_filter($_POST['tags'] ?? [], function($value) { return trim($value) !== ''; });

    // Validate required fields
    if (empty($name)) {
        respond(false, 'Project name is required');
    }

    try {
        $pdo->beginTransaction();

        // Save or update project
        if ($project_id) {
            $stmt = $pdo->prepare("UPDATE projects SET name = ?, description = ?, floors = ?, has_project = ?, model_3d_view = ?, embed_code = ?, notes = ?, custom_fields = ? WHERE id = ?");
            $stmt->execute([$name, $description, $floors, $has_project, $model_3d_view, $embed_code, $notes, json_encode($custom_fields), $project_id]);
        } else {
            $stmt = $pdo->prepare("INSERT INTO projects (name, description, floors, has_project, model_3d_view, embed_code, notes, custom_fields) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->execute([$name, $description, $floors, $has_project, $model_3d_view, $embed_code, $notes, json_encode($custom_fields)]);
            $project_id = $pdo->lastInsertId('projects_id_seq');
        }

        // Log audit
        $stmt = $pdo->prepare("INSERT INTO audit_logs (user_id, action, entity_type, entity_id, details) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$_SESSION['user_id'], $project_id ? 'update_project' : 'create_project', 'project', $project_id, json_encode(['name' => $name])]);

        // Clear related tables
        $tables = ['project_params', 'project_sections', 'bedrooms', 'bathrooms', 'balconies', 'project_tags'];
        foreach ($tables as $table) {
            $stmt = $pdo->prepare("DELETE FROM $table WHERE project_id = ?");
            $stmt->execute([$project_id]);
        }

        // Save project parameters
        $stmt = $pdo->prepare("INSERT INTO project_params (project_id, total_area, sizes, square_fund, foundation_shape, square_1fl, square_terrace_1fl, square_2fl, square_terrace_2fl, kitchen_living_combined, square_kitchen_living, square_kitchen, square_living, master_bedroom, sq_master_bedroom, dirt_room, tech_room, sauna_room, sq_sauna_room, custom_params) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$project_id, $total_area, $sizes, $square_fund, $foundation_shape, $square_1fl, $square_terrace_1fl, $square_2fl, $square_terrace_2fl, $kitchen_living_combined, $square_kitchen_living, $square_kitchen, $square_living, $master_bedroom, $sq_master_bedroom, $dirt_room, $tech_room, $sauna_room, $sq_sauna_room, json_encode($custom_params)]);

        // Save project sections
        if (!empty($project_sections)) {
            $stmt = $pdo->prepare("INSERT INTO project_sections (project_id, section_code) VALUES (?, ?)");
            foreach ($project_sections as $section) {
                $stmt->execute([$project_id, $section]);
            }
        }

        // Save tags
        if (!empty($tags)) {
            $stmt = $pdo->prepare("INSERT INTO project_tags (project_id, tag_name) VALUES (?, ?)");
            foreach ($tags as $tag) {
                $stmt->execute([$project_id, $tag]);
            }
        }

        // Save bedrooms
        if (!empty($bedrooms)) {
            $stmt = $pdo->prepare("INSERT INTO bedrooms (project_id, bedroom_number, bedroom_size) VALUES (?, ?, ?)");
            foreach ($bedrooms as $index => $size) {
                $size = floatval($size);
                if ($size > 0) {
                    $stmt->execute([$project_id, $index + 1, $size]);
                }
            }
        }

        // Save bathrooms
        if (!empty($bathrooms)) {
            $stmt = $pdo->prepare("INSERT INTO bathrooms (project_id, bathroom_number, bathroom_size) VALUES (?, ?, ?)");
            foreach ($bathrooms as $index => $size) {
                $size = floatval($size);
                if ($size > 0) {
                    $stmt->execute([$project_id, $index + 1, $size]);
                }
            }
        }

        // Save balconies
        if (!empty($balconies)) {
            $stmt = $pdo->prepare("INSERT INTO balconies (project_id, balcony_number, balcony_size) VALUES (?, ?, ?)");
            foreach ($balconies as $index => $size) {
                $size = floatval($size);
                if ($size > 0) {
                    $stmt->execute([$project_id, $index + 1, $size]);
                }
            }
        }

        // Handle file uploads
        $upload_dir = 'Uploads/' . preg_replace('/[^a-zA-Z0-9]/', '_', $name) . '/';
        if (!file_exists($upload_dir)) {
            if (!mkdir($upload_dir, 0775, true)) {
                throw new Exception("Failed to create upload directory: $upload_dir");
            }
        }

        // Main image
        if (isset($_FILES['mainImageInput']) && $_FILES['mainImageInput']['error'] === UPLOAD_ERR_OK) {
            $file = $_FILES['mainImageInput'];
            if (in_array($file['type'], ['image/jpeg', 'image/png']) && $file['size'] <= 120 * 1024 * 1024) {
                $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
                $filename = uniqid() . '_main.' . $ext;
                $destination = $upload_dir . $filename;
                if (!move_uploaded_file($file['tmp_name'], $destination)) {
                    throw new Exception("Failed to move main image to $destination");
                }
                $stmt = $pdo->prepare("UPDATE projects SET main_pic = ? WHERE id = ?");
                $stmt->execute([$destination, $project_id]);
            } else {
                logDebug("Invalid main image: type={$file['type']}, size={$file['size']}");
            }
        }

        // Additional images
        if (isset($_FILES['additionalImagesInput']) && !empty($_FILES['additionalImagesInput']['name'][0])) {
            foreach ($_FILES['additionalImagesInput']['name'] as $key => $name) {
                if ($_FILES['additionalImagesInput']['error'][$key] === UPLOAD_ERR_OK) {
                    $file = [
                        'name' => $name,
                        'type' => $_FILES['additionalImagesInput']['type'][$key],
                        'tmp_name' => $_FILES['additionalImagesInput']['tmp_name'][$key],
                        'size' => $_FILES['additionalImagesInput']['size'][$key]
                    ];
                    if (in_array($file['type'], ['image/jpeg', 'image/png']) && $file['size'] <= 120 * 1024 * 1024) {
                        $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
                        $filename = uniqid() . '_image.' . $ext;
                        $destination = $upload_dir . $filename;
                        if (!move_uploaded_file($file['tmp_name'], $destination)) {
                            throw new Exception("Failed to move additional image to $destination");
                        }
                        $stmt = $pdo->prepare("INSERT INTO project_images (project_id, image_path) VALUES (?, ?)");
                        $stmt->execute([$project_id, $destination]);
                    } else {
                        logDebug("Invalid additional image: type={$file['type']}, size={$file['size']}");
                    }
                }
            }
        }

        // Project files
        if (isset($_FILES['projectFilesInput']) && !empty($_FILES['projectFilesInput']['name'][0])) {
            foreach ($_FILES['projectFilesInput']['name'] as $key => $name) {
                if ($_FILES['projectFilesInput']['error'][$key] === UPLOAD_ERR_OK) {
                    $file = [
                        'name' => $name,
                        'type' => $_FILES['projectFilesInput']['type'][$key],
                        'tmp_name' => $_FILES['projectFilesInput']['tmp_name'][$key],
                        'size' => $_FILES['projectFilesInput']['size'][$key]
                    ];
                    if (in_array($file['type'], ['application/pdf', 'image/jpeg', 'image/png', 'application/zip', 'application/x-rar-compressed']) && $file['size'] <= 120 * 1024 * 1024) {
                        $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
                        $filename = uniqid() . '_file.' . $ext;
                        $destination = $upload_dir . $filename;
                        if (!move_uploaded_file($file['tmp_name'], $destination)) {
                            throw new Exception("Failed to move project file to $destination");
                        }
                        $stmt = $pdo->prepare("INSERT INTO project_files (project_id, file_path, file_type, file_name, file_size) VALUES (?, ?, ?, ?, ?)");
                        $stmt->execute([$project_id, $destination, $ext === 'pdf' ? 'pdf' : 'other', $name, $file['size']]);
                    } else {
                        logDebug("Invalid project file: type={$file['type']}, size={$file['size']}");
                    }
                }
            }
        }

        // Handle .skp file
        if (isset($_FILES['modelSKPFile']) && $_FILES['modelSKPFile']['error'] === UPLOAD_ERR_OK) {
            $file = $_FILES['modelSKPFile'];
            if ($file['type'] === 'application/octet-stream' && pathinfo($file['name'], PATHINFO_EXTENSION) === 'skp' && $file['size'] <= 120 * 1024 * 1024) {
                $filename = uniqid() . '_model.skp';
                $destination = $upload_dir . $filename;
                if (!move_uploaded_file($file['tmp_name'], $destination)) {
                    throw new Exception("Failed to move .skp file to $destination");
                }
                $stmt = $pdo->prepare("UPDATE projects SET model_3d_skp = ? WHERE id = ?");
                $stmt->execute([$destination, $project_id]);
            } else {
                logDebug("Invalid .skp file: type={$file['type']}, size={$file['size']}");
            }
        }

        // Handle .zip/.rar file
        if (isset($_FILES['rdZipFile']) && $_FILES['rdZipFile']['error'] === UPLOAD_ERR_OK) {
            $file = $_FILES['rdZipFile'];
            if (in_array($file['type'], ['application/zip', 'application/x-rar-compressed']) && $file['size'] <= 120 * 1024 * 1024) {
                $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
                $filename = uniqid() . '_rd.' . $ext;
                $destination = $upload_dir . $filename;
                if (!move_uploaded_file($file['tmp_name'], $destination)) {
                    throw new Exception("Failed to move .zip/.rar file to $destination");
                }
                $stmt = $pdo->prepare("UPDATE projects SET rd_zip_path = ? WHERE id = ?");
                $stmt->execute([$destination, $project_id]);
            } else {
                logDebug("Invalid .zip/.rar file: type={$file['type']}, size={$file['size']}");
            }
        }

        $pdo->commit();
        respond(true, 'Project saved successfully', ['project_id' => $project_id]);
    } catch (Exception $e) {
        $pdo->rollBack();
        logDebug("Error saving project: " . $e->getMessage());
        respond(false, 'Error saving project: ' . $e->getMessage());
    }
} elseif ($action === 'get') {
    restrictAccess(['admin', 'manager', 'external_user']);
    $id = intval($_GET['id'] ?? 0);
    if ($id <= 0) {
        respond(false, 'Invalid project ID');
    }

    try {
        $project = $pdo->query("SELECT * FROM projects WHERE id = $id")->fetch();
        if (!$project) {
            respond(false, 'Project not found');
        }

        $params = $pdo->query("SELECT * FROM project_params WHERE project_id = $id")->fetch() ?: [];
        $sections = $pdo->query("SELECT section_code FROM project_sections WHERE project_id = $id")->fetchAll(PDO::FETCH_COLUMN);
        $images = $pdo->query("SELECT image_path FROM project_images WHERE project_id = $id")->fetchAll(PDO::FETCH_ASSOC);
        $files = $pdo->query("SELECT file_path, file_name, file_type, file_size FROM project_files WHERE project_id = $id")->fetchAll(PDO::FETCH_ASSOC);
        $bedrooms = $pdo->query("SELECT bedroom_size FROM bedrooms WHERE project_id = $id ORDER BY bedroom_number")->fetchAll(PDO::FETCH_ASSOC);
        $bathrooms = $pdo->query("SELECT bathroom_size FROM bathrooms WHERE project_id = $id ORDER BY bathroom_number")->fetchAll(PDO::FETCH_ASSOC);
        $balconies = $pdo->query("SELECT balcony_size FROM balconies WHERE project_id = $id ORDER BY balcony_number")->fetchAll(PDO::FETCH_ASSOC);
        $tags = $pdo->query("SELECT tag_name FROM project_tags WHERE project_id = $id")->fetchAll(PDO::FETCH_COLUMN);

        respond(true, 'Project data retrieved successfully', [
            'project' => $project,
            'params' => $params,
            'sections' => $sections,
            'images' => $images,
            'files' => $files,
            'bedrooms' => $bedrooms,
            'bathrooms' => $bathrooms,
            'balconies' => $balconies,
            'tags' => $tags
        ]);
    } catch (Exception $e) {
        logDebug("Error fetching project data: " . $e->getMessage());
        respond(false, 'Error fetching project data: ' . $e->getMessage());
    }
} elseif ($action === 'list') {
    restrictAccess(['admin', 'manager', 'external_user']);
    $page = intval($_GET['page'] ?? 1);
    $per_page = 10;
    $offset = ($page - 1) * $per_page;
    $tags = $_GET['tags'] ?? '';

    $query = "SELECT p.* FROM projects p";
    $params = [];
    if ($_SESSION['is_external'] && $_SESSION['user_role'] === 'external_user') {
        $project_ids = $_SESSION['permissions']['projects'] ?? [];
        if (empty($project_ids)) {
            respond(true, 'No projects accessible', ['projects' => [], 'total' => 0]);
        }
        $query .= " WHERE p.id = ANY(?)";
        $params[] = '{' . implode(',', $project_ids) . '}';
    }
    if ($tags) {
        $query .= ($_SESSION['is_external'] ? " AND" : " WHERE") . " EXISTS (SELECT 1 FROM project_tags pt WHERE pt.project_id = p.id AND pt.tag_name = ANY(?))";
        $params[] = '{' . implode(',', array_map('trim', explode(',', $tags))) . '}';
    }
    $query .= " ORDER BY created_at DESC LIMIT ? OFFSET ?";
    $params[] = $per_page;
    $params[] = $offset;

    try {
        $stmt = $pdo->prepare($query);
        $stmt->execute($params);
        $projects = $stmt->fetchAll();

        $count_query = "SELECT COUNT(*) FROM projects p";
        if ($_SESSION['is_external'] && $_SESSION['user_role'] === 'external_user') {
            $count_query .= " WHERE p.id = ANY(?)";
            $stmt = $pdo->prepare($count_query);
            $stmt->execute(['{' . implode(',', $project_ids) . '}']);
        } else {
            $stmt = $pdo->query($count_query);
        }
        $total = $stmt->fetchColumn();

        respond(true, 'Projects retrieved successfully', ['projects' => $projects, 'total' => $total, 'page' => $page, 'per_page' => $per_page]);
    } catch (Exception $e) {
        logDebug("Error listing projects: " . $e->getMessage());
        respond(false, 'Error listing projects: ' . $e->getMessage());
    }
} elseif ($action === 'delete') {
    restrictAccess(['admin', 'manager']);
    $id = intval($_GET['id'] ?? 0);
    if ($id <= 0) {
        respond(false, 'Invalid project ID');
    }

    try {
        $pdo->beginTransaction();
        $stmt = $pdo->prepare("DELETE FROM projects WHERE id = ?");
        $stmt->execute([$id]);
        if ($stmt->rowCount() === 0) {
            respond(false, 'Project not found');
        }
        // Log audit
        $stmt = $pdo->prepare("INSERT INTO audit_logs (user_id, action, entity_type, entity_id, details) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$_SESSION['user_id'], 'delete_project', 'project', $id, json_encode(['id' => $id])]);
        $pdo->commit();
        respond(true, 'Project deleted successfully');
    } catch (Exception $e) {
        $pdo->rollBack();
        logDebug("Error deleting project: " . $e->getMessage());
        respond(false, 'Error deleting project: ' . $e->getMessage());
    }
} else {
    logDebug("Invalid action: $action");
    respond(false, 'Invalid action');
}
?>