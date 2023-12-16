---
layout: post
title:  "multiprocess"
categories: programming
lang: ru
ref: curl_postman
---

## Erlang concurrency, parallelism and virtual machine
To make it efficient, it made sense for processes to be started very quickly, to be destroyed very quickly and to be able to switch them really fast. 
Having them lightweight was mandatory to achieve this. It was also mandatory because you didn't want to have things like process pools 
(a fixed amount of processes you split the work between.) Instead, it would be much easier to design programs that could use as many processes as they need.

Anyway, to get back to small processes, because telephony applications needed a lot of reliability, it was decided that the cleanest way to do things was to
forbid processes from sharing memory. Shared memory could leave things in an inconsistent state after some crashes (especially on data shared across different nodes)
and had some complications. Instead, processes should communicate by sending messages where all the data is copied. This would risk being slower, but safer.

Alright, so it was decided that lightweight processes with asynchronous message passing were the approach to take for Erlang. How to make this work? Well, first of all, the operating system can't be trusted to handle the processes. Operating systems have many different ways to handle processes, and their performance varies a lot. Most if not all of them are too slow or too heavy for what is needed by standard Erlang applications. By doing this in the VM, the Erlang implementers keep control of optimization and reliability. Nowadays, Erlang's processes take about 300 words of memory each and can be created in a matter of microseconds—not something doable on major operating systems these days.

To handle all these potential processes your programs could create, the VM starts one thread per core which acts as a scheduler. Each of these schedulers has a run queue, or a list of Erlang processes on which to spend a slice of time. When one of the schedulers has too many tasks in its run queue, some are migrated to another one. This is to say each Erlang VM takes care of doing all the load-balancing and the programmer doesn't need to worry about it. There are some other optimizations that are done, such as limiting the rate at which messages can be sent on overloaded processes in order to regulate and distribute the load.

Your parallel program only goes as fast as its slowest sequential part.
The difficulty of obtaining linear scaling is not due to the language itself, but rather to the nature of the problems to solve.
Problems that scale very well are often said to be embarrassingly parallel. (raytracing)

https://blog.stenmans.org/theBeamBook/#CH-Scheduling

## One core and multi-core systems

##

https://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like
first answer
https://www.codeproject.com/Articles/889245/Deep-Inside-CPU-Raw-Multicore-Programming
https://www.reddit.com/r/learnprogramming/comments/va0tpm/how_is_multithreading_implemented_at_assembly/

Advanced Programmable Interrupt Controller APIC
https://en.wikipedia.org/wiki/Advanced_Programmable_Interrupt_Controller

## What is linux process

In many operating systems, a common design paradigm is to separate
high-level policies from their low-level mechanisms [L+75]. You can
think of the mechanism as providing the answer to a how question about
a system; for example, how does an operating system perform a context
switch? The policy provides the answer to a which question; for example,
which process should the operating system run right now? Separating the
two allows one easily to change policies without having to rethink the
mechanism and is thus a form of modularity, a general software design
principle.

In order to virtualize the CPU, the operating system needs to somehow
share the physical CPU among many jobs running seemingly at the same
time. The basic idea is simple: run one process for a little while, then
run another one, and so forth. By time sharing the CPU in this manner,
virtualization is achieved.

There are a few challenges, however, in building such virtualization machinery. The first is performance: how can we implement virtualiza-
tion without adding excessive overhead to the system? The second is control: how can we run processes efficiently while retaining control over
the CPU? Control is particularly important to the OS, as it is in charge of
resources; without control, a process could simply run forever and take
over the machine, or access information that it should not be allowed to
access. Obtaining high performance while maintaining control is thus
one of the central challenges in building an operating system.

One approach would simply be to let any process do whatever it wants
in terms of I/O and other related operations. However, doing so would
prevent the construction of many kinds of systems that are desirable. For
example, if we wish to build a file system that checks permissions before
granting access to a file, we can’t simply let any user process issue I/Os
to the disk; if we did, a process could simply read or write the entire disk
and thus all protections would be lost.
Thus, the approach we take is to introduce a new processor mode,
known as user mode; code that runs in user mode is restricted in what it
can do. For example, when running in user mode, a process can’t issue
I/O requests; doing so would result in the processor raising an exception;
the OS would then likely kill the process.
In contrast to user mode is kernel mode, which the operating system

The hardware assists the OS by providing different modes of execution.
In user mode, applications do not have full access to hardware resources.
In kernel mode, the OS has access to the full resources of the machine.
Special instructions to trap into the kernel and return-from-trap back to
user-mode programs are also provided, as well instructions that allow the
OS to tell the hardware where the trap table resides in memory.

