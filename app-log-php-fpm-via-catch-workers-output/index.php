<?php

// Log a message longer than 1024 chars to stdout
file_put_contents("php://stdout", str_repeat("0", 1020) .  "Log message to stdout\n");

// Log a message to stderr
file_put_contents("php://stderr", "Log message to stderr\n");

// Send response
header('Content-Type: text/plain');
echo "This is the HTTP response content.";
