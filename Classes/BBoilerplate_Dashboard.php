<?php
class BBoilerplate_Dashboard {
	function getTop(){
		$i = 1;
		$returner = array();
		$xml = simplexml_load_file('http://top25.sciencedirect.com/rss.php');
		foreach($xml->channel->item as $item){
			$returner[$i]['title'] = $item->title;
			$returner[$i]['description'] = $item->description;
			$returner[$i]['i'] = parse_url($item->guid, PHP_URL_PATH);
			$pieces = explode("/", $returner[$i]['i']);
			krsort($pieces);
			$returner[$i]['i'] = $pieces[4];
			$i++;
		}
		return $returner;
	}
}