<?php
//
// Deegin profile
//
include_once('./Classes/BBoilerplate_Core.php');
BBoilerplate::run();
BBoilerplate::validateUser();
$user = BBoilerplate::user();
//
// is there a credit card?
//
if($user['paypal'][0]['lastNumbers']!=''){
	$creditcardDisplay = 'none';
} else {
	$creditcardDisplay = 'block';
} ?><!DOCTYPE HTML><html><head><script src="//cdn.optimizely.com/js/1765710109.js"></script><meta name="viewport" content="initial-scale=1, user-scalable=no"/><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><title>Deegin BETA - Where research gets down to business</title><link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" /><?=BBoilerplate::incl('Core.js', 'js')?><?=BBoilerplate::incl('Core.css', 'css')?><?=BBoilerplate::incl('Profile.css', 'css')?></head><body>
    <div id="container">
        <table width="100%" border="0">
          <tr>
            <td style="width:1px"><img src="<?=reset(explode('?', $user['picture']))?>" id="profileImage" /></td>
            <td><h1 class="nameTD"><?=htmlspecialchars($user['firstname'])?> <?=htmlspecialchars($user['lastname'])?></h1></td>
          </tr>
        </table>
        <a href="#balance">balance</a> - <a href="#pricing">pricing</a> - <a href="#details">details</a> - <a href="#payment">payment</a> - <a href="#options">options</a> - <a href="#logout">logout</a>
        <span style="display:none">
        <a name="balance"><h1>Account balance</h1></a>
        <table width="100%" border="0">
          <tr>
            <td colspan="2"><input type="text" autocomplete="off" id="accountBalance" style="width:296px;height:60px;font-size:30px;" value="$<?=number_format((float)round($user['tokens']/100,2), 2, '.', '');?>" disabled /><br>
            <div style="font-size:10px;">* If you attempt to buy or rent an article, that costs more than your current balance allows, we will ask your permission to charge your credit card for the amount that exceeds your account balance.</div>
            </td>
          </tr>
        </table>
        <?php if($creditcardDisplay=='none'){ ?>
        <br>Upgrade your balance with discount:
			<table width="100%" border="0">
              <tr>
                <td>
                	<p><button id="buyBulk__1" class="buyBulk" type="button" style="width:296px;margin-bottom:6px;">Buy 5 Articles ($175) for only $165</button></p>
                    
                </td>
              </tr>
              <tr>
                <td>
                	<p><button id="buyBulk__2" class="buyBulk" type="button" style="width:296px;margin-bottom:6px;">Buy 10 Articles ($350) for only $320</button></p>
                </td>
              </tr>
              <tr>
                <td>
                	<p><button id="buyBulk__3" class="buyBulk" type="button" style="width:296px;margin-bottom:6px;">Buy 15 Articles ($525) for only $465</button></p>
                </td>
              </tr>
              <tr>
                <td>
                	<p><button id="buyBulk__4" class="buyBulk" type="button" style="width:296px;margin-bottom:6px;">Buy 25 Articles ($875) for only $745</button></p>
                </td>
              </tr>
            </table>
		<?php } else { ?>
        	<a name="setup"><h1>Account setup</h1></a>
        	As soon as your credit card is set up, you can begin to access the world’s leading collection of primary STM research, including thousands of free open access articles.<br><a href="#payment">Set up my FREE account</a>
        <?php } ?>
        </span>
        <a name="pricing"><h1>Pricing</h1></a>
        <table style="width:296px" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td style="width:55%">1 article rental (36 hours)</td>
            <td>$5.00</td>
          </tr>
          <tr>
            <td>1 article purchase</td>
            <td>$31.50* to $41.95</td>
          </tr>
          <tr>
            <td>Open Access Articles</td>
            <td>Free</td>
          </tr>
          <tr>
            <td colspan="2" style="font-size:12px">* Some articles specially priced below $31.50</td>
          </tr>
        </table>
        <a name="details">
        <h1>Account details</h1></a>
        <form action="ajax.actions?i=profile" method="POST" target="_self">
        <table width="100%" border="0">
          <tr>
            <td colspan="2">Login e-mail *<br><input type="text" autocomplete="off" style="width:296px;" value="<?=htmlspecialchars($user['email'])?>" disabled /></td>
          </tr>
		  <tr>
            <td colspan="2">Contact e-mail<br><input type="text" autocomplete="off" style="width:296px;" name="contactEmail" value="<?=htmlspecialchars($user['contactEmail'])?>" /></td>
          </tr>
          <tr>
          	<td colspan="2">First name<br><input type="text" autocomplete="off" style="width:296px;" name="firstname" value="<?=htmlspecialchars($user['firstname'])?>" /></td>
          </tr>
          <tr>
          	<td colspan="2">Last name<br><input type="text" autocomplete="off" style="width:296px;" name="lastname" value="<?=htmlspecialchars($user['lastname'])?>" /></td>
          </tr>
          <tr>
          	<td colspan="2">Company<br><input type="text" autocomplete="off" style="width:296px;" name="company" value="<?=htmlspecialchars($user['company'])?>" /></td>
          </tr>
          <tr>
          	<td colspan="2">Address<br><input type="text" autocomplete="off" style="width:296px;" name="address" value="<?=htmlspecialchars($user['address'])?>" /></td>
          </tr>
          <tr>
          	<td colspan="2">Postal code<br><input type="text" autocomplete="off" style="width:296px;" name="postal" value="<?=htmlspecialchars($user['postal'])?>" /></td>
          </tr>
          <tr>
          	<td colspan="2">City<br><input type="text" autocomplete="off" style="width:296px;" name="city" value="<?=htmlspecialchars($user['city'])?>" /></td>
          </tr>
          <tr>
          	<td colspan="2">Country **<br><?=BBoilerplate::countryList(true)?></td>
          </tr>
          <tr>
          	<td colspan="2"><br><button type="submit" style="width:296px;">Save</button></td>
          </tr>
        </table>
        </form>
        <p>&nbsp;</p>
        <div style="font-size:10px;">* This is the email you prefer us to use to contact you.  If you do not supply a Contact email, we will use the address connected to the account you used to log in for any correspondence.</div>
        <div style="font-size:10px;">** VAT is added if required for your country.</div>
        <a name="payment"><h1>Account payment</h1></a>
        <form id="creditcardForm">
            <table width="100%" border="0">
              <tr>
                <td style="width:170px;">Credit card number</td>
              <tr>
              </tr>
                <td>
                    
                    <input name="creditNumber_1" type="text" maxlength="4" style="width:18%;" value="<?=htmlspecialchars(substr($user['paypal'][0]['lastNumbers'],0,4))?>" />
                    <input name="creditNumber_2" type="text" maxlength="4" style="width:19%;" value="<?=htmlspecialchars(substr($user['paypal'][0]['lastNumbers'],4,4))?>" />
                    <input name="creditNumber_3" type="text" maxlength="4" style="width:18%;" value="<?=htmlspecialchars(substr($user['paypal'][0]['lastNumbers'],8,4))?>" />
                    <input name="creditNumber_4" type="text" maxlength="4" style="width:19%;" value="<?=htmlspecialchars(substr($user['paypal'][0]['lastNumbers'],12,4))?>" />
                            </td>
              </tr>
            </table>
            <?php if($creditcardDisplay=='none'){ ?>
             <table width="100%">
              <tr>
                <td>
                <br>
					<p><button id="deleteCreditcard" type="button" style="width:296px; background-color:red;">Remove credit card</button></p>
                </td>
              </tr>
            </table>
			<?php } ?>
            <table width="100%" border="0" style="display:<?=$creditcardDisplay?>">
              <tr>
                <td>Credit card type</td>
              </tr>
              <tr>
                <td>
                    <select name="cardType">
                        <option value="mastercard">Mastercard</option>
                        <option value="visa">VISA</option>
                        <option value="discover">Discover</option>
                        <option value="amex">American Express</option>
                    </select>
                </td>
              </tr>
              <tr>
                <td>First name (as it appears on card)</td>
              <tr>
              </tr>
                <td><input type="text" autocomplete="off" name="cc_firstname" /></td>
              </tr>
              <tr>
                <td>Last name (as it appears on card)</td>
              <tr>
              </tr>
                <td><input type="text" autocomplete="off" name="cc_lastname" /></td>
              </tr>
              <tr>
                <td>Expiration date</td>
              <tr>
              </tr>
                <td>
                    <select name="expMonth">
                    <?php
                    $i=0;
                    while($i++<12){
                        echo '<option value="'.htmlspecialchars($i).'">'.htmlspecialchars($i).'</option>';
                    }
                    ?>
                    </select>
                    <select name="expYear">
                    <?php
                    $i=2013;
                    while($i++<2030){
                        echo '<option value="'.htmlspecialchars($i).'">'.htmlspecialchars($i).'</option>';
                    }
                    ?>
                    </select>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                    <br>
                    <p>
                      <button id="addCreditcard" type="button" style="width:100%">Validate credit card</button></p>
                </td>
              </tr>
            </table>
        </form>
        <a name="options"><h1>Deegin options</h1></a>
        <table width="100%" border="0">
        <tr>
        	<td>
                <span style="font-size:12px">All your payment details are saved securely using a PayPal PCI compliant server. <br><a href="https://www.paypal.com/cgi-bin/webscr?cmd=xpt/Help/general/TopQuestion6-outside" target="_blank">More info</a></span>
                <p>&nbsp;</p>
                <p>Redeem a coupon or discount code:<br />
                <input type="text" autocomplete="off" id="redeemACode" /></p>
                <p><a name="logout"></a></p>
                <a name="logout"><h1>Logout</h1></a>
                <span style="font-size:12px">Deegin keeps your browser automatically signed in. Click <a href="/logout" target="_self">here</a> if you wish to logout.</span>
                
               </td>
           </tr>
       </table>
    </div>
</body>
</html>