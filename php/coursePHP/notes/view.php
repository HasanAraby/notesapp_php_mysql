<?php
include "../connect.php";
// include "../functions.php";

$userid = filterRequest('id');


$stmt = $con->prepare("SELECT * FROM notes WHERE `notes_users` = ?");

$stmt->execute(array($userid));
$data = $stmt->fetchALL(PDO::FETCH_ASSOC);
 $count = $stmt->rowCount();

 if($count > 0){
    echo json_encode (array('status' => 'success', 'data' => $data));
}else{

    echo json_encode (array('status' => 'fail'));
}
