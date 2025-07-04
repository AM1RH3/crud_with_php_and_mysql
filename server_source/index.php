<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$connection = mysqli_connect("localhost", "root", "", "flutter_test");

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    // GET DATA

    $query = "SELECT * FROM `users`";
    $result = mysqli_query($connection, $query);

    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);

    echo json_encode($data);
    
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // INSERT DATA
    $userInput = json_decode(file_get_contents('php://input'), true);

    $name = $userInput['name'];
    $lastName = $userInput['lastName'];
    $age = $userInput['age'];


    $query = "INSERT INTO `users` (`name`, `lastName`, `age`) VALUES ('$name', '$lastName', '$age')";
    $result = mysqli_query($connection, $query);

    echo json_encode([
        'status' => $result ? 'success' : 'error',
        'message' => $result ? 'Data inserted successfully' : 'Failed to insert data'
    ]);
}

if ($_SERVER['REQUEST_METHOD'] == 'DELETE') {
    // DELETE DATA

    $userInput = json_decode(file_get_contents('php://input'), true);

    $id = $userInput['id'];

    $query = "DELETE FROM `users` WHERE `id` = '$id'";
    $result = mysqli_query($connection, $query);

    echo json_encode([
        'status' => $result ? 'success' : 'error',
        'message' => $result ? 'Data deleted successfully' : 'Failed to delete data'
    ]);
}

if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
    // UPDATE DATA

    $userInput = json_decode(file_get_contents('php://input'), true);

    $id = $userInput['id'];
    $name = $userInput['name'];
    $lastName = $userInput['lastName'];
    $age = $userInput['age'];

    $query = "UPDATE `users` SET `name` = '$name', `lastName` = '$lastName', `age` = '$age' WHERE `id` = '$id'";
    $result = mysqli_query($connection, $query);

    echo json_encode([
        'status' => $result ? 'success' : 'error',
        'message' => $result ? 'Data updated successfully' : 'Failed to update data'
    ]);
}
?>