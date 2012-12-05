{* Your footer *}
<div class="footerCol"><p><strong>{translate text='Featured Items'}</strong></p>
	<ul>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_steamboatlibrary%3A%22Month%22&amp;filter[]=literary_form_full%3A%22Fiction%22&amp;filter[]=institution%3A%22Steamboat+Springs+Community+Libraries%22&amp;filter[]=format_category%3A%22Books%22'>{translate text='New Fiction'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_steamboatlibrary%3A%22Month%22&amp;filter[]=literary_form_full%3A%22Non+Fiction%22&amp;filter[]=institution%3A%22Steamboat+Springs+Community+Libraries%22&amp;filter[]=format_category%3A%22Books%22 '>{translate text='New Non-Fiction'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=local_time_since_added_steamboatlibrary%3A%22Month%22&amp;filter[]=format%3A%22DVD%22&amp;filter[]=institution%3A%22Steamboat+Springs+Community+Libraries%22'>{translate text='New DVDs'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=institution%3A%22Steamboat+Springs+Community+Libraries%22&amp;filter[]=format%3A%22Blu-ray%22&amp;filter[]=local_time_since_added_steamboatlibrary%3A%22Month%22'>{translate text='New Bluray'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;type=Keyword&amp;filter[]=institution%3A%22Steamboat+Springs+Community+Libraries%22&amp;filter[]=format_category%3A%22Audio%22&amp;filter[]=local_time_since_added_steamboatlibrary%3A%22Month%22 '>{translate text='New Audio Books &amp; Music'}</a></li>
		<li><a href='{$path}/Search/Results?lookfor=&amp;amp;type=Keyword&amp;filter[]=local_time_since_added_steamboatlibrary%3A"Week"'>{translate text='New This Week'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='About Us'}</strong></p>
	<ul>
		<li><a href="http://www.steamboatlibrary.org/about-us/board-of-trustees-0">{translate text='Board of Trustees'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/about-us/history">{translate text='History'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/about-us/building">{translate text='Building'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/about-us/mission">{translate text='Mission'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/about-us/policies">{translate text='Policies'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/about-us/jobs">{translate text='Jobs'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Find Us'}</strong></p>
	<ul>
		<li><a href="http://www.steamboatlibrary.org/find-us/hours">{translate text='Hours'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/find-us/hours/driving-directions">{translate text='Driving Directions'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/find-us/hours/driving-directions/book-drop-locations">{translate text='Book Drop Locations'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/downloads/mobile-app">{translate text='Mobile App'}</a></li>
	</ul>
</div>
<div class="footerCol"><p><strong>{translate text='Support Us'}</strong></p>
	<ul>
		<li><a href="http://www.steamboatlibrary.org/support-us/book-donations">{translate text='Book Donations'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/support-us/volunteer">{translate text='Volunteer'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/support-us/donate">{translate text='Donate'}</a></li>
		<li><a href="http://www.steamboatlibrary.org/support-us/thanks-to">{translate text='Thanks To'}</a></li>
	</ul>
</div>
<br class="clearer"/>
{if !$productionServer}
<div class='location_info'>{$physicalLocation}</div>
{/if}
