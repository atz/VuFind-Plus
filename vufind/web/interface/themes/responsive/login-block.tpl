<div id="loginBlock">
	<div id="logoutOptions" class="logoutOptions" {if !$user} style="display: none;"{/if}>
		<a href="{$path}/MyResearch/Home" id="myAccountNameLink">{$user->firstname|capitalize} {$user->lastname|capitalize}</a> | <a href="{$path}/MyResearch/Home">{translate text="Your Account"}</a> | <a href="{$path}/MyResearch/Logout" id="logoutLink" >{translate
			text="Log Out"}</a>
	</div>
	<div id="loginOptions" class="loginOptions" {if $user} style="display: none;"{/if}>
		{if $authMethod == 'Shibboleth'}
			<a href="{$sessionInitiator}">{translate text="Institutional Login"}</a>
		{elseif $showLoginButton == 1}
			<a id="headerLoginLink" href="{$path}/MyResearch/Home" class='loginLink'>{translate text="login_link"}</a>
		{/if}
	</div>
	{if is_array($allLangs) && count($allLangs) > 1}
		<br />
		{foreach from=$allLangs key=langCode item=langName}
			<a id="lang{$langCode}" class='languageLink {if $userLang == $langCode} selected{/if}' href="{$fullPath}{if $requestHasParams}&amp;{else}?{/if}mylang={$langCode}">{translate text=$langName}</a>
		{/foreach}
	{/if}
</div>
