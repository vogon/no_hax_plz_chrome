/*
 * rewrite all links in the document with the x-no-hax attribute
 * present.
 */
function rewriteNoHaxLinks()
{
	for (i = 0; i < document.links.length; i++)
	{
		var elt = document.links[i];

		if (elt.getAttribute('x-no-hax') != null)
		{
			console.warn("no-hax link '" + elt + "' detected");
			rewriteNoHaxElement(elt);
		}
	}
}

/*
 * rewrites a single <a x-no-hax="1"> element to have an onclick
 * handler which dispatches an incognito load and suppresses the
 * default navigation.
 */
function rewriteNoHaxElement(elt)
{
	elt.onclick = 
		function() {
			console.warn("dispatching no-hax load to " + url);
			chrome.extension.sendRequest(url);

			return false;
		}
}

console.warn("in onload handler");
rewriteNoHaxLinks();
