<?php
$db = new PDO('sqlite:bookkeeping.sqlite');
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// accounts table
$db->exec("
CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    token TEXT,
    created_at TEXT DEFAULT (datetime('now','localtime'))
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
    datetime TEXT DEFAULT (datetime('now','localtime')),
    FOREIGN KEY(user_id) REFERENCES accounts(id)
)
");

echo "OK\n";
?>