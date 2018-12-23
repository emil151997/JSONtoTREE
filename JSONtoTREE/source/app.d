	import vibe.vibe;
	import std.stdio;
	import jin.tree;
void main()
{
	listenHTTP(":8080", &handleRequest);
	runApplication();
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
	Json str = req.json;
    Tree myTree = Tree.fromJSON(str.toString());
    res.writeBody(myTree.toString());
}
