{strip}
<a rel="external" href="{$path}/MyResearch/MyList/{$summShortId}">
<div class="result list" id="record{$summId|escape}">
	<h3 class="recordTitle">
		{if !$summTitle}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{/if}
		{if $summTitleStatement}
			<div class="searchResultSectionInfo">
				{$summTitleStatement|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}
			</div>
		{/if}
	</h3>

	<p class="description">
		{if $summDescription}
			<strong>{translate text='Description'}:</strong> {$summDescription|truncate:500:"..."|highlight:$lookfor}
		{/if}
	</p>

	<p class="numTitles">
		{if $summNumTitles}
			<strong>{translate text='Size'}:</strong> {$summNumTitles} titles are in this list.
		{/if}
	</p>

	<div class="clearer"></div>
</div>
</a>
{/strip}