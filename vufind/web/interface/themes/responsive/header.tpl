{strip}
<div class="navbar navbar-static-top">
	<div class="navbar-inner">
		<div class="container">
			<div>
				<a class="brand" href="{if $homeLink}{$homeLink}{else}{$path}/{/if}">
					<img class="brand" src="{if $tinyLogo}{$tinyLogo}{else}{img filename="logo_tiny.png"}{/if}" alt="{$librarySystemName}" title="Return to Catalog Home" id="header_logo"/>
				</a>
				<div class="pull-right">
					<ul class="nav">
						<li class="">
							<a href="{if $homeLink}{$homeLink}{else}{$path}/{/if}">Home</a>
						</li>
						<li class="logoutOptions" {if !$user} style="display: none;"{/if}>
							<a href="{$path}/MyResearch/Home">{translate text="Your Account"}</a>
						</li>
						<li class="logoutOptions" {if !$user} style="display: none;"{/if}>
							<a href="{$path}/MyResearch/Logout" id="logoutLink" >{translate text="Log Out"}</a>
						</li>
						<li class="loginOptions" {if $user} style="display: none;"{/if}>
							{if $showLoginButton == 1}
								<a id="headerLoginLink" href="{$path}/MyResearch/Home" class='loginLink'>{translate text="Login"}</a>
							{/if}
						</li>
						{if is_array($allLangs) && count($allLangs) > 1}
							<li id="language_toggle" class="dropdown-toggle" data-toggle="dropdown">
								{foreach from=$allLangs key=langCode item=langName}
									{if $userLang == $langCode}
										<a href="#">{translate text=$langName} <span class="caret"></span></a>
									{/if}
								{/foreach}

							</li>
							<ul class="dropdown-menu">
								{foreach from=$allLangs key=langCode item=langName}
									<li><a id="lang{$langCode}" class='languageLink {if $userLang == $langCode} selected{/if}' href="{$fullPath}{if $requestHasParams}&amp;{else}?{/if}mylang={$langCode}">{translate text=$langName}</a></li>
								{/foreach}
							</ul>
						{/if}
					</ul>
				</div>
			</div>
		</div>

	</div>
</div>
{/strip}