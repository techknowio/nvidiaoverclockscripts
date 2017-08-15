#!/usr/bin/php
<?php
$db = new PDO('mysql:host=localhost;dbname=gpuMiners;charset=utf8mb4', 'x', 'x');
$sql = "update currentHashes set down=1,downCount=downCount+1 where lastUpdated < now() - INTERVAL 5 MINUTE and down != 1";
$stmt = $db->query($sql);

$sql = "update currentHashes set down=0 where lastUpdated > now() - INTERVAL 5 MINUTE";
$stmt = $db->query($sql);

?>