{strip}
<div class="">
	<a href="#" id="userreviewlink{$shortId}" class="userreviewlink resultAction" onclick="return showReviewForm('{$shortId}', 'VuFind')">
		<span class="silk comment_add">&nbsp;</span>Add a Review
	</a>
</div>
<div id="userreview{$shortId}" class="userreview hidden">
  <span class ="alignright unavailable closeReview" onclick="$('#userreview{$shortId}').slideUp();" >Close</span>
	<div class='addReviewTitle'>Add your Review</div>
  
  {include file="Record/submit-comments.tpl"}
</div>
{/strip}