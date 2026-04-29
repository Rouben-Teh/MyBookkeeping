<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

require_once 'llm_tools.php';

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$db = require 'db.php';

$action = $_GET['action'] ?? '';

// 获取token和对应的user_id
function getAuth($db) {
    $token = $_GET['token'] ?? $_POST['token'] ?? (isset($_SERVER['HTTP_AUTHORIZATION']) ? str_replace('Bearer ', '', $_SERVER['HTTP_AUTHORIZATION']) : null);
    if (!$token) {
        return null;
    }

    $stmt = $db->prepare("
        SELECT user_id, token, device_type, expired_at, is_revoked
        FROM tokens
        WHERE token = :token
    ");
    $stmt->execute([':token' => $token]);

    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row) return null;

    // 可选：检查是否过期 / 已登出
    // if ($row['is_revoked']) return null;
    // if ($row['expired_at'] && strtotime($row['expired_at']) < time()) return null;

    return $row;
}

// 注册接口
if ($action === 'register') {
    $body = json_decode(file_get_contents('php://input'), true);
    $email = $body['email'] ?? '';
    $password = $body['password'] ?? '';
    
    if (!$email || !$password) {
        http_response_code(400);
        echo json_encode(['error' => 'missing email or password']);
        exit;
    }
    
    // 检查邮箱是否已存在
    $checkStmt = $db->prepare('SELECT id FROM accounts WHERE email = :email');
    $checkStmt->execute([':email' => $email]);
    if ($checkStmt->fetch()) {
        http_response_code(400);
        echo json_encode(['error' => 'email already exists']);
        exit;
    }
    
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $db->prepare('INSERT INTO accounts (email, password) VALUES (:email, :password)');
    $stmt->execute([':email' => $email, ':password' => $hashedPassword]);
    
    echo json_encode(['ok' => true, 'id' => $db->lastInsertId()]);
    exit;
}

// 登录接口
if ($action === 'login') {
    $body = json_decode(file_get_contents('php://input'), true);
    $email = $body['email'] ?? '';
    $password = $body['password'] ?? '';
    
    if (!$email || !$password) {
        http_response_code(400);
        echo json_encode(['error' => 'missing email or password']);
        exit;
    }
    
    $stmt = $db->prepare('SELECT id, password FROM accounts WHERE email = :email');
    $stmt->execute([':email' => $email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$user || !password_verify($password, $user['password'])) {
        http_response_code(401);
        echo json_encode(['error' => 'invalid email or password']);
        exit;
    }
    
    $token = bin2hex(random_bytes(32));
    $deviceType = $body['device_type'] ?? 'UNKNOWN';

    $stmt = $db->prepare("
    INSERT INTO tokens (user_id, token, device_type, expired_at)
    VALUES (:user_id, :token, :device_type, datetime('now','+7 day'))
    ");

    $stmt->execute([
        ':user_id' => $user['id'],
        ':token' => $token,
        ':device_type' => $deviceType // 'WEB' or 'APP'
    ]);
    
    echo json_encode(['id' => $user['id'], 'token' => $token]);
    exit;
}

// 登出接口
if ($action === 'logout') {
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }

    $body = json_decode(file_get_contents('php://input'), true);
    
    $stmt = $db->prepare('UPDATE tokens SET is_revoked = 1 WHERE token = :token');
    $stmt->execute([':token' => $auth['token']]);
    
    echo json_encode(['ok' => true]);
    exit;
}

// 获取当前用户的所有交易
if ($action === 'list') {
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }
    
    $stmt = $db->prepare('SELECT * FROM transactions WHERE user_id = :user_id ORDER BY timestamp DESC');
    $stmt->execute([':user_id' => $auth['user_id']]);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode(['transactions' => $rows]);
    exit;
}

if($action == "month-list"){
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }

    $body = json_decode(file_get_contents('php://input'), true);
    $start = $body['start'] ?? '';
    $end = $body['end'] ?? '';

    $stmt = $db->prepare('SELECT * FROM transactions WHERE user_id = :user_id AND timestamp >= :start
                            AND timestamp < :end ORDER BY timestamp DESC');
    $stmt->execute([':user_id' => $auth['user_id'], ':start' => $start, ':end' => $end]);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode(['transactions' => $rows]);
    exit;
}

