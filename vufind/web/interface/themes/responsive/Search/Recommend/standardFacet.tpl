{if $cluster.showMoreFacetPopup}
	{foreach from=$cluster.list item=thisFacet name="narrowLoop"}
		{if $thisFacet.isApplied}
			<div class="facetValue">{$thisFacet.display|escape} <img src="{$path}/images/silk/tick.png" alt="Selected" /> <a href="{$thisFacet.removalUrl|escape}" class="removeFacetLink" onclick="trackEvent('Remove Facet', '{$cluster.label}', '{$thisFacet.display|escape}');">(remove)</a></div>
		{else}
			<div class="facetValue">{if $thisFacet.url !=null}<a href="{$thisFacet.url|escape}">{/if}{$thisFacet.display|escape}{if $thisFacet.url !=null}</a>{/if}{if $thisFacet.count != ''}&nbsp;({$thisFacet.count}){/if}</div>
		{/if}
	{/foreach}
{* Show more list *}
	<div class="facetValue" id="more{$title}"><a href="#" onclick="moreFacetPopup('More {$cluster.label}s', '{$title}'); return false;">{translate text='more'} ...</a></div>
<div id="moreFacetPopup_{$title}" style="display:none">
	<p>Please select one of the items below to narrow your search by {$cluster.label}.</p>
	{foreach from=$cluster.sortedList item=thisFacet name="narrowLoop"}
		{if $smarty.foreach.narrowLoop.iteration % ($smarty.foreach.narrowLoop.total / 5) == 1}
			{if !$smarty.foreach.narrowLoop.first}
				</ul></div>
			{/if}
			<div class="facetCol"><ul>
		{/if}
		<li class="facetValue">{if $thisFacet.url !=null}<a href="{$thisFacet.url|escape}">{/if}{$thisFacet.display|escape}{if $thisFacet.url !=null}</a>{/if}{if $thisFacet.count != ''}&nbsp;({$thisFacet.count}){/if}</li>
		{if $smarty.foreach.narrowLoop.last}
			</ul></div>
		{/if}
	{/foreach}

	</div>
{else}
	{foreach from=$cluster.list item=thisFacet name="narrowLoop"}
		{if $smarty.foreach.narrowLoop.iteration == ($cluster.valuesToShow + 1)}
		{* Show More link*}
			<div class="facetValue" id="more{$title}"><a href="#" onclick="moreFacets('{$title}'); return false;">{translate text='more'} ...</a></div>
		{* Start div for hidden content*}
			<div class="narrowGroupHidden" id="narrowGroupHidden_{$title}">
		{/if}
		{if $thisFacet.isApplied}
			<div class="facetValue">{$thisFacet.display|escape} <img src="{$path}/images/silk/tick.png" alt="Selected" /> <a href="{$thisFacet.removalUrl|escape}" class="removeFacetLink" onclick="trackEvent('Remove Facet', '{$cluster.label}', '{$thisFacet.display|escape}');">(remove)</a></div>
		{else}
			<div class="facetValue">{if $thisFacet.url !=null}<a href="{$thisFacet.url|escape}">{/if}{$thisFacet.display|escape}{if $thisFacet.url !=null}</a>{/if}{if $thisFacet.count != ''}&nbsp;({$thisFacet.count}){/if}</div>
		{/if}
	{/foreach}
	{if $smarty.foreach.narrowLoop.total > $cluster.valuesToShow}
		<div class="facetValue"><a href="#" onclick="lessFacets('{$title}'); return false;">{translate text='less'} ...</a></div>
		</div>
	{/if}
{/if}