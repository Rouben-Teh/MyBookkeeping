<?php
$categories = require_once 'categories.php';

set_time_limit(300);

$categoryText = implode(", ", $categories);

$prompt = <<<EOT
You are a financial assistant.

You MUST output ONLY valid JSON.

Output format:
{
  "type": "chat | tool",
  "content": "",
  "tool": {
    "name": "",
    "args": {}
  }
}

Available category:
$categoryText

Available tools:

add_expense:
args: timestamp, amount, category, note

add_income:
args: timestamp, amount, category, note

get_total_expense:
args: start, end

get_total_income:
args: start, end

get_transactions:
args: start, end
description: Use this when the user asks about a week, day, month, year, or any date range. The backend will provide transaction context for the requested range. If no time is specified, use this week.

Rules:
- Use tool ONLY when user requests action
- If the user asks for analysis, advice, summary, spending advice, income advice, or mentions a week/day/month/year, use the provided Ledger context to answer.
- If the user asks for spending advice or income advice, give practical suggestions based on the Ledger context.
- Otherwise, provide objective financial observations and suggestions based on the Ledger context.
- When choosing a date range, fill start and end as Unix milliseconds. If no date range is specified, use this week.
- Otherwise use type = "chat", and reply something in content to user
- If tool is used, content must be ""
- If chat, tool must be {}

Ledger context:
{{ledger_context}}

User input:
{{input}}
EOT;

function callLLM($user_id, $db, $cmsData) {
    $url =  "http://localhost:5000/api/chat";

    $message = $cmsData['message'] ?? '';
    $range = detectLedgerDateRange($message);
    $ledgerContext = buildLedgerContext($db, $user_id, $range);

    if (isset($cmsData['configs']['prompt'])) {
        $cmsData['configs']['prompt'] = str_replace('{{ledger_context}}', $ledgerContext, $cmsData['configs']['prompt']);
    }

    $ch = curl_init($url);

    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);

    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($cmsData));

    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json'
    ]);

    curl_setopt($ch, CURLOPT_TIMEOUT, 300);

    $response = curl_exec($ch);

    if (curl_errno($ch)) {
        return [
            'error' => curl_error($ch)
        ];
    }

   $parsedRes = json_decode($response, true);

    if (!isset($parsedRes['msg']['response'])) {
        return $parsedRes;
    }

    $parsedAns = json_decode($parsedRes['msg']['response'], true);

    if (!$parsedAns) {
        return $parsedRes; // JSON parse fail safety
    }

    if (($parsedAns['type'] ?? '') === 'tool') {
        if (isset($parsedAns['content'])) {
            if($parsedAns['content'] == "") $parsedAns['content'] = "Action performed.";
        }
        if (isset($parsedAns['tool']['args']['timestamp'])) {
            $parsedAns['tool']['args']['timestamp'] =
                convertDateToTimestamp($parsedAns['tool']['args']['timestamp']);
        }

        if(isset($parsedAns['tool']['name'])){
            switch ($parsedAns['tool']['name']) {
                case 'add_expense':
                    $id = $user_id .  round(microtime(true) * 1000);
                    $stmt = $db->prepare('INSERT INTO transactions (id, user_id, type, category, amount, note, timestamp, synced) VALUES (:id, :user_id, :type, :category, :amount, :note, :timestamp, 1)');
                    $stmt->execute([
                        ':id' => $id, 
                        ':user_id' => $user_id, 
                        ':type' => 'expense',
                        ':category' => $parsedAns['tool']['args']['category'], 
                        ':amount' => $parsedAns['tool']['args']['amount'], 
                        ':note' => $parsedAns['tool']['args']['note'], 
                        ':timestamp' => $parsedAns['tool']['args']['timestamp']
                    ]);
                    break;

                case 'add_income':
                    $id = $user_id .  round(microtime(true) * 1000);
                    $stmt = $db->prepare('INSERT INTO transactions (id, user_id, type, category, amount, note, timestamp, synced) VALUES (:id, :user_id, :type, :category, :amount, :note, :timestamp, 1)');
                    $stmt->execute([
                        ':id' => $id, 
                        ':user_id' => $user_id,
                        ':type' => 'income', 
                        ':category' => $parsedAns['tool']['args']['category'], 
                        ':amount' => $parsedAns['tool']['args']['amount'], 
                        ':note' => $parsedAns['tool']['args']['note'], 
                        ':timestamp' => $parsedAns['tool']['args']['timestamp']
                    ]);
                    break;

                case 'get_total_expense':
                    $parsedAns['content'] = getTotalByType($db, $user_id, 'expense', $parsedAns['tool']['args']);
                    break;

                case 'get_total_income':
                    $parsedAns['content'] = getTotalByType($db, $user_id, 'income', $parsedAns['tool']['args']);
                    break;

                case 'get_transactions':
                    $parsedAns['content'] = buildLedgerContext($db, $user_id, [
                        'start' => normalizeTimestamp($parsedAns['tool']['args']['start'] ?? $range['start']),
                        'end' => normalizeTimestamp($parsedAns['tool']['args']['end'] ?? $range['end']),
                        'label' => 'requested range'
                    ]);
                    break;

                default:
                    break;
            }
        }
    } else {
        return $parsedRes;
    }

    $parsedRes['msg']['response'] = json_encode(
        $parsedAns,
        JSON_UNESCAPED_UNICODE
    );

    return $parsedRes;
}

