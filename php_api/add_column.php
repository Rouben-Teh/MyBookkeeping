
<?php

$db = new PDO('sqlite:bookkeeping.sqlite');
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$db->exec("
  ALTER TABLE transactions ADD COLUMN synced INTEGER DEFAULT 0;
");
$db->exec("
  ALTER TABLE transactions ADD COLUMN deleted INTEGER DEFAULT 0;
");

echo "OK\n";
?>