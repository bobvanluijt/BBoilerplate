<?php
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();

$i = $_GET['i'];

header("Content-Type: image/".substr(strrchr($i, '.'), 1));
$size = getimagesize($_GET['i']);

$width = $size[0];
$height = $size[1];

$resizeToWidth = 700;

if($width > $resizeToWidth){
	$newwidth = $resizeToWidth;	
	$newheight = $height / ($width / $resizeToWidth);
} else {
	$newwidth = $width;
	$newheight = $height;
}

$thumb = imagecreatetruecolor($newwidth, $newheight);
if(substr(strrchr($i, '.'), 1)=='gif'){
	$source = imagecreatefromgif($_GET['i']);
} else if(substr(strrchr($i, '.'), 1)=='png'){
	$source = imagecreatefrompng($_GET['i']);
} else if(substr(strrchr($i, '.'), 1)=='jpg'){
	$source = imagecreatefromjpeg($_GET['i']);	
} else if(substr(strrchr($i, '.'), 1)=='jpeg'){
	$source = imagecreatefromjpeg($_GET['i']);	
}

imagecopyresized($thumb, $source, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);

if(substr(strrchr($i, '.'), 1)=='gif'){
	echo file_get_contents($_GET['i']);
} else if(substr(strrchr($i, '.'), 1)=='png'){
	imagepng($thumb);
} else if(substr(strrchr($i, '.'), 1)=='jpg'){
	imagejpeg($thumb);
} else if(substr(strrchr($i, '.'), 1)=='jpeg'){
	imagejpeg($thumb);
}