function getLLMHistory($cmsData) {
    $url =  "http://localhost:5000/api/get_chat_history";

    $ch = curl_init($url);

    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);

    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($cmsData));

    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json'
    ]);

    curl_setopt($ch, CURLOPT_TIMEOUT, 10);

    $response = curl_exec($ch);

    if (curl_errno($ch)) {
        return [
            'error' => curl_error($ch)
        ];
    }

   $parsedRes = json_decode($response, true);
    
    // Use error_log() to see output in terminal (not in response)
    // error_log("getLLMHistory Response: " . print_r($parsedRes['msg'], true));

    foreach ($parsedRes['msg']['chat_history'] as &$msg) {

    if (($msg['role'] ?? '') === 'ai') {

        $content = json_decode($msg['content'], true);

        if (!$content || !is_array($content)) {
            continue;
        }

        if (($content['type'] ?? '') === 'tool') {

            if (($content['content'] ?? '') === '') {

                $content['content'] = 'Action performed.';
            }
        }

        $msg['content'] = json_encode(
            $content,
            JSON_UNESCAPED_UNICODE
        );
    }
}

    unset($msg);
   
   return $parsedRes;
}

function convertDateToTimestamp($dateStr) {
    $now = new DateTime("now", new DateTimeZone("UTC"));

    if ($dateStr === "today") {
        $dt = clone $now;
    } elseif ($dateStr === "yesterday" || $dateStr === "yesteday") {
        $dt = (clone $now)->modify("-1 day");
    } else {
        $dt = new DateTime($dateStr, new DateTimeZone("UTC"));
    }

    return $dt->getTimestamp() * 1000; // 👈 millisecond
}

function detectLedgerDateRange($message) {
    $timezone = new DateTimeZone('Asia/Kuala_Lumpur');
    $now = new DateTime('now', $timezone);
    $text = function_exists('mb_strtolower')
        ? mb_strtolower((string)$message, 'UTF-8')
        : strtolower((string)$message);

    if (preg_match('/(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})/', $text, $matches)) {
        $start = new DateTime(sprintf('%04d-%02d-%02d 00:00:00', $matches[1], $matches[2], $matches[3]), $timezone);
        return makeRange($start, (clone $start)->modify('+1 day'), 'specified day');
    }

    if (preg_match('/(\d{4})年\s*(\d{1,2})月\s*(\d{1,2})日?/', $text, $matches)) {
        $start = new DateTime(sprintf('%04d-%02d-%02d 00:00:00', $matches[1], $matches[2], $matches[3]), $timezone);
        return makeRange($start, (clone $start)->modify('+1 day'), 'specified day');
    }

    if (preg_match('/(\d{4})[-\/](\d{1,2})(?![-\/\d])/', $text, $matches) ||
        preg_match('/(\d{4})年\s*(\d{1,2})月/', $text, $matches)) {
        $start = new DateTime(sprintf('%04d-%02d-01 00:00:00', $matches[1], $matches[2]), $timezone);
        return makeRange($start, (clone $start)->modify('first day of next month'), 'specified month');
    }

    if (preg_match('/(\d{1,2})月\s*(\d{1,2})日?/', $text, $matches)) {
        $start = new DateTime(sprintf('%04d-%02d-%02d 00:00:00', (int)$now->format('Y'), $matches[1], $matches[2]), $timezone);
        return makeRange($start, (clone $start)->modify('+1 day'), 'specified day');
    }

    if (preg_match('/(\d{4})年|year\s+(\d{4})|(\d{4})\s+year/', $text, $matches)) {
        $year = firstMatchedInt(array_slice($matches, 1));
        $start = new DateTime(sprintf('%04d-01-01 00:00:00', $year), $timezone);
        return makeRange($start, (clone $start)->modify('+1 year'), 'specified year');
    }

    if (containsAny($text, ['今天', '今日', '这天', '当天', '本日', 'today'])) {
        $start = (clone $now)->setTime(0, 0, 0);
        return makeRange($start, (clone $start)->modify('+1 day'), 'today');
    }

    if (containsAny($text, ['昨天', '昨日', 'yesterday'])) {
        $start = (clone $now)->modify('-1 day')->setTime(0, 0, 0);
        return makeRange($start, (clone $start)->modify('+1 day'), 'yesterday');
    }

    if (containsAny($text, ['上个月', '上月', 'last month'])) {
        $start = (clone $now)->modify('first day of last month')->setTime(0, 0, 0);
        return makeRange($start, (clone $start)->modify('first day of next month'), 'last month');
    }

    if (containsAny($text, ['这个月', '本月', '月', 'month', 'this month'])) {
        $start = (clone $now)->modify('first day of this month')->setTime(0, 0, 0);
        return makeRange($start, (clone $start)->modify('first day of next month'), 'this month');
    }

    if (containsAny($text, ['去年', 'last year'])) {
        $start = new DateTime(((int)$now->format('Y') - 1) . '-01-01 00:00:00', $timezone);
        return makeRange($start, (clone $start)->modify('+1 year'), 'last year');
    }

    if (containsAny($text, ['今年', '本年', '年', 'year', 'this year'])) {
        $start = new DateTime($now->format('Y') . '-01-01 00:00:00', $timezone);
        return makeRange($start, (clone $start)->modify('+1 year'), 'this year');
    }

    if (containsAny($text, ['上星期', '上周', 'last week'])) {
        $start = (clone $now)->modify('monday last week')->setTime(0, 0, 0);
        return makeRange($start, (clone $start)->modify('+1 week'), 'last week');
    }

    $start = (clone $now)->modify('monday this week')->setTime(0, 0, 0);
    return makeRange($start, (clone $start)->modify('+1 week'), 'this week');
}

