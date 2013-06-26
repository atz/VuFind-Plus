{strip}
{* Show hold/checkout button as appropriate *}
{if $showHoldButton}
	{if $eContentRecord->isOverDrive()}
		{* Place hold link *}
		<div class='requestThisLink resultAction' id="placeEcontentHold{$summId|escape:"url"}" style="display:none">
			<a href="#" class="button" onclick="return placeOverDriveHold('{$eContentRecord->externalId}')">{translate text="Place Hold"}</a>
		</div>

		{* Checkout link *}
		<div class='checkoutLink resultAction' id="checkout{$summId|escape:"url"}" style="display:none">
			<a href="#" class="button" onclick="return {if overDriveVersion==1}checkoutOverDriveItem{else}checkoutOverDriveItemOneClick{/if}('{$eContentRecord->externalId}')">{translate text="Checkout"}</a>
		</div>
	{else}
		{* Place hold link *}
		<div class='requestThisLink resultAction' id="placeEcontentHold{$summId|escape:"url"}" style="display:none">
			<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/Hold" class="button">{translate text="Place Hold"}</a>
		</div>

		{* Checkout link *}
		<div class='checkoutLink resultAction' id="checkout{$summId|escape:"url"}" style="display:none">
			<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/Checkout" class="button">{translate text="Checkout"}</a>
		</div>
	{/if}

	{* Access online link *}
	<div class='accessOnlineLink' id="accessOnline{$summId|escape:"url"}" style="display:none">
		<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/Home?detail=holdingstab" class="button">{translate text="Access Online"}</a>
	</div>
	{* Add to Wish List *}
	<div class='addToWishListLink' id="addToWishList{$summId|escape:"url"}" style="display:none">
		<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/AddToWishList" class="button">{translate text="Add to Wishlist"}</a>
	</div>
{/if}
{if $showMoreInfo !== false}
<div class="resultAction"><a href="{$recordUrl}"><span class="silk information">&nbsp;</span>More Info</a></div>
{/if}
{*
<div class="resultAction"><a href="#" class="cart" onclick="return addToBag('{$id|escape}', '{$summTitle|replace:'"':''|escape:'javascript'}', 'EcontentRecord{$summId|escape:"url"}');"><span class="silk cart">&nbsp;</span>{translate text="Add to cart"}</a></div>
*}
<div class="resultAction"><a href="{$path}/EcontentRecord/{$summId|escape:"url"}/SimilarTitles"><img src="/images/silk/arrow_switch.png">&nbsp;</span>More Like This</a></div>
{if $showComments == 1}
	{assign var=id value=$summId scope="global"}
	{include file="EcontentRecord/title-review.tpl" id=$summId}
{/if}
{if $showFavorites == 1}
	<div id="saveLink{$recordId|escape}" class="resultAction">
		<a href="{$path}/Resource/Save?id={$summId|escape:"url"}&amp;source=eContent" onclick="getSaveToListForm('{$summId|escape}', 'eContent');return false;"><span class="silk star_gold">&nbsp;</span>{translate text='Add to favorites'}</a>
		{if $user}
			<script type="text/javascript">
				getSaveStatuses('{$recordId|escape:"javascript"}');
			</script>
		{/if}
	</div>
{/if}
{if $showTextThis == 1}
	<li><a href="{$path}/EcontentRecord/{$id|escape:"url"}/SMS" id="smsLink" onclick="ajaxLightbox('{$path}/EcontentRecord/{$id|escape}/SMS?lightbox', '#citeLink'); return false;"><span class="silk phone">&nbsp;</span>{translate text="Text this"}</a></li>
{/if}
{if $showEmailThis == 1}
	<li><a href="{$path}/EcontentRecord/{$id|escape:"url"}/Email" id="mailLink" onclick="ajaxLightbox('{$path}/EcontentRecord/{$id|escape}/Email?lightbox', '#citeLink'); return false;"><span class="silk email">&nbsp;</span>{translate text="Email this"}</a></li>
{/if}
{/strip}