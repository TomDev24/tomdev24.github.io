---
layout: post
title:  "Python async and threads"
categories: programming
lang: ru
ref: curl_postman
---

In computer programming, a runtime library is a set of low-level routines used by a compiler to invoke some of the behaviors of a runtime environment, by inserting calls to the runtime library into compiled executable binary. The runtime environment implements the execution model, built-in functions, and other fundamental behaviors of a programming language.[1] During execution (run time) of that computer program, execution of those calls to the runtime library cause communication between the executable binary and the runtime environment. A runtime library often includes built-in functions for memory management or exception handling.[2] Therefore, a runtime library is always specific to the platform and compiler.

The runtime library may implement a portion of the runtime environment's behavior, but if one reads the code of the calls available, they are typically only thin wrappers that simply package information, and send it to the runtime environment or operating system. However, sometimes the term runtime library is meant to include the code of the runtime environment itself, even though much of that code cannot be directly reached via a library call. 

The concept of a runtime library should not be confused with an ordinary program library like that created by an application programmer or delivered by a third party, nor with a dynamic library, meaning a program library linked at run time. For example, the C programming language requires only a minimal runtime library (commonly called crt0), but defines a large standard library (called C standard library) that has to be provided by each implementation.[1]



Runtime describes software/instructions that are executed while your program is running, especially those instructions that you did not write explicitly, but are necessary for the proper execution of your code.

Low-level languages like C have very small (if any) runtime. More complex languages like Objective-C, which allows for dynamic message passing, have a much more extensive runtime.

You are correct that runtime code is library code, but library code is a more general term, describing the code produced by any library. Runtime code is specifically the code required to implement the features of the language itself.


 Go does have an extensive library, called the runtime, that is part of every Go program. The runtime library implements garbage collection, concurrency, stack management, and other critical features of the Go language. Although it is more central to the language, Go's runtime is analogous to libc, the C library.

It is important to understand, however, that Go's runtime does not include a virtual machine, such as is provided by the Java runtime. Go programs are compiled ahead of time to native machine code (or JavaScript or WebAssembly, for some variant implementations). Thus, although the term is often used to describe the virtual environment in which a program runs, in Go the word “runtime” is just the name given to the library providing critical language services. 

There are a lot of differences, and for the answer to be complete, you would need to specify which language you wanted to compare it to. But on a really simple level, thwd's answer is more or less correct. A VM language is usually compiled into an instruction set for that VM. The VM then provides a lot of "special sauce." Go is (usually) compiled directly into machine code to be executed directly on the target system.

One consequence of this is that the executable can be run without having any other software installed on the machine. It also  means that the code for the stuff you inquired about such as the garbage collector, goroutine scheduling and stack management, is all present in the single executable compiled by go.

IMHO although the runtime and VM both provide facilities such as garbage collection, scheduling ect they are not alike at all. Actually that is the ONLY way they are alike. VM run compiled bytcode like others stated, but the VM is a whole program on its own, which is run, and handled by the os like a compiled-to-machine code program would be, and then that (VM) program reads and runs the bytecode compiled program.

Whereas instead of being a seperate program in it's own right, Go's runtime is actually just a set of libraries that are compiled into every Go binary. Just like the std libraries that you import into your program (ie "fmt") they are compiled and linked along with user code into a single program. In fact, you can also import these libraries into your code manually and play with it; with a VM you don't have the same ability. (*some VMs can be 'tuned', but only from knobs that are specifically givin to you, not arbitrarily)

The end result is that you get all the facilities for managing memory, goroutine schedualing, ect that you want from a virtual machine, but interwoven into your code, which as a whole is then compiled down to raw machine code.

