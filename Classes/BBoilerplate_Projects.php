<?php
//
// Projects class, all projects are in here
//
class BBoilerplate_Projects {
	
	
	/*
	 * Creates new Project, HTML output
	 */
	public function listProjects(){
		 $html  = '<!--addProjects-->';
		 DB::connect();
		 $user = BBoilerplate::user();
		 $results = DB::pull("SELECT * FROM projects WHERE user = '".$user['id']."' ORDER BY name ASC;");
		 foreach($results as $result){
			 $html .= '<div class="newProject" id="'.$result['id'].'" style="background-color:'.$result['color'].';">'.$result['name'].'</div>';
		 }
		 $html .= '<div class="newProject">New</div>';
		 return $html;
	}
	
	/*
	 * Creates new Project, HTML output
	 */
	public function newProject(){
		 $html = 'Project name:<br><input type="text" name="fname" />
		 <br>
		 Project color:<br><span class="projectColor">&nbsp;</span>
		 <br>
		 Invite peers:<br><textarea name="fname"></textarea>';
		 return $html;
	}
	
	/*
	 * Loads Project, HTML output
	 */
	public function loadProject($i){
		//deprecated
		 //DB::connect();
		 return;
	}
	
}