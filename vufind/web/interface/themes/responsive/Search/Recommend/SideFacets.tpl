{strip}
{if $recordCount > 0 || $filterList || ($sideFacetSet && $recordCount > 0)}
	<div class="sidegroup well">
		<h4>{translate text='Narrow Search'}</h4>
		{if isset($checkboxFilters) && count($checkboxFilters) > 0}
			<p>
				{include file='checkboxFilters.tpl'}
			</p>
		{/if}
		{* Filters that have been applied *}
		{if $filterList}
			<strong>{translate text='Remove Filters'}</strong>
			<ul class="filters">
			{foreach from=$filterList item=filters key=field }
				{foreach from=$filters item=filter}
					<li>{translate text=$field}: {$filter.display|translate|escape} <a href="{$filter.removalUrl|escape}" onclick="trackEvent('Remove Facet', '{$field}', '{$filter.display|escape}');"><img src="{$path}/images/silk/delete.png" alt="Delete"/></a></li>
				{/foreach}
			{/foreach}
			</ul>
		{/if}

		{* Available filters *}
		{if $sideFacetSet && $recordCount > 0}
			{foreach from=$sideFacetSet item=cluster key=title name=facetSet}
				{if count($cluster.list) > 0}
				<div class="facetList">
					<h5 class="facetTitle {if $cluster.collapseByDefault}collapsed{else}expanded{/if}" onclick="$(this).toggleClass('expanded');$(this).toggleClass('collapsed');$('#facetDetails_{$title}').toggle()">
						{translate text=$cluster.label}
					</h5>
					<div id="facetDetails_{$title}" class="facetDetails" {if $cluster.collapseByDefault}style="display:none"{/if}>

						{if $title == 'publishDate' || $title == 'birthYear' || $title == 'deathYear'}
							{include file="Search/Recommend/yearFacetFilter.tpl" cluster=$cluster title=$title name=$name}
						{elseif $title == 'rating_facet'}
							{include file="Search/Recommend/ratingFacet.tpl" cluster=$cluster title=$title name=$name}
						{elseif $title == 'lexile_score' || $title == 'accelerated_reader_reading_level' || $title == 'accelerated_reader_point_value'}
							{include file="Search/Recommend/sliderFacet.tpl" cluster=$cluster title=$title name=$name}
						{elseif $cluster.showAsDropDown}
							{include file="Search/Recommend/dropDownFacet.tpl" cluster=$cluster title=$title name=$name}
						{else}
							{include file="Search/Recommend/standardFacet.tpl" cluster=$cluster title=$title name=$name}

						{/if}
					</div>
				</div>

				{* Add a line between facets for clarity*}
				{if !$smarty.foreach.facetSet.last}
				<hr class="facetSeparator"/>
				{/if}
				{/if}
			{/foreach}
		{/if}
	</div>
{/if}
{/strip}