To execute a system call, a program must execute a special trap instruc-
tion. This instruction simultaneously jumps into the kernel and raises the
privilege level to kernel mode; once in the kernel, the system can now per-
form whatever privileged operations are needed (if allowed), and thus do
the required work for the calling process. When finished, the OS calls a
special return-from-trap instruction, which, as you might expect, returns
into the calling user program while simultaneously reducing the privi-
lege level back to user mode.
The hardware needs to be a bit careful when executing a trap, in that it

to return correctly when the OS issues the return-from-trap instruction.
On x86, for example, the processor will push the program counter, flags,
and a few other registers onto a per-process kernel stack; the return-from-
trap will pop these values off the stack and resume execution of the user-
mode program (see the Intel systems manuals [I11] for details). Other
hardware systems use different conventions, but the basic concepts are
similar across platforms.

Problem #2: Switching Between Processes
The next problem with direct execution is achieving a switch between
processes. Switching between processes should be simple, right? The
OS should just decide to stop one process and start another. What’s the
big deal? But it actually is a little bit tricky: specifically, if a process is
running on the CPU, this by definition means the OS is not running. If
the OS is not running, how can it do anything at all? (hint: it can’t) While
this sounds almost philosophical, it is a real problem: there is clearly no
way for the OS to take an action if it is not running on the CPU. Thus we
arrive at the crux of the problem.

the offending process).
Thus, in a cooperative scheduling system, the OS regains control of
the CPU by waiting for a system call or an illegal operation of some kind
to take place. You might also be thinking: isn’t this passive approach less
than ideal? What happens, for example, if a process (whether malicious,
or just full of bugs) ends up in an infinite loop, and never makes a system
call? What can the OS do then
?

over the machine?
The answer turns out to be simple and was discovered by a number
of people building computer systems many years ago: a timer interrupt
[M+63]. A timer device can be programmed to raise an interrupt every
so many milliseconds; when the interrupt is raised, the currently running
process is halted, and a pre-configured interrupt handler in the OS runs.
At this point, the OS has regained control of the CPU, and thus can do
what it pleases: stop the current process, and start a different one.

Saving and Restoring Context
Now that the OS has regained control, whether cooperatively via a sys-
tem call, or more forcefully via a timer interrupt, a decision has to be
made: whether to continue running the currently-running process, or
switch to a different one. This decision is made by a part of the operating
system known as the scheduler; we will discuss scheduling policies in
great detail in the next few chapters.
If the decision is made to switch, the OS then executes a low-level
piece of code which we refer to as a context switch. A context switch is
conceptually simple: all the OS has to do is save a few register values
for the currently-executing process (onto its kernel stack, for example)
and restore a few for the soon-to-be-executing process (from its kernel
stack). By doing so, the OS thus ensures that when the return-from-trap
instruction is finally executed, instead of returning to the process that was
running, the system resumes execution of another process.
To save the context of the currently-running process, the OS will exe-

To whet your appetite, we’ll just sketch some basics of how the OS
handles these tricky situations. One simple thing an OS might do is dis-
able interrupts during interrupt processing; doing so ensures that when
one interrupt is being handled, no other one will be delivered to the CPU.
Of course, the OS has to be careful in doing so; disabling interrupts for
too long could lead to lost interrupts, which is (in technical terms) bad.
Operating systems also have developed a number of sophisticated
locking schemes to protect concurrent access to internal data structures.
This enables multiple activities to be on-going within the kernel at the
same time, particularly useful on multiprocessors. As we’ll see in the
next piece of this book on concurrency, though, such locking can be com-
plicated and lead to a variety of interesting and hard-to-find bugs.

Single-Queue Scheduling
With this background in place, we now discuss how to build a sched-
uler for a multiprocessor system. The most basic approach is to simply
reuse the basic framework for single processor scheduling, by putting all
jobs that need to be scheduled into a single queue; we call this single-
queue multiprocessor scheduling or SQMS for short. This approach
has the advantage of simplicity; it does not require much work to take an
existing policy that picks the best job to run next and adapt it to work on
more than one CPU (where it might pick the best two jobs to run, if there
are two CPUs, for example).

of scalability. To ensure the scheduler works correctly on multiple CPUs,
the developers will have inserted some form of locking into the code, as
described above. Locks ensure that when SQMS code accesses the single
queue (say, to find the next job to run), the proper outcome arises.
Locks, unfortunately, can greatly reduce performance, particularly as

