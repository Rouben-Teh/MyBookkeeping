<?php 
    $db = require 'db.php';

    $new_category = 'category';
    $new_title = 'new title';
    $new_content = 'new content';

    $stmt = $db->prepare('INSERT INTO faq (category, title, content) VALUES (:category, :title, :content)');
    $stmt->execute([':category' => $new_category, ':title' => $new_title, ':content' => $new_content]);

    echo "Successfully inserted new data title: '$new_title' into faq.";
?>