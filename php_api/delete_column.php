<?php
    $db = new PDO('sqlite:bookkeeping.sqlite');

    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $column_to_drop = 'token';
    $table_name = 'accounts';

    $sql = "ALTER TABLE $table_name DROP COLUMN $column_to_drop";

    $db->exec($sql);

    echo "Column '$column_to_drop' dropped successfully from table '$table_name'.";
?>