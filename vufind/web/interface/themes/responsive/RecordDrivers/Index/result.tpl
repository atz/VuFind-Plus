{strip}
<div id="record{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultsList row-fluid">
	<div class="span1">
		<div class="selectTitle">
			<label for="selected[{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}]" class="resultIndex checkbox">{$resultIndex}
				<input type="checkbox" class="titleSelect" name="selected[{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}]" id="selected{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" {if $enableBookCart}onclick="toggleInBag('{$summId|escape}', '{$summTitle|replace:'"':''|replace:'&':'and'|escape:'javascript'}', this);"{/if} />&nbsp;
			</label>
		</div>
	</div>

	<div class="imageColumn span2 text-center">
		{if $user->disableCoverArt != 1}
			<div id='descriptionPlaceholder{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}' style='display:none' class='descriptionTooltip'></div>
			<a href="{$summUrl}" id="descriptionTrigger{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
				<img src="{$bookCoverUrl}" class="listResultImage img-polaroid" alt="{translate text='Cover Image'}"/>
			</a>
		{/if}
		{include file="Record/title-rating.tpl" ratingClass="" recordId=$summId shortId=$summShortId ratingData=$summRating}
	</div>

	<div class="resultDetails span6">
		<div class="resultItemLine1">
			{if $summScore}({$summScore}) {/if}
			<a href="{$summUrl}" class="title">{if !$summTitle|removeTrailingPunctuation}{translate text='Title not available'}{else}{$summTitle|removeTrailingPunctuation|truncate:180:"..."|highlight:$lookfor}{/if}</a>
			{if $summTitleStatement}
				<div class="searchResultSectionInfo">
					{$summTitleStatement|removeTrailingPunctuation|truncate:180:"..."|highlight:$lookfor}
				</div>
			{/if}
		</div>

		{if $summISBN}
		<div class="resultSeries">
			<div class="series{$summISBN}"></div>
		</div>
		{/if}

		<div class="resultItemLine2">
			{if $summAuthor}
				{translate text='by'}&nbsp;
				{if is_array($summAuthor)}
					{foreach from=$summAuthor item=author}
						<a href="{$path}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
					{/foreach}
				{else}
					<a href="{$path}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
				{/if}
				&nbsp;
			{/if}

			{if $summDate}{translate text='Published'} {$summDate.0|escape}{/if}
		</div>

		<div class="resultItemLine3">
			{if !empty($summSnippetCaption)}<b>{translate text=$summSnippetCaption}:</b>{/if}
			{if !empty($summSnippet)}<span class="quotestart">&#8220;</span>...{$summSnippet|highlight}...<span class="quoteend">&#8221;</span><br />{/if}
		</div>

		<div class="resultItemLine4">
			{if is_array($summFormats)}
				{foreach from=$summFormats item=format}
					<span class="iconlabel" >{translate text=$format}</span>&nbsp;
				{/foreach}
			{else}
				<span class="iconlabel">{translate text=$summFormats}</span>
			{/if}
		</div>

		<div id = "holdingsSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="holdingsSummary">
			<div class="statusSummary" id="statusSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
				<span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
			</div>
		</div>
	</div>

	<div class="resultActions span2">
		{include file='Record/result-tools.tpl' id=$summId shortId=$shortId summTitle=$summTitle ratingData=$summRating recordUrl=$summUrl}

	</div>

	<script type="text/javascript">
		VuFind.Holdings.addIdToStatusList('{$summId|escape}', 'VuFind', '{$useUnscopedHoldingsSummary}');
		{if $summISBN}
		getSeriesInfo('{$summISBN}');
		{/if}
		$(document).ready(function(){literal} { {/literal}
			resultDescription('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}','{$summId}','VuFind');
		{literal} }); {/literal}
	</script>
</div>
{/strip}