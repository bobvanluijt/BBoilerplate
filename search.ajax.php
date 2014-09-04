<?php
//
// Search AJAX file, returns JSON data
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
if(isset($_GET['p'])){
	$output = BBoilerplate_Google::q($_GET['i'], $_GET['p']);
} else {
	$output = BBoilerplate_Google::q($_GET['i']);
}

if($_GET['addAll']=='true'){
	if(count($output['r'])==0){
		echo '<h2 style="color:#000; margin-top:0px">We couldn\'t find anything for: '.$output['query'].'</h2>';
		if($output['didYouMean']!==false){
			echo '<h2 style="color:#000; margin-top:0px">Did you maybe mean <a href="/dashboard?i='.time().'#!q='.strip_tags($output['didYouMean'][0]).'" target="_self">'.$output['didYouMean'][0].'</a>?</h2>';	
		}
	} else {
	
		if($output['didYouMean']!==false){
			echo '<h2 style="color:#000; margin-left:20px; margin-top:0px">We\'ve searched for '.str_replace('<b>...</b>', '...', strip_tags($output['didYouMean'][0])).' instead of: '.$output['query'].'</h2>';	
		}
		
		echo '<ul id="sortable" class="ui-sortable">';
		foreach($output['r'] as $result){
			
			//
			//check if openAccess is requested
			//
			if($_GET['type']=='openaccess' && BBoilerplate_Api::openaccess($result['pii'][0])===false){
				echo '</ul>'; //echo closing ul
				exit;
			}
			
			if($result['issue'][0]!=''){
				$issue = '(issue: '.$result['issue'][0].')';
			} else {
				$issue = '';
			}
			//
			//check for openaccess
			//
			if(BBoilerplate_Api::openaccess($result['pii'][0])===true){
				$openaccess = '<span class="projectViewSingle openaccess"><img src="/Lib/Img/OA.png" class="libImageTitle"><a href="/view?i='.$result['pii'][0].'" target="_self">open access</a></span>';
				$openaccess .= '<span class="projectViewSingle add isinLib"><a href="#" class="addToLib">add to reader</a></span>';
			} else {
				$openaccess = '<span class="projectViewSingle add isInOwner"><a href="/view?i='.$result['pii'][0].'" target="_self">buy or rent</a></span>';
				$openaccess .= '<span class="projectViewSingle add isInLib"><a href="#" class="addToLib">add abstract to reader</a></span>';
			}
				
			echo '<li class="ui-state-deegin ui-state-deegin-nocheck" id="'.$result['pii'][0].'">';
			echo '<table>
					<tbody>
						<tr>
						<td style="width:1%;">
							<span style="display:none;">
								<input type="checkbox" name="select" value="Pii">
							</span>
						</td>
						<td style="width:94%;">
							<span class="projectTitle"><h2>'.str_replace('<b>...</b>', '...', strip_tags($result['title'][0])).'</h2></span>
							<div class="projectDesc googleResult">'.str_replace('<b>...</b>', '...', strip_tags($result['description'][0], '<b>')).'</div>
							<div class="projectDesc">'.$result['date'][0].', '.$result['journal_title'][0].' '.$issue.' - '.str_replace(";", "; ", $result['authors'][0]).'</div>
							<div class="moreInfo" style="display:none">&nbsp;</div>
							<div class="projectView">
								'.$openaccess.'
							</div>
						</td>
					</tr>
				</tbody>
			</table>';
			echo '</li>';
			
		}
		echo '</ul>';
	}
} else {
	//
	// only add a li
	//
	//check for openaccess
	//
	foreach($output['r'] as $result){
		//
		//check if openAccess is requested
		//
		if($_GET['type']=='openaccess' && BBoilerplate_Api::openaccess($result['pii'][0])===false){
			echo ''; //echo empty
			exit;
		}
		
		
		if($result['pii'][0]==''){
			exit;	
		}
		
			if($result['issue'][0]!=''){
				$issue = '(issue: '.$result['issue'][0].')';
			} else {
				$issue = '';
			}
		if(BBoilerplate_Api::openaccess($result['pii'][0])===true){
			$openaccess = '<span class="projectViewSingle openaccess"><img src="/Lib/Img/OA.png" class="libImageTitle"><a href="/view?i='.$result['pii'][0].'" target="_self">open access</a></span>';
			$openaccess .= '<span class="projectViewSingle add isinLib"><a href="#" class="addToLib">add to reader</a></span>';
		} else {
			$openaccess = '<span class="projectViewSingle add isInOwner"><a href="/view?i='.$result['pii'][0].'" target="_self">buy or rent</a></span>';
			$openaccess .= '<span class="projectViewSingle add isInLib"><a href="#" class="addToLib">add abstract to reader</a></span>';
		}
		echo '<li class="ui-state-deegin ui-state-deegin-nocheck" id="'.$result['pii'][0].'">';
		echo '<table>
				<tbody>
					<tr>
					<td style="width:1%;">
						<span style="display:none;">
							<input type="checkbox" name="select" value="Pii">
						</span>
					</td>
					<td style="width:94%;">
						<span class="projectTitle"><h2><!--<img src="/Lib/Icons/Open/article.png" class="libImageTitle">-->'.str_replace('<b>...</b>', '...', strip_tags($result['title'][0])).'</h2></span>
						<div class="projectDesc googleResult">'.str_replace('<b>...</b>', '...', strip_tags($result['description'][0], '<b>')).'</div>
						<div class="projectDesc">'.$result['date'][0].', '.$result['journal_title'][0].' '.$issue.' - '.str_replace(";", "; ", $result['authors'][0]).'</div>
						<div class="moreInfo" style="display:none">&nbsp;</div>
						<div class="projectView">
							'.$openaccess.'
						</div>
					</td>
				</tr>
			</tbody>
		</table>';
		echo '</li>';
	}
}