<?php
$db = new PDO('sqlite:bookkeeping.sqlite');
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// accounts table
$db->exec("
CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now','localtime'))
)
");

$db->exec("
CREATE TABLE IF NOT EXISTS tokens (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    token TEXT NOT NULL,
    device_type TEXT,
    created_at TEXT DEFAULT (datetime('now','localtime')),
    expired_at TEXT,
    is_revoked INTEGER DEFAULT 0
)
");

// transactions table
$db->exec("
CREATE TABLE IF NOT EXISTS transactions (
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

echo "OK\n";
?>