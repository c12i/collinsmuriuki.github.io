---
title: "Building a Web Assembly powered password generator"
layout: post
date: 2020-10-24 22:44
image: /assets/images/rust-ferris.jpeg
headerImage: true
tag:
    - rust
    - wasm
    - react.js
    - javascript
star: false
category: blog
author: collinsmuriuki
description: Building a Web Assembly powered password generator with rust-wasm and React.js.
---

# Building a Web Assembly-powered Password Generator with Rust and React

## Introduction

In this tutorial, we will explore the fascinating intersection of Rust, Web Assembly (Wasm), and React by building a simple password generator. We'll leverage the speed and performance benefits of Rust, compile it into Wasm, and seamlessly integrate it into a React application. By the end of this project, you'll have a clear understanding of how these technologies work together.

## Why Rust and Web Assembly?

Web Assembly is a low-level virtual machine that allows executing code at near-native speeds within web browsers. Rust, known for its speed and memory safety, is an ideal language for Wasm. Unlike high-level languages like JavaScript, Rust provides developers with low-level control and reliable performance, making it an excellent choice for Wasm.

## Prerequisites

Before we dive into the project, ensure you have the following tools and knowledge:

- Rust and Cargo: Install them using [this link](https://www.rust-lang.org/tools/install).
- wasm-pack: A tool for building and working with Rust-generated Web Assembly. Install it [here](https://rustwasm.github.io/wasm-pack/installer/).
- Node.js: Required for React development. Install it from [nodejs.org](https://nodejs.org/en/).
- Basic knowledge of Rust and JavaScript/React.js.

## Initializing the Rust Project

Let's start by creating a new Rust Web Assembly project using the following command:

```shell
wasm-pack new wasm_pass
```

This command generates a Rust library crate with Web Assembly support. The crucial files are `Cargo.toml`, `src/lib.rs`, and `src/utils.rs`.

## Dissecting the Boilerplate

Explore the generated project structure:

```shell
wasm_pass/
├── Cargo.toml
├── LICENSE_APACHE
├── LICENSE_MIT
├── README.md
└── src
    ├── lib.rs
    └── utils.rs
```

- **Cargo.toml**: Contains project dependencies and metadata.
- **lib.rs**: The root of the crate, compiled into Web Assembly.
- **utils.rs**: Includes debugging utilities (not used in this project).

## Initial Build

Build the project using:

```shell
wasm-pack build
```

This creates a `pkg` directory with the following artifacts:

```shell
pkg/
├── package.json
├── README.md
├── wasm_pass.wasm
├── wasm_pass.d.ts
└── wasm_pass.js
```

These files enable npm integration and contain the compiled Web Assembly code.

## Writing Rust Code

Update the `Cargo.toml` file to include the `rand` crate:

```toml
[dependencies]
wasm-bindgen = "0.2.63"
rand = { version = "0.7.3", features = ["wasm-bindgen"] }
```

This adds the random number generation utility to our project. Run `cargo build` to download the new dependency.

Implement the password generator logic in `src/lib.rs`:

```rust
use wasm_bindgen::prelude::*;
use rand::Rng;

#[wasm_bindgen]
pub fn generate(len: usize) -> String {
    const CHARSET: &[u8] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ\
                            abcdefghijklmnopqrstuvwxyz\
                            0123456789)(*&^%$#@!~".as_bytes();

    let mut rng = rand::thread_rng();

    let password: String = (0..len)
        .map(|_| {
            let idx = rng.gen_range(0, CHARSET.len());
            CHARSET[idx] as char
        })
        .collect();
    password
}
```

This function generates a random password of the specified length using the `rand` crate.

## Testing the Code

Write a test for the `generate` function in `src/lib.rs`:

```rust
#[cfg(test)]
mod tests {
    use super::generate;

    #[test]
    fn test_generate() {
        let password = generate(20);
        assert_eq!(password.len(), 20);
    }
}
```

Run the tests with:

```shell
cargo test -- --show-output
```

Ensure the tests pass, confirming the functionality of the password generator.

## Implementing Web Assembly in a React App

Create a React app in the `app` directory:

```shell
mkdir app
cd app
mkdir src
echo "/node_modules" > .gitignore
npm init -y
```

Install necessary dependencies:

```shell
npm install --save react react-dom
npm install --save-dev @babel/core @babel/preset-env @babel/preset-react babel-loader webpack webpack-cli webpack-dev-server html-webpack-plugin style-loader css-loader html-loader
```

Create the React app files: `index.html`, `index.js`, and `App.js`. Configure Babel with `.babelrc` and Webpack with `webpack.config.js`.

Finally, run the development server:

```shell
npm start
```

## Using the Package in React

Update the `App.js` file to use the Rust-generated Web Assembly package:

```javascript
import React, { useState, useCallback, useEffect } from "react";

const App = () => {
    const [password, setPassword] = useState("");
    const [input, setInput] = useState("");

    const handleChange = (e) => {
        setInput(e.target.value);
    };

    const generatePassword = useCallback(() => {
        const module = import("wasm-pass")
        module.then(({generate}) => {
            setPassword(generate(parseInt(input)))
        }).catch(err => {
            alert(err.toString())
        })
    }, [input]);

    useEffect(() => {
        generatePassword()
    }, [input]);

    return (
        <div>
            <p>Enter password length:</p>
            <input onChange={handleChange} type="number" value={input} />
            <button onClick={generatePassword}>Generate Password</button>
            <p>Your password:</p>
            <strong>{password}</strong>
        </div>
    );
};

export default App;
```

This React component allows users to input a password length, click a button, and receive a randomly generated password from the Rust Web Assembly package.

## Conclusion

This tutorial showcases the integration of Rust and Web Assembly in a React application, providing a powerful blend of performance and modern front-end technologies. Explore further resources to deepen your understanding of Rust and Web Assembly:

- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust and Web Assembly Book](https://rustwasm.github.io/docs/book/)
- [wasm-bindgen Documentation](https://rustwasm.github.io/docs/wasm-bindgen/introduction.html)
- [Wasm By Example](https://wasmbyexample.dev/home.en-us.html)
- [WebAssembly.org](https://webassembly.org/)

Check the [full working implementation](https://wasm-pass.collinsmuriuki.xyz) of this project for reference. Happy coding!
