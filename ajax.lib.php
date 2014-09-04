<?php
//
// Deegin dashboard
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
$user = BBoilerplate::user();
$articles = BBoilerplate_Library::listAll(); ?>

<?php if(count($articles)==0){ ?>
			<span>You don't have any articles attached to you library</span>
<?php } else { ?>
	<?php foreach($articles as $article){ ?>
			<div class="singleArticle" id="singleArticle_<?=$article['pii']?>">
            	
                <input type="checkbox" name="selectArticles" value="<?=$article['Pii']?>" class="articleSelection">
            
				<span class="singleArticleTitle"><?=$article['title']?></span>
            	
                <?php if($article['time']!='9999-12-31 23:59:59'){
					if(strtotime($article['time'])<time()){
						echo '<span class="singleArticleDate"><img src="/Lib/Icons/Open/time.png" class="libImage"><span class="libTimeText" style="color:red !important"	>' . $article['time'].'</span>&nbsp;<img src="/Lib/Icons/Open/remove.png" class="libImage remove" id="remove_'.$article['pii'].'"></span>';
					} else {
						echo '<span class="singleArticleDate"><img src="/Lib/Icons/Open/time.png" class="libImage"><span class="libTimeText">' . $article['time'].'</span></span>';
					}
				}?>
            </div>
	<?php } ?>
<?php } ?>
