<?php

include "connect.php";

$stmt = $con->prepare("SELECT *FROM users");
$stmt->execute();
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);

// echo"<pre>";

// print_r($users);
// echo"<pre>";

echo json_encode($users);
?>