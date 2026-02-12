<?php
$conn = pg_connect("host=172.18.x.x dbname=your_database user=bill_kaplan password=blackjack!");

if (!$conn) {
    die("Database connection failed.");
}

$result = pg_query($conn, "SELECT username, email FROM users");

echo "<h2>User List</h2>";
echo "<table border='1'>";
echo "<tr><th>Username</th><th>Email</th></tr>";

while ($row = pg_fetch_assoc($result)) {
    echo "<tr>";
    echo "<td>" . htmlspecialchars($row['username']) . "</td>";
    echo "<td>" . htmlspecialchars($row['email']) . "</td>";
    echo "</tr>";
}

echo "</table>";
?>