// 添加交易
if ($action === 'add') {
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }
    
    $body = json_decode(file_get_contents('php://input'), true);
    $id = $body['id'] ?? '';
    $category = $body['category'] ?? '';
    $amount = isset($body['amount']) ? (float)$body['amount'] : 0.0;
    $note = $body['note'] ?? '';
    $timestamp = $body['timestamp'] ??  round(microtime(true) * 1000);
    
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'missing id']);
        exit;
    }
    
    $stmt = $db->prepare('INSERT INTO transactions (id, user_id, category, amount, note, timestamp, synced) VALUES (:id, :user_id, :category, :amount, :note, :timestamp, 1)');
    $stmt->execute([':id' => $id, ':user_id' => $auth['user_id'], ':category' => $category, ':amount' => $amount, ':note' => $note, ':timestamp' => $timestamp]);
    
    echo json_encode(['ok' => true]);
    exit;
}

// 删除交易
if ($action === 'delete') {
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }

    $body = json_decode(file_get_contents('php://input'), true);
    $id = $body['id'] ?? '';
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'missing id']);
        exit;
    }
    
    // 验证交易所有者
    $checkStmt = $db->prepare('SELECT user_id FROM transactions WHERE id = :id');
    $checkStmt->execute([':id' => $id]);
    $transaction = $checkStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$transaction || $transaction['user_id'] != $auth['user_id']) {
        http_response_code(403);
        echo json_encode(['error' => 'forbidden']);
        exit;
    }
    
    $stmt = $db->prepare('DELETE FROM transactions WHERE id = :id');
    $stmt->execute([':id' => $id]);
    
    echo json_encode(['ok' => true]);
    exit;
}

// 软删除交易
if ($action === 'soft-delete') {
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }

    $body = json_decode(file_get_contents('php://input'), true);
    $id = $body['id'] ?? '';
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'missing id']);
        exit;
    }
    
    // 验证交易所有者
    $checkStmt = $db->prepare('SELECT user_id FROM transactions WHERE id = :id');
    $checkStmt->execute([':id' => $id]);
    $transaction = $checkStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$transaction || $transaction['user_id'] != $auth['user_id']) {
        http_response_code(403);
        echo json_encode(['error' => 'forbidden']);
        exit;
    }

    $stmt = $db->prepare('UPDATE transactions  SET deleted = 1 WHERE id = :id');
    $stmt->execute([':id' => $id]);
    
    echo json_encode(['ok' => true]);
    exit;
}

// 同步交易
if ($action === 'sync') {
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }
    
    $body = json_decode(file_get_contents('php://input'), true);
    $id = $body['id'] ?? '';
    $category = $body['category'] ?? '';
    $amount = isset($body['amount']) ? (float)$body['amount'] : 0.0;
    $note = $body['note'] ?? '';
    $timestamp = $body['timestamp'] ??  round(microtime(true) * 1000);
    $deleted = $body['deleted'] ?? false;
    
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'missing id']);
        exit;
    }
    
    $stmt = $db->prepare('INSERT INTO transactions (id, user_id, category, amount, note, timestamp, synced, deleted) 
    VALUES (:id, :user_id, :category, :amount, :note, :timestamp, 1, :deleted)
    ON CONFLICT(id) DO UPDATE SET user_id = excluded.user_id,
        category = excluded.category,
        amount = excluded.amount,
        note = excluded.note,
        timestamp = excluded.timestamp,
        synced = 1,
        deleted = excluded.deleted');
    $stmt->execute([':id' => $id, ':user_id' => $auth['user_id'], ':category' => $category, ':amount' => $amount, ':note' => $note, ':timestamp' => $timestamp, ':deleted' => $deleted]);
    
    echo json_encode(['ok' => true]);
    exit;
}

if($action === 'chat') {
    $auth = getAuth($db);
    if (!$auth) {
        http_response_code(401);
        echo json_encode(['error' => 'unauthorized']);
        exit;
    }

    $body = json_decode(file_get_contents('php://input'), true);
    $message = $body['message'] ?? '';

    if (!$message) {
        http_response_code(400);
        echo json_encode(['error' => 'missing api_key or message']);
        exit;
    }

    $response = callLLM(
        $auth['user_id'],
        $db,
        [
        'api_key' => 'f8967ad2-9f52-4f50-94e2-db2ec249efe8',
        'message' => $message,
        'configs' => [
            'prompt' => $prompt,
            'toxic_threshold' => 1.0,
            'rag_threshold' => 1.0,
            'rag_samples' => 1,
            'rag' => 0,
            'enable_filter' => false,
        ]
    ]);

    echo json_encode(['ok' => true, 'response' => $response['msg']['response']]);
    exit;
}

http_response_code(400);
echo json_encode(['error' => 'unknown action']);
