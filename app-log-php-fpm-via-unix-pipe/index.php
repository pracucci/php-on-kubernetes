<?php

// Log a message longer than 1024 chars
file_put_contents("/var/log/shared/pipe-from-app-to-stdout", str_repeat("0", 1020) .  " Log message\n");

// Log a shorter message
file_put_contents("/var/log/shared/pipe-from-app-to-stdout", "Log message\n");

// Send response
header('Content-Type: text/plain');
echo "This is the HTTP response content.";
