<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$action = $_GET['action'] ?? '';
$db = new PDO('sqlite:bookkeeping.sqlite');
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

if ($action === 'list') {
  $stmt = $db->query('SELECT * FROM transactions ORDER BY id DESC LIMIT 100');
  $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
  echo json_encode(['transactions' => $rows]);
  exit;
}

if ($action === 'add') {
  $body = json_decode(file_get_contents('php://input'), true);
  $amount = isset($body['amount']) ? (float)$body['amount'] : 0.0;
  $note = $body['note'] ?? '';
  $stmt = $db->prepare('INSERT INTO transactions (amount, note) VALUES (:amount, :note)');
  $stmt->execute([':amount' => $amount, ':note' => $note]);
  echo json_encode(['ok' => true]);
  exit;
}

if ($action === 'delete') {
  $id = intval($_GET['id'] ?? 0);
  $stmt = $db->prepare('DELETE FROM transactions WHERE id = :id');
  $stmt->execute([':id' => $id]);
  echo json_encode(['ok' => true]);
  exit;
}

http_response_code(400);
echo json_encode(['error' => 'unknown action']);
