{* Add Google Analytics*}
{literal}
<script type="text/javascript">
	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', '{/literal}{if $googleAnalyticsId}{$googleAnalyticsId}{else}UA-10641564-2{/if}{literal}']);
	_gaq.push(['_setCustomVar', 1, 'theme', {/literal}'{$primaryTheme}'{literal}, '2']);
	_gaq.push(['_setCustomVar', 2, 'mobile', {/literal}'{$iMobile}'{literal}, '2']);
	_gaq.push(['_setCustomVar', 3, 'physicalLocation', {/literal}'{$physicalLocation}'{literal}, '2']);
	_gaq.push(['_setCustomVar', 4, 'pType', {/literal}'{$pType}'{literal}, '2']);
	_gaq.push(['_setCustomVar', 5, 'homeLibrary', {/literal}'{$homeLibrary}'{literal}, '2']);
	_gaq.push(['_setDomainName', '.marmot.org']);
	_gaq.push(['_trackPageview']);
	_gaq.push(['_trackPageLoadTime']);
		
	(function() {
		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	})();

</script>
{/literal}
