<?php
require_once('common.php');
page_header();
echo '<h1>ARIS</h1>';
echo '<p>You have been Logged Out.</p>';
echo '<p><a href = "index.php">Return to ARIS Home</a></p>';
session_destroy();
page_footer_no_nav();

?>