If you want to learn more about how this is all implemented, I find that the go source is extremely approchable, and even a beginner should be able to get some idea about what the code is doing. ("$GOROOT/src/runtime is a good starting place)


In computer programming, a green thread (virtual thread) is a thread that is scheduled by a runtime library or virtual machine (VM) instead of natively by the underlying operating system (OS). Green threads emulate multithreaded environments without relying on any native OS abilities, and they are managed in user space instead of kernel space, enabling them to work in environments that do not have native thread support.[1]


### Python

Python internals:
https://leanpub.com/insidethepythonvirtualmachine/read
https://www.youtube.com/watch?v=XGF3Qu4dUqk
https://github.com/python/cpython/tree/main

### Stackless Python

Stackless Python, or Stackless, is a Python programming language interpreter, so named because it avoids depending on the C call stack for its own stack. In practice, Stackless Python uses the C stack, but the stack is cleared between function calls.[2] The most prominent feature of Stackless is microthreads, which avoid much of the overhead associated with usual operating system threads. In addition to Python features, Stackless also adds support for coroutines, communication channels, and task serialization. 

With Stackless Python, a running program is split into microthreads that are managed by the language interpreter itself, not the operating system kernel—context switching and task scheduling is done purely in the interpreter (these are thus also regarded as a form of green thread). Microthreads manage the execution of different subtasks in a program on the same CPU core. Thus, they are an alternative to event-based asynchronous programming and also avoid the overhead of using separate threads for single-core programs (because no mode switching between user mode and kernel mode needs to be done, so CPU usage can be reduced).

Although microthreads make it easier to deal with running subtasks on a single core, Stackless Python does not remove CPython's Global Interpreter Lock, nor does it use multiple threads and/or processes. So it allows only cooperative multitasking on a shared CPU and not parallelism (preemption was originally not available but is now in some form[3]). To use multiple CPU cores, one would still need to build an interprocess communication system on top of Stackless Python processes.

Due to the considerable number of changes in the source, Stackless Python cannot be installed on a preexisting Python installation as an extension or library. It is instead a complete Python distribution in itself. The majority of Stackless's features have also been implemented in PyPy, a self-hosting Python interpreter and JIT compiler.[4] 



Stackless Python's main benefit is the support for very lightweight coroutines. CPython doesn't support coroutines natively (although I expect someone to post a generator-based hack in the comments) so Stackless is a clear improvement on CPython when you have a problem that benefits from coroutines.

I think the main area where they excel are when you have many concurrent tasks running within your program. Examples might be game entities that run a looping script for their AI, or a web server that is servicing many clients with pages that are slow to create.

You still have many of the typical problems with concurrency correctness however regarding shared data, but the deterministic task switching makes it easier to write safe code since you know exactly where control will be transferred and therefore know the exact points at which the shared state must be up to date.

### Python multithreading

https://tenthousandmeters.com/blog/python-behind-the-scenes-13-the-gil-and-its-effects-on-python-multithreading/
https://stackoverflow.com/questions/52507601/whats-the-point-of-multithreading-in-python-if-the-gil-exists

## Python Async

https://realpython.com/async-io-python/

You may be thinking with dread, “Concurrency, parallelism, threading, multiprocessing. That’s a lot to grasp already. Where does async IO fit in?”

Parallelism consists of performing multiple operations at the same time. Multiprocessing is a means to effect parallelism, and it entails spreading tasks over a computer’s central processing units (CPUs, or cores). Multiprocessing is well-suited for CPU-bound tasks: tightly bound for loops and mathematical computations usually fall into this category.

Concurrency is a slightly broader term than parallelism. It suggests that multiple tasks have the ability to run in an overlapping manner. (There’s a saying that concurrency does not imply parallelism.)

Threading is a concurrent execution model whereby multiple threads take turns executing tasks. One process can contain multiple threads. Python has a complicated relationship with threading thanks to its GIL, but that’s beyond the scope of this article.

In fact, async IO is a single-threaded, single-process design: it uses cooperative multitasking, a term that you’ll flesh out by the end of this tutorial. It has been said in other words that async IO gives a feeling of concurrency despite using a single thread in a single process. Coroutines (a central feature of async IO) can be scheduled concurrently, but they are not inherently concurrent.

That leaves one more term. What does it mean for something to be asynchronous? This isn’t a rigorous definition, but for our purposes here, I can think of two properties:
    Asynchronous routines are able to “pause” while waiting on their ultimate result and let other routines run in the meantime.

At the heart of async IO are coroutines. A coroutine is a specialized version of a Python generator function. Let’s start with a baseline definition and then build off of it as you progress here: a coroutine is a function that can suspend its execution before reaching return, and it can indirectly pass control to another coroutine for some time.

The keyword await passes function control back to the event loop. (It suspends the execution of the surrounding coroutine.) If Python encounters an await f() expression in the scope of g(), this is how await tells the event loop, “Suspend execution of g() until whatever I’m waiting on—the result of f()—is returned. In the meantime, go let something else run.”

 For now, just know that an awaitable object is either (1) another coroutine or (2) an object defining an .__await__() dunder method that returns an iterator. If you’re writing a program, for the large majority of purposes, you should only need to worry about case #1.

That brings us to one more technical distinction that you may see pop up: an older way of marking a function as a coroutine is to decorate a normal def function with @asyncio.coroutine. The result is a generator-based coroutine. This construction has been outdated since the async/await syntax was put in place in Python 3.5.

While “making random integers” (which is CPU-bound more than anything) is maybe not the greatest choice as a candidate for asyncio, it’s the presence of asyncio.sleep() in the example that is designed to mimic an IO-bound process where there is uncertain wait time involved.

This isn’t very interesting on its surface. The result of calling a coroutine on its own is an awaitable coroutine object.

Time for a quiz: what other feature of Python looks like this? (What feature of Python doesn’t actually “do much” when it’s called on its own?)

Hopefully you’re thinking of generators as an answer to this question, because coroutines are enhanced generators under the hood. The behavior is similar in this regard:

```
>>> def gen():
...     yield 0x10, 0x20, 0x30
...
>>> g = gen()
>>> g  # Nothing much happens - need to iterate with `.__next__()`
<generator object gen at 0x1012705e8>
>>> next(g)
(16, 32, 48)
```

Technically, await is more closely analogous to yield from than it is to yield. (But remember that yield from x() is just syntactic sugar to replace for i in x(): yield i.)

One critical feature of generators as it pertains to async IO is that they can effectively be stopped and restarted at will. For example, you can break out of iterating over a generator object and then resume iteration on the remaining values later. When a generator function reaches yield, it yields that value, but then it sits idle until it is told to yield its subsequent value.

This is the fundamental difference between functions and generators. A function is all-or-nothing. Once it starts, it won’t stop until it hits a return, then pushes that value to the caller (the function that calls it). A generator, on the other hand, pauses each time it hits a yield and goes no further. Not only can it push this value to calling stack, but it can keep a hold of its local variables when you resume it by calling next() on it.

There’s a second and lesser-known feature of generators that also matters. You can send a value into a generator as well through its .send() method. This allows generators (and coroutines) to call (await) each other without blocking. I won’t get any further into the nuts and bolts of this feature, because it matters mainly for the implementation of coroutines behind the scenes, but you shouldn’t ever really need to use it directly yourself.

Let’s try to condense all of the above articles into a few sentences: there is a particularly unconventional mechanism by which these coroutines actually get run. Their result is an attribute of the exception object that gets thrown when their .send() method is called. There’s some more wonky detail to all of this, but it probably won’t help you use this part of the language in practice, so let’s move on for now.

## Side note. Low level implementation of generators
https://leanpub.com/insidethepythonvirtualmachine/read#leanpub-auto-generators-behind-the-scenes

contains the yield statement, so calling it will not return a simple value as a conventional function would do. Instead, it will return a generator object which captures the continuation of the computation
We can then use the next function to get successive values from the returned generator object or send values into the generator using the send method of the generator object.

Cpython. We can see that a generator object contains a frame object and a code object, two objects that are essential to the execution of Python bytecode.

The following comprise the main attributes of a generator object.

    prefix##_frame: This field references a frame object. This frame object contains the code object of a generator and it is within this frame that the execution of the generator object’s code object takes place.
    prefix##_running: This is a boolean field that indicates whether the generator is running.
    prefix##_code: This field references the code object associated with the generator. This is the code object that executes whenever the generator is running.

During the execution of the code object for the function, recall the _PyEval_EvalCodeWithName is invoked to perform some setup. During this setup process, the interpreter checks if the CO_GENERATOR flag; if set, it creates and returns a generator object rather than call the evaluation loop function. The magic happens at the last code block of the _PyEval_EvalCodeWithName as shown in listing 12.2.

We can see from Listing 12.2 that bytecode for a generator function code object is never executed at the point of the function call - the execution of bytecode only happens when the returned generator object is running, and we look at this next. 

We can run a generator object by passing it as an argument to the next builtin function. This will cause the generator to execute until it hits a yield expression then it suspends execution. The critical question here is how the generators can capture the execution state and update those at will.

Now that we know how a generator object captures execution state, we move to the question of how the execution of a suspended generator object is resumed, and this is not too hard to figure out given the information that we have already. When the next builtin function is called with a generator as an argument, the next function dereferences the tp_iternext field of the generator type and invokes whatever function that field references. In the case of a generator object, that field references a function, gen_iternext, which calls the gen_send_ex function, that does the actual work of resuming the execution of the generator object. Before the generator object was created, the initial setup of the frame object and variables was carried out by the _PyEval_EvalCodeWithName function, so the execution of the generator object involves calling the PyEval_EvalFrameEx with the frame object contained within the generator object as the frame argument. The execution of the code object contained within the frame then proceeds as explained the chapter on the evaluation loop. 

Python generators do more than just generate values; they can also consume values by using the generator send method. This is possible because yield is an expression that evaluates to a value. When the send method is called on a generator with a value, the gen_send_ex method places the value onto the evaluation stack of the generator object frame before the evaluation of the frame object resumes. Listing 12.3 shows the STORE_FAST instruction comes after YIELD_VALUE; this stores the value at the top of the stack to the provided name. In the case where there is no send function call, then the None value is placed on the top of the stack.

## More about the roots of async/await in generators
https://snarky.ca/how-the-heck-does-async-await-work-in-python-3-5/

But until recently I didn't understand how async/await worked in Python 3.5. I knew that yield from in Python 3.3 combined with asyncio in Python 3.4 had led to this new syntax. But having not done a lot of networking stuff -- which asyncio is not limited to but does focus on -- had led to me not really paying much attention to all of this async/await stuff.

Having a function pause what it is doing whenever it hit a yield expression -- although it was a statement until Python 2.5 -- and then be able to resume later is very useful in terms of using less memory, allowing for the idea of infinite sequences, etc.

But as you may have noticed, generators are all about iterators. Now having a better way to create iterators is obviously great (and this is shown when you define an __iter__() method on an object as a generator), but people knew that if we took the "pausing" part of generators and added in a "send stuff back in" aspect to them, Python would suddenly have the concept of coroutines in Python

Among other things, PEP 342 introduced the send() method on generators. This allowed one to not only pause generators, but to send a value back into a generator where it paused.

Generators were not mucked with again until Python 3.3 when PEP 380 added yield from. Strictly speaking, the feature empowers you to refactor generators in a clean way by making it easy to yield every value from an iterator (which a generator conveniently happens to be).

By virtue of making refactoring easier, yield from also lets you chain generators together so that values bubble up and down the call stack without code having to do anything special.

```
def bottom():
    # Returning the yield lets the value that goes up the call stack to come right back
    # down.
    return (yield 42)

def middle():
    return (yield from bottom())

def top():
    return (yield from middle())

# Get the generator.
gen = top()
value = next(gen)
print(value)  # Prints '42'.
try:
    value = gen.send(value * 2)
except StopIteration as exc:
    value = exc.value
print(value)  # Prints '84'
```

It's important to understand what an event loop is and how they make asynchronous programming possible if you're going to care about async/await. If you have done GUI programming before -- including web front-end work -- then you have worked with an event loop. 

Going back to Wikipedia, an event loop "is a programming construct that waits for and dispatches events or messages in a program". Basically an event loop lets you go, "when A happens, do B". Probably the easiest example to explain this is that of the JavaScript event loop that's in every browser. Whenever you click something ("when A happens"), the click is given to the JavaScript event loop which checks if any onclick callback was registered to handle that click ("do B"). If any callbacks were registered then the callback is called with the details of the click. The event loop is considered a loop because it is constantly collecting events and loops over them to find what to do with the event.

In Python's case, asyncio was added to the standard library to provide an event loop. There's a focus on networking in asyncio which in the case of the event loop is to make the "when A happens" to be when I/O from a socket is ready for reading and/or writing (via the selectors module). Other than GUIs and I/O, event loops are also often used for executing code in another thread or subprocess and have the event loop act as the scheduler (i.e., cooperative multitasking). If you happen to understand Python's GIL, event loops are useful in cases where releasing the GIL is possible and useful.

Asynchronous programming is basically programming where execution order is not known ahead of time (hence asynchronous instead of synchronous). 
