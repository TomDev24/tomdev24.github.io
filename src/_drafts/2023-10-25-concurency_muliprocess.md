---
layout: post
title:  "multiprocess"
categories: programming
lang: ru
ref: curl_postman
---

## Введение

Настало время разобраться в таких часто встречающихся терминах как "асинхронность", "параллельные вычисления", "мултизадачность" или
"concurrency" и "parallelism" на английском.

При этом, мы не остановимся на определениях в 2-3 предложения для каждого термина, а постараемся окунуться как можно глубже, вплоть
до операционных систем и железа.

## Одноядерные и многоядерные системы

Мы живем в прекрасное время, когда существуют ЦП с 18 ядрами, но такой роскоши пару десяток лет назад не существовало. Были только
одноядерные системы. Несколько ядер, могу выполнять полезные вычисления ПАРАЛЕЛЕЛЬНО! Другое дело, что не все задачи можно (или имеет смысл)
выполнять на нескольких ядрах. К тому же алгоритмы реализующие паралеллельные вычисления часто весьма не тривиальны.

Но у вас возможно возникал такой же вопрос как и у меня: "Как на старых одноядерных системах, можно было открывать несколько окон, одновременно
смотреть фильмы и сидеть в браузере?". ЭТУ ЗАДАЧУ РЕШАЛА OS, ФИЗИЧЕСКИЙ ТАЙМЕР, И ОБРАБОТЧИК ПРЕРЫВАНИЙ!

Кстати, настоящая параллельность была возможна даже в ту эпоху, когда все системы были одноядерными. Для этого, мы могли использовать
допольнительный компьютер, как дополнительное ядро. Чтобы выполнять какую нибудь задачу параллельно, нужно было чтоб эти пк могли 
общаться между собой. Такие вычисления называются распределенными. Можете побаловаться [BOINC](https://ru.wikipedia.org/wiki/BOINC), 
чтобы познакомиться поближе.

Most processors can use a process called simultaneous multithreading or, if it’s an Intel processor, Hyper-threading (the two terms mean the same thing)
to split a core into virtual cores, which are called threads. For example, AMD CPUs with four cores use simultaneous multithreading to provide eight threads,
and most Intel CPUs with two cores use Hyper-threading to provide four threads.

Some apps take better advantage of multiple threads than others. Lightly-threaded apps, like games, don't benefit from a lot of cores,
while most video editing and animation programs can run much faster with extra threads.


## "concurrency" и "parallelism",
Есть один нюанс в терминах "concurrency" и "parallelism", они оба переводятся как "параллельность". Но при этом, под "concurrency" часто 
подразумевают псевдо-параллельность, ну а под "parallelism" действительную параллельность, которую мы описывали выше (вычисления 
происходят на нескольких ядрах, или компьютерах одновременно)

Возникает вопрос: Что же такое псевдо-параллельность? Псевдо-параллельность означает, что некоторые вычисления/процессы происходят параллельно, но
не одновременно! Здесь уместным вопросом будет: Зачем вообще это нужно? И как это работает? 

* Зачем вообще это нужно?

Существуют операции, которые блокирует дальнейшее исполнение кода, при это есть ресурсы компьютера, которые не заняты в это время ничем 
полезным. Такими операциями являются операции Ввода/Вывода, и частным случаем здесь является интернет запросы. Когда мы делаем те же
самые HTTP запросы, нашему пк приходится ждать ответ от сервера, и в зависимости от соединения, ждать можно довольно долго. Псевдо-параллельность
позволяет в моменты таких запросов, переключиться на более полезные дела.

* И как это работает?

Это самый интересный вопрос. Существует не один механизм по реализации псевдо-паралельности. И именно здесь всплывают такие понятия
как асинхронность, потоки, green threads и прч.


## Параллельность в Erlang. Виртуальная машина Erlang.

Язык Erlang появился в 80ых годах. И уже тогда поддерживал псевдо-параллельность на одноядерных устройствах. Как же был
реализован механизм псевдо-параллельности на Erlang?

Дело в том, что для выполнения кода написанного на Erlang, необходима виртуальная машина, а это значит, что эта виртуальная машина
может использовать те же приемы, что и любая одноядерная мултизадачная система. 
(Each Erlang process would have its own slice of time to run, much like desktop applications did before multi-core systems.)

Когда начали появляться многоядерные системы, достачно было внести изменения в виртуальную машину (а не в сам язык), чтобы Erlang 
смог поддерживать настоящую параллельность (true symmetric multiprocessing). 

Механизм псевдо-параллельности Erlang отличается от Асинхронного программирования.