function makeRange($start, $end, $label) {
    return [
        'start' => $start->getTimestamp() * 1000,
        'end' => $end->getTimestamp() * 1000,
        'label' => $label,
        'start_text' => $start->format(DateTime::ATOM),
        'end_text' => $end->format(DateTime::ATOM)
    ];
}

function containsAny($text, $needles) {
    foreach ($needles as $needle) {
        $position = function_exists('mb_strpos')
            ? mb_strpos($text, $needle, 0, 'UTF-8')
            : strpos($text, $needle);

        if ($position !== false) {
            return true;
        }
    }

    return false;
}

function firstMatchedInt($values) {
    foreach ($values as $value) {
        if ($value !== '') {
            return (int)$value;
        }
    }

    return (int)date('Y');
}

function buildLedgerContext($db, $user_id, $range) {
    $stmt = $db->prepare('
        SELECT id, type, category, amount, note, timestamp
        FROM transactions
        WHERE user_id = :user_id
        AND timestamp >= :start
        AND timestamp < :end
        AND deleted != 1
        ORDER BY timestamp DESC
    ');

    $stmt->execute([
        ':user_id' => $user_id,
        ':start' => $range['start'],
        ':end' => $range['end']
    ]);

    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return json_encode([
        'range' => $range,
        'summary' => summarizeTransactions($rows),
        'transactions' => $rows
    ], JSON_UNESCAPED_UNICODE);
}

function summarizeTransactions($rows) {
    $summary = [
        'total_expense' => 0,
        'total_income' => 0,
        'net' => 0,
        'count' => count($rows),
        'by_expense_category' => [],
        'by_income_category' => []
    ];

    foreach ($rows as $row) {
        $amount = (float)$row['amount'];
        $category = $row['category'] ?: 'uncategorized';

        if (($row['type'] ?? '') === 'income') {
            $summary['total_income'] += $amount;
            $summary['by_income_category'][$category] = ($summary['by_income_category'][$category] ?? 0) + $amount;
        } else {
            $summary['total_expense'] += $amount;
            $summary['by_expense_category'][$category] = ($summary['by_expense_category'][$category] ?? 0) + $amount;
        }
    }

    $summary['net'] = $summary['total_income'] - $summary['total_expense'];
    arsort($summary['by_expense_category']);
    arsort($summary['by_income_category']);

    return $summary;
}

function getTotalByType($db, $user_id, $type, $args) {
    $start = normalizeTimestamp($args['start'] ?? null);
    $end = normalizeTimestamp($args['end'] ?? null);

    $stmt = $db->prepare('
        SELECT COALESCE(SUM(amount), 0) AS total
        FROM transactions
        WHERE user_id = :user_id
        AND type = :type
        AND timestamp >= :start
        AND timestamp < :end
        AND deleted != 1
    ');

    $stmt->execute([
        ':user_id' => $user_id,
        ':type' => $type,
        ':start' => $start,
        ':end' => $end
    ]);

    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    return json_encode([
        'type' => $type,
        'start' => $start,
        'end' => $end,
        'total' => (float)($row['total'] ?? 0)
    ], JSON_UNESCAPED_UNICODE);
}

function normalizeTimestamp($value) {
    if (is_numeric($value)) {
        return (int)$value;
    }

    if (!$value) {
        return round(microtime(true) * 1000);
    }

    return convertDateToTimestamp($value);
}
