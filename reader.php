<?php
//
// Deegin dashboard
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
$user = BBoilerplate::user();
$articles = BBoilerplate_Library::listAll();
?><!DOCTYPE HTML><html><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" /><?=BBoilerplate::incl('Core.js', 'js')?><?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Reader.css', 'css')?></head><body>
<div id="container">
        <ul id="sortableHeader">
            <button id="createNote" class="headerButton"><img src="/Lib/Icons/Fill/note.png" class="libImageTitle"> Create a note</button>
            <button type="button" id="showPandT" class="headerButton"><img src="/Lib/Icons/Fill/article.png" class="libImageTitle">Manage my projects</button>
            <button type="button" id="readerHelp" class="headerButton"><img src="/Lib/Icons/Fill/help.png" class="libImageTitle">Help</button>
            <button type="button" id="download_PDF" class="headerButton" style="display:none;"><img src="/Lib/Icons/Fill/cloud.png" class="libImageTitle" >Download selection PDF [0]</button>
            <button type="button" id="remover" class="headerButton" style="display:none;"><img src="/Lib/Icons/Fill/logout.png" class="libImageTitle">Remove selection [0]</button>
        </ul>
        
        <ul id="sortable">
        <?php if(count($articles)==0){ ?>
			<span>You don't have any articles attached to you Reader, go to <a href="/dashboard" target="_self">Search &amp; Discover</a> to search for articles or click on <a href="/view?i=N" target="_self">create a note</a> to add something to your Reader</span>
		<?php } else { ?>
			<?php foreach($articles as $article){ ?>
                <li class="ui-state-deegin" id="<?=$article['pii']?>">
                    <table>
                        <tr>
                            <td style="width:1%;">
                                <span style="display:none;">
                                    <input type="checkbox" name="select" value="Pii">
                                </span>
                            </td>
                            <td style="width:94%;">
                                <span class="projectTitle">
                                <?php if(substr($article['pii'], 0, 1)=='N'){ ?>
                                	<img src="/Lib/Icons/Open/note.png" class="libImageTitle"><?=$article['title']?></span>
                                <?php } else { ?>
                                	<img src="/Lib/Icons/Open/article.png" class="libImageTitle"><?=$article['title']?></span>
                                <?php } ?>
                                <div class="projectDesc">
                                    <?=$article['desc']?>
                                </div>
                                <div class="projectView">
                                	<?=BBoilerplate_Html::projectViewSingle($article['pii'])?>
                                    <span class="projectViewSingle add">+project</span>
                                    <?php if($article['time']!='9999-12-31 23:59:59' && $article['time']!='0000-00-00 00:00:00'){
                                            if(strtotime($article['time'])<time()){
                                                echo '<span class="libTime"><img src="/Lib/Icons/Open/time.png" class="libImage"><span class="libTimeText" style="color:red !important"	>' . $article['time'].'</span>&nbsp;<img src="/Lib/Icons/Open/remove.png" class="libImage remove" id="remove_'.$article['pii'].'"></span>';
                                            } else {
                                                echo '<span class="libTime"><img src="/Lib/Icons/Open/time.png" class="libImage"><span class="libTimeText">' . $article['time'].'</span></span>';
                                            }
                                        }?>
                                </div>
                            </td>
                            <td style="width:5%;">
                                <img class="handle" src="/Lib/Img/drag.png" border="0">
                            </td>
                        </tr>
                    </table>
                </li>
                <?php } ?>
            <?php } ?>
        </ul>
</div>
</body>
</html>