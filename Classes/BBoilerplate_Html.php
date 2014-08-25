<?php
class BBoilerplate_Html {
	/*
	 * Outputs a full HTML article
	 */
	public function render($Pii){
		if(substr($Pii, 0, 1)=='N'){
			$noteHtml = file_get_contents('./Lib/Phtml/note.phtml');
			DB::connect();
			$user = BBoilerplate::user();
		 	$results = DB::pull("SELECT p.title AS title, n.text AS text FROM purchases AS p INNER JOIN notes AS n ON p.id = n.mainId WHERE user = '".$user['id']."' AND pii = '".$Pii."' LIMIT 1");
			foreach($results as $result){
				$noteHtml = str_replace("[[title]]", $result['title'], $noteHtml);
				$noteHtml = str_replace("[[text]]", $result['text'], $noteHtml);	
			}
			return $noteHtml;
		} else {
			$string = '<?xml version="1.0" encoding="UTF-8"?>'.BBoilerplate_Api::article($Pii, 'FULL', false);
			$options = LIBXML_COMPACT|LIBXML_NOENT|LIBXML_NOXMLDECL|LIBXML_NSCLEAN;
			$dom = new DOMDocument();
			$dom->substituteEntities = TRUE;
			$dom->encoding = mb_detect_encoding($string);
			$string = mb_convert_encoding($string, mb_detect_encoding($string), mb_detect_encoding($string));
			$dom->loadXml($string, $options);
			$xsl = new DOMDocument();
			$xsl->encoding = mb_detect_encoding($string);
			$xsl->load('Lib/Xsl/document.xsl', $options);
			$proc = new XSLTProcessor();
			$proc->importStylesheet($xsl);
			$xml = $proc->transformToXML($dom);
			return html_entity_decode($xml, ENT_QUOTES, mb_detect_encoding($string));
		}
	}
	
	public function renderNote(){
		/*
		 * Renders a note and redirects
		 */
		$user = BBoilerplate::user();
		$randomNote = 'N'.rand(1000000000000000, 9999999999999999);
		$lastId = DB::push("INSERT INTO `purchases` (`user`, `pii`, `title`, `desc`, `time`) VALUES ('".$user['id']."', '".$randomNote."', 'Title for your new note...', 'Description...', '9999-12-31 23:59:59');");
		DB::push("INSERT INTO `notes` (`mainId`, `text`) VALUES ('".$lastId."', 'Click here to start typing...');");
		header('Location: /view?i='.$randomNote);
		exit;
	}
	
	public function projectViewSingle($Pii){
		/*
		 * Renders the divs for projects with colors
		 */
		 $user = BBoilerplate::user(); 
		 $results = DB::pull("SELECT p.projects AS projects FROM purchases AS p WHERE p.pii = '".$Pii."' AND p.user = '".$user['id']."' LIMIT 1");
		 foreach($results as $result){
			$projects = explode("|", $result['projects']);	 
		 }
		 $returner = '';
		 foreach($projects as $project){
			 $results = DB::pull("SELECT id, name, color FROM projects WHERE id = '".$project."' LIMIT 1");
			 foreach($results as $result){
				$returner .= '<span class="projectViewSingle" rel="'.$result['id'].'" style="background-color:'.$result['color'].' !important">'.$result['name'].'</span>';
			 }
		 }
		 return $returner;
	}
}