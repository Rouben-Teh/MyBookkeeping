<?php

$db = new PDO('sqlite:bookkeeping.sqlite');
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$db->exec("
ALTER TABLE transactions ADD COLUMN timestamp_new INTEGER;
UPDATE transactions
SET timestamp_new = CAST(timestamp AS INTEGER);
");

$db->exec("
CREATE TABLE IF NOT EXISTS transactions_new (
    id TEXT NOT NULL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    category TEXT NOT NULL,
    amount REAL NOT NULL,  
    note TEXT,
    timestamp INTEGER DEFAULT ((strftime('%s','now') * 1000, 'unixepoch', 'localtime')),
    created_at TEXT DEFAULT (datetime('now','localtime')),
    FOREIGN KEY(user_id) REFERENCES accounts(id)
)
");

$db->exec("
INSERT INTO transactions_new
(id,user_id,category,amount,note,timestamp,created_at)
SELECT
id,user_id,category,amount,note,timestamp_new,created_at
FROM transactions;
DROP TABLE transactions;
ALTER TABLE transactions_new RENAME TO transactions;
");

?>