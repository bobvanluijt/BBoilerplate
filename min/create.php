<?php
//
// saves to cache dir
//
if ($handle = opendir('../Lib/Css')) {
	$url = 'https://read.deeg.in/min/index?f=';
    while (false !== ($entry = readdir($handle))) {
		if(pathinfo($entry, PATHINFO_EXTENSION)=='css'){
			if($entry=='Core.css'){
				$url = 'https://read.deeg.in/min/index?f=/Lib/Css/Reset.css,/Lib/Css/Core.css';
				file_put_contents("../Cache/JsCss/".$entry, fopen($url, 'r'));
			} else {
				$url = 'https://read.deeg.in/min/index?f=/Lib/Css/'.$entry;
				file_put_contents("../Cache/JsCss/".$entry, fopen($url, 'r'));
			}
		}
	}
    closedir($handle);
}

if ($handle = opendir('../Lib/Js')) {
    while (false !== ($entry = readdir($handle))) {
		if(pathinfo($entry, PATHINFO_EXTENSION)=='js'){
        	$url = 'https://read.deeg.in/min/index?f=/Lib/Js/'.$entry;
			file_put_contents("../Cache/JsCss/".$entry, fopen($url, 'r'));
		}
	}
    closedir($handle);
}