0.5 Multi-Queue Scheduling
Because of the problems caused in single-queue schedulers, some sys-
tems opt for multiple queues, e.g., one per CPU. We call this approach
multi-queue multiprocessor scheduling (or MQMS).
In MQMS, our basic scheduling framework consists of multiple schedul-
ing queues. Each queue will likely follow a particular scheduling disci-
pline, such as round robin, though of course any algorithm can be used.
When a job enters the system, it is placed on exactly one scheduling
queue, according to some heuristic (e.g., random, or picking one with
fewer jobs than others). Then it is scheduled essentially independently,
thus avoiding the problems of information sharing and synchronization
found in the single-queue approach.
For example, assume we have a system where there are just two CPUs

contents therein.
But, if you’ve been paying attention, you might see that we have a new
problem, which is fundamental in the multi-queue based approach: load
imbalance. Let’s assume we have the same set up as above (four jobs,
two CPUs), but then one of the jobs (say C) finishes. We now have the
following scheduling queues:

The obvious answer to this query is to move jobs around, a technique
which we (once again) refer to as migration. By migrating a job from one
CPU to another, true load balance can be achieved.
Let’s look at a couple of examples to add some clarity. Once again, we

В ассембле все равно будет вызов
`call    pthread_create@PLT`

## Go language

Each operating system thread has a fixed-size block memory (sometimes as large as 2MB) for its stack, which is the work area where it saves the local variables of function calls that are in process or momentarily halted while another function is performed. This fixed-size stack is both too big and too small. A 2MB stack would be a tremendous waste of memory for a small goroutine that simply waits for a WaitGroup before closing a channel.

It is not uncommon for a Go program to generate hundreds of thousands of goroutines at once, which would be difficult to stack. Regardless of size, fixed-size stacks are not always large enough for the most complex and deeply recursive routines. Changing the fixed size can improve space efficiency and allow for the creation of more threads, or it can permit more deeply recursive algorithms, but not both.

A goroutine, on the other hand, starts with a modest stack, typically 2KB. The stack of a goroutine, like the stack of an OS thread, maintains the local variable of active and suspended function calls, but unlike the stack of an OS thread, the stack of a goroutine is not fixed; it grows and shrinks as needed. A goroutine stack’s size limit could be as much as 1GB, which is orders of magnitude larger than a conventional fixed-size thread stack; however, few goroutines use that much.

https://www.developer.com/languages/go-scheduler/
https://hadar.gr/2017/lightweight-goroutines
https://stackoverflow.com/questions/24599645/how-do-goroutines-work-or-goroutines-and-os-threads-relation

wiki go


https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/

hree more languages that don’t have this problem: Go, Lua, and Ruby.

Any guess what they have in common?

Threads. Or, more precisely: multiple independent callstacks that can be switched between. It isn’t strictly necessary for them to be operating system threads. Goroutines in Go, coroutines in Lua, and fibers in Ruby are perfectly adequate.

The fundamental problem is “How do you pick up where you left off when an operation completes”? You’ve built up some big callstack and then you call some IO operation. For performance, that operation uses the operating system’s underlying asynchronous API. You cannot wait for it to complete because it won’t. You have to return all the way back to your language’s event loop and give the OS some time to spin before it will be done.

Once operation completes, you need to resume what you were doing. The usual way a language “remembers where it is” is the callstack. That tracks all of the functions that are currently being invoked and where the instruction pointer is in each one.

But to do async IO, you have to unwind and discard the entire C callstack. Kind of a Catch-22. You can do super fast IO, you just can’t do anything with the result! Every language that has async IO in its core—or in the case of JS, the browser’s event loop—copes with this in some way.


This is why async-await didn’t need any runtime support in the .NET framework. The compiler compiles it away to a series of chained closures that it can already handle. (Interestingly, closures themselves also don’t need runtime support. They get compiled to anonymous classes. In C#, closures really are a poor man’s objects.)

## multiprocessing module in Python

multiprocessing is a package that supports spawning processes using an API similar to the threading module. The multiprocessing package offers both local and remote concurrency, effectively side-stepping the Global Interpreter Lock by using subprocesses instead of threads. Due to this, the multiprocessing module allows the programmer to fully leverage multiple processors on a given machine. It runs on both POSIX and Windows.

The multiprocessing module also introduces APIs which do not have analogs in the threading module. A prime example of this is the Pool object which offers a convenient means of parallelizing the execution of a function across multiple input values, distributing the input data across processes (data parallelism). 

### Sources

https://learnyousomeerlang.com/the-hitchhikers-guide-to-concurrency
https://www.tomshardware.com/news/cpu-core-definition,37658.html
os three easy pieces
