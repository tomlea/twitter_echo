$(function()
{
	TwitterEcho.initDifferentAccountLink();
});

var TwitterEcho = {};

TwitterEcho.initDifferentAccountLink = function()
{
	$("#another_account")
		.hide()
		.before(

			$("<a/>")
				.append("use a different account?")
				.attr("href", "#")
				.click(function()
				{
					$("#another_account").slideToggle();
					return false;
				})

		);
}
