/**
	@file app.d
    @brief Данная программа запускает веб сервер, и при получении POST-запроса в виде JSON, преобразует его в Tree
*/
	import vibe.vibe;
	import std.stdio;
	import jin.tree;
	/**
 * @brief Точка входа в программу
 *
 * 	listenHTTP(":8080", &handleRequest) - запускает веб-сервер на порту 8080, все запросы обрабатываются функцией handleRequest
 *	Something @n runApplication() - Выполняет окончательную инициализацию и запускает цикл обработки событий
 */
void main()
{
	listenHTTP(":8080", &handleRequest);
	runApplication();
}
	/**
 * @brief Функция обработки запроса
 *
 * 	Tree.fromJSON - функция преобразования из JSON в Tree
 *	Something @n res.writeBody - функция записи содержимого тела
 */
 
void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
	Json str = req.json;
    Tree myTree = Tree.fromJSON(str.toString());
    res.writeBody(myTree.toString());
}
