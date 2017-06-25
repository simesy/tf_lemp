<?php

include "../db-credentials.php";

$conn = new PDO("mysql:host=$db_host;dbname=drupal", "drupal", $db_pass);

$sql = "SELECT `test_field` FROM `test_table`";
$result = $conn->query($sql);

while($row = $result->fetch(PDO::FETCH_ASSOC)) {
  echo $row["test_field"];
}

