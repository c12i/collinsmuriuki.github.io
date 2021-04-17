---
title: "Increase Node.js memory limit"
layout: post
date: 2018-05-23 19:00
headerImage: false
tag:
    - node
    - javascript
star: false
category: blog
author: collinsmuriuki
description: Increase Node.js memory limit.
---

If you're constantly building and shipping apps with Node.js, there's a likelihood that you may run into the dreaded `FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed`. This error kills the current process hence killing your server.

This is expected if your server is performing memory intensive tasks such as transferring huge amounts of data with limited underlying resources.

## The V8 engine

We all know that Node.js is built upon Google's V8 engine.

> V8 is Google’s open source high-performance JavaScript and WebAssembly engine, written in C++. It is used in Chrome and in Node.js, among others. It implements ECMAScript and WebAssembly, and runs on Windows 7 or later, macOS 10.12+, and Linux systems that use x64, IA-32, ARM, or MIPS processors. V8 can run standalone, or can be embedded into any C++ application.

Whenever we start a process on Node, V8 allocates a specific amount of memory to it, based on your current hardware specifications.

It is possible to extract this information within Node and that should be the first thing you do if you begin to run out of memory.

Start by creating an `index.js` script and run the code above to get the amount of memory allocated to your current process.

```javascript
const v8 = require("v8");

const totalHeapSize = v8.getHeapStatistics().total_available_size;
let totalHeapSizeInGB = (totalHeapSize / 1024 / 1024 / 1024).toFixed(2);
console.log(
    `Total Heap Size is ${totalHeapSize} bytes`,
    `${totalHeapSizeInGB} GB`
);
```

The `v8` module is inbuilt into node and it contains some useful methods like `v8.getHeapStatistics()` that allow us to get info on the heap allocated memory. I won't dwell too much on process memory in this short blog, but you can read about it [here](https://www.guru99.com/stack-vs-heap.html), so you can get a better understanding of its role, the heap specifically in this case.

If you run your script, you should be able to see the amount of allocated memory printed out. This number varies depending on the specs you pack on your system.

```shell
Total Heap Size is 2138706608,   GB 1.99
```

My computer memory is 8GB but V8 is currently allocating 1.99GB to this process. As you can see, we have a possible leeway to extend this capacity, that is if there are no other memory intensive processes running concurrently.

## Increase the capacity

Increasing the capacity is as simple as passing an argument as you run your script. More specifically the `--max-old-space-size` argument, as well as specifying the amount of memory we want to allocate in kilobytes like so:

```shell
node --max-old-space-size=4096 index.js
```

And that's pretty much it, we can check if this works by running our script again:

```shell
Total Heap Size is 4283117000,   GB 3.99
```

We have just doubled our memory, now our processes will have a bit more breathing room.

## Disclaimer

Do this only if you have enough free memory. This is redundant if you try allocating 8GB to a computer with 4GB memory!

In addition, refactoring your code to be more memory efficient should be your first priority before attempting this.
