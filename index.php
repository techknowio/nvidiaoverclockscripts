<?php
//snmpset  -v 3 -n "" -Dusm -u localadmin -a MD5 -A localadmin -l authPriv -x DES -X localadmin 192.168.99.156 1.3.6.1.4.1.850.100.1.10.2.1.4.2  integer 2
$db = new PDO('mysql:host=localhost;dbname=gpuMiners;charset=utf8mb4', 'x', 'x');
?>
<html>
<title>Miners</title>
<script>
function reboot(id) {
	alert("Reboot is coming soon!");
}
</script>
<body>
<table border="1">
<tr>
	<td>Mac Address</td>
	<td>Address</td>
	<td>Last Updated</td>
	<td>Hashrate</td>
	<td>Down Count</td>
	<td>Switch Port</td>
	<td>Actions</td>
</tr>
<?php
$th = 0;
$sql = "select * from currentHashes";
foreach($db->query($sql) as $row) {
	if ($row['down'] == 0) {
		echo "<tr>\n";
		echo "<td>".$row['macAddress']."</td>";
		echo "<td>".$row['ip']."</td>";
		echo "<td>".$row['lastUpdated']."</td>";
		echo "<td>".$row['hashrate']."</td>";
		echo "<td>".$row['downCount']."</td>";
		echo "<td>".$row['switchPort']."</td>";
		echo "<td><input type=\"button\" value=\"Reboot\" onClick=\"reboot('".$row['id']."')\"></td>";
		echo "</tr>\n";
		$th += $row['hashrate'];
	} else {
		echo "<tr bgcolor=\"red\">\n";
		echo "<td>".$row['macAddress']."</td>";
		echo "<td>".$row['ip']."</td>";
		echo "<td>".$row['lastUpdated']."</td>";
		echo "<td>0</td>";
		echo "<td>".$row['downCount']."</td>";
		echo "<td>".$row['switchPort']."</td>";
		echo "<td><input type=\"button\" value=\"Reboot\" onClick=\"reboot('".$row['id']."')\"></td>";
		echo "</tr>\n";
	}
}
if ($th >= 1000) {
	$th = round($th/1000,2) ." GH/s";
} else {
	$th = $th . " MH/s";
}

?>
<tr>
<td colspan="3">Total Hash Rate</td>
<td><?php echo $th ?></td>
<td colspan="3"></td>
</tr>
</table>
<br />
<br />
<a href="https://ethermine.org/miners/C352455DbA90d0520A7667f8aBfd270b2943DDf2" target="_blank">Ethmine.org Stats</a>
</body>
</html>