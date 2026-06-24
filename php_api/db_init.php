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

//token
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
    type TEXT NOT NULL CHECK(type IN ('expense', 'income')),
    category TEXT NOT NULL,
    amount REAL NOT NULL,  
    note TEXT,
    timestamp INTEGER DEFAULT ((strftime('%s','now') * 1000, 'unixepoch', 'localtime')),
    created_at TEXT DEFAULT (datetime('now','localtime')),
    synced INTEGER DEFAULT 0,
    deleted INTEGER DEFAULT 0,
    FOREIGN KEY(user_id) REFERENCES accounts(id)
)
");

// plans table
$db->exec("
CREATE TABLE IF NOT EXISTS plans (
    id TEXT NOT NULL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK(type IN ('expense', 'income')),
    amount REAL NOT NULL,  
    installments INTEGER DEFAULT 0,
    fix_payment INTEGER DEFAULT 0,
    interval_format INTEGER DEFAULT 0,
    intervals INTEGER DEFAULT 0,
    timestamp INTEGER DEFAULT ((strftime('%s','now') * 1000, 'unixepoch', 'localtime')),
    auto_add_to_ledger INTEGER DEFAULT 0,
    paid_installments INTEGER DEFAULT 0,
    created_at TEXT DEFAULT (datetime('now','localtime')),
    synced INTEGER DEFAULT 0,
    deleted INTEGER DEFAULT 0,
    FOREIGN KEY(user_id) REFERENCES accounts(id)
)
");

// settings table
$db->exec("
CREATE TABLE IF NOT EXISTS settings (
    user_id INTEGER PRIMARY KEY,
    metadata TEXT,
    synced INTEGER DEFAULT 0
)
");

// faq table
$db->exec("
CREATE TABLE IF NOT EXISTS faq (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT,
    title TEXT,
    content TEXT,
    created_at TEXT DEFAULT (datetime('now','localtime')),
    last_updated TEXT DEFAULT (datetime('now','localtime')),
    disable INTEGER DEFAULT 0
)
");

// contact table
$db->exec("
CREATE TABLE IF NOT EXISTS contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    device_type TEXT,
    name TEXT,
    email TEXT,
    message TEXT,
    created_at TEXT DEFAULT (datetime('now','localtime'))
)
");

echo "OK\n";
?>