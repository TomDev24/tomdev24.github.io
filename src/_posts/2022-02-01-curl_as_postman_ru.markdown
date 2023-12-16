---
layout: post
title:  "'Postman не нужен, родной' или используем cURL для API запросов"
categories: programming
lang: ru
ref: curl_postman
---

Давайте рассмотрим, как с помощью cURL можно делать `GET, POST, PUT, PATCH, and DELETE` http запросы.
Для примеров будем использовать [jsonplaceholder](https://jsonplaceholder.typicode.com)

### Флаги cURL

* -X --request - Метод запроса
* -d --data - Отправить определенные данные
* -H --header - Заголовок HTTP запроса
* -i --include - Отобразить заголовки ответа

### GET

Get запросы довольно тривиальны. Следущие два запроса совершенно индентичны: 

```bash
$ curl https://jsonplaceholder.typicode.com/posts
$ curl -X GET https://jsonplaceholder.typicode.com/posts
```

### POST

С помощью флага -X указываем POST запрос, а флаг -d указывает данные. Мы можем отправлять данные как закадированные в url(первый пример),
так и json данные(второй пример).

```bash
$ curl -X POST -d "userId=5&title=Stuff and Things&body=An amazing blog post about both stuff and things." https://jsonplaceholder.typicode.com/posts
```

```bash
$ curl -X POST -H "Content-Type: application/json" -d '{"userId": 5, "title": "Stuff and Things", "body": "An amazing blog post about both stuff and things."}'
https://jsonplaceholder.typicode.com/posts
```

Как видим для JSON запросов нужно указывать заголовок с помощью флага -H.

### PUT

Как мы помним, PUT позволяет нам обновлять запись, при это нам всегда нужно указывать запись целиком в теле, а не определенное ее поле.

```bash
$ curl -X PUT -d "userId=1&title=Something else&body=A new body" https://jsonplaceholder.typicode.com/posts/1
```

```bash
$ curl -X PUT -H "Content-Type: application/json" -d '{"userId": 1, "title": "Something else", "body": "A new body"}' https://jsonplaceholder.typicode.com/posts/1
```

### PATCH

В отличие от PUT, PATCH не требует от нас указывать всю запись целиком, а лишь то поле, которое мы хотим изменить

```bash
$ curl -X PATCH -d "title='Only change the title'" https://jsonplaceholder.typicode.com/posts/1
```

```bash
$ curl -X PATCH -H "Content-Type: application/json" -d '{"title": "Only change the title"}' https://jsonplaceholder.typicode.com/posts/1
```

### DELETE

```bash
$ curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

### Aутентификация

В зависимости от метода авторизации в API, мы можем указывать данные аутентификации в заголовке:

```bash
$ curl \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -H "x-jwt-assertion: <JWT_TOKEN>" \
  -X POST \
  -d  '{"key1" : "value1", "key2" : "value2"}' \
  https://example.com/
```

### Vim, как окружение для тестирования API

Что самое прекрасное в cURL запросах, так это то что мы можем легко их поместить в текстовый файл:
```
//req.txt пример текстового файла с запросами
curl https://jsonplaceholder.typicode.com/posts
curl https://jsonplaceholder.typicode.com/users
curl https://jsonplaceholder.typicode.com/posts/1

curl \
    -X PUT \
    -H "Content-Type: application/json" -d \
    '{"userId": 1, "title": "Something else", "body": "A new body"}' https://jsonplaceholder.typicode.com/posts/1

```

И уже в vim наводя курсор на нужный запроc, выполнять его `:.w !bash`. И даже выводить результат в другое окно vim `:.w !bash | vi -`  
Ну и вишенка на торте: можно выполнять запросы, которые занимают несколько строк, для этого нужно выделить эти строки в Visual Mode и затем выполнить
```
:'<,'>w !bash
```

Ну и конечно, ничто не мешает нам открыть этот файл в том же Python, и по каждой строчке делать запрос, и далее обрабатывать результат и возможно 
сравнивать его с чем то.

### Как редактивировать cURL запросы прямо в терминале

В Linux есть полезная команда `fc`, позволяющая редактивировать последнюю выполненную команду. При этом, редактивироваться сообщение будет в редакторе по
умолчанию, указанный в .bashrc `export EDITOR=nvim`

```bash
$ fc
```

При закрытие нашего редактора, команда будет автоматически выполнена.

Если мы не хотим выполнять команду/запрос сразу, а вначале его отредактвировать. То мы можем перейти в начало ввода команды `ctrl+a` и поставить `#`, что
сделает нашу команду коментарием. Ну и после соотвестенно мы можем выполнить `fc` и отредактивировать команду.

### Заключение

Postman часто используют для автоматизации тестирования API. Но как мы видим, возможность делать запросы через cURL и возможность сохранения запросов
в текстовых файлах (которые можно легко выполнить в vim, или python/bash скрипте), позволяют нам гибко настраивать систему тестирования, без необходимости
открывать требовательное приложение Postman, которое на минуточку написано на Electron, со всеми вытекающими отсюда последствиями.

### Источники

* https://github.com/curl/curl/blob/master/docs/MANUAL.md
* https://man7.org/linux/man-pages/man1/curl.1.html
* https://dev.to/zaerald/using-vim-as-your-shell-command-line-scratch-1lcl
