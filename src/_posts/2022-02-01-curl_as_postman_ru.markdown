---
layout: post
title:  "'Postman не нужен, родной' или используем cURL для API запросов"
categories: programming
lang: ru
ref: curl_postman
---

Давайте рассмотрим, как с помощью cURL можно делать `GET, POST, PUT, PATCH, and DELETE` http запросы.
Для примеров будем использовать [jsonplaceholder](https://jsonplaceholder.typicode.com/posts)

### Флаги c

* -X --request - Custom request method
* -d --data - Sends the specified data
* -H --header - Sends headers
* -i --include - Display response headers

### GET

```bash
$ curl https://jsonplaceholder.typicode.com/posts
```

### POST

```bash
$ curl -X POST -d "userId=5&title=Stuff and Things&body=An amazing blog post about both stuff and things." https://jsonplaceholder.typicode.com/posts
```
urlencoded

```bash
$ curl -X POST -H "Content-Type: application/json" -d '{"userId": 5, "title": "Stuff and Things", "body": "An amazing blog post about both stuff and things."}'
https://jsonplaceholder.typicode.com/posts
```
json


### PUT


### PATCH


### DELETE

### Authentication

### Sources

### Let there be vim

```bash
$ fc
```
export EDITOR=nvim

Using Vim As Your Shell Command-Line Scratch

 In that case, what we can do is press ctrl + a to move the cursor before the first character in your command line and type pound (#),
 this results into making the command as a comment.

 :%norm A \
  - ':%norm' perform a normal command for the whole buffer
  - 'A' go to insert mode to the end of the line
  - ' \' add literal space and backslash

  How to solve this? You need to use :cq to exit vim with error code. You can add a key bind for this, or you can just delete the content of your vim buffer with dd and exit.

echo hello | nvim -

jq utility https://stedolan.github.io/jq/

:w !bash

We can also pick which line to execute.

:.w !zsh

Notice the dot(.) before w, this means “write the current line of the cursor to the shell”.

SHLVL

https://www.taniarascia.com/making-api-requests-postman-curl/

We can improve our workflow by adding intellisense using the Language Server Protocol (LSP).

* https://github.com/curl/curl/blob/master/docs/MANUAL.md
* https://man7.org/linux/man-pages/man1/curl.1.html
* https://dev.to/zaerald/using-vim-as-your-shell-command-line-scratch-1lcl
