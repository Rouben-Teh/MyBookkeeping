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
args: timestamp, amount, source

get_total_expense:
args: timestamp

get_total_income:
args: timestamp

Rules:
- Use tool ONLY when user requests action
- Otherwise use type = "chat"
- If tool is used, content must be ""
- If chat, tool must be {}

User input:
{{input}}
EOT;

function callLLM($user_id, $db, $cmsData) {
    $url =  "http://localhost:5000/api/chat";

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
                    $stmt = $db->prepare('INSERT INTO transactions (id, user_id, category, amount, note, timestamp, synced) VALUES (:id, :user_id, :category, :amount, :note, :timestamp, 1)');
                    $stmt->execute([
                        ':id' => $id, 
                        ':user_id' => $user_id, 
                        ':category' => $parsedAns['tool']['args']['category'], 
                        ':amount' => $parsedAns['tool']['args']['amount'], 
                        ':note' => $parsedAns['tool']['args']['note'], 
                        ':timestamp' => $parsedAns['tool']['args']['timestamp']
                    ]);
                    break;

                case 'add_income':
                    // 执行代码
                    break;

                case 'get_total_expense':
                    // 执行代码
                    break;

                case 'get_total_income':
                    // 执行代码
                    break;

                default:
                    break;
            }
        }
    }

    $parsedRes['msg']['response'] = json_encode(
        $parsedAns,
        JSON_UNESCAPED_UNICODE
    );

    return $parsedRes;
}

function convertDateToTimestamp($dateStr) {
    $now = new DateTime("now", new DateTimeZone("UTC"));

    if ($dateStr === "today") {
        $dt = clone $now;
    } elseif ($dateStr === "yesteday") {
        $dt = (clone $now)->modify("-1 day");
    } else {
        $dt = new DateTime($dateStr, new DateTimeZone("UTC"));
    }

    return $dt->getTimestamp() * 1000; // 👈 millisecond
}