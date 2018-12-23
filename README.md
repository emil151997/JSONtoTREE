# JSONtoTREE
## Демонстрация работы
### Пример запроса
```
{"name": "Emil", "surname": "Minosyan", "Position": "Apparatchik"}
```
### Пример ответа
```
dict 
	* 
		\name
		: string \Emil
	* 
		\Position
		: string \Apparatchik
	* 
		\surname
		: string \Minosyan

```
## Как запустить сервер
1. Загрузите исходные файлы через git
```
git clone https://github.com/emil151997/JSONtoTREE.git
```
2. Поменяйте рабочий каталог на JSONtoTrEE
```
cd JSONtoTREE
```
3. Сгенерируйте образ для Docker через Gradle
```
./gradlew createImage
```
4. Запустите сервер с помощью команды:
```
docker run -p 8080:8080 emilserver
```
5. Подождите несколько минут пока загрузятся необходимые библиотеки и запустится сервер
6. Для остановки работы контейнера необходимо ввести команду 
```
docker container stop "номер id контейнера"
```
## Как проверить работоспособность сервера через утилиту Postman
1. Загрузите утилиту с официального сайта
2. Настройте на POST запрос
   1. Выберите метод POST 
   2. Введите в строке ```localhost:8080/```
   3. Выберите вкладку **Body**
   4. Поставьте галочку **raw**
   5. Измените content type на ```JSON(application/json)```
   6. Вставьте строку JSON
   7. Нажмите на кнопку **Send**