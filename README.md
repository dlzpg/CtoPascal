# C-to-Pascal Translator (ANTLR4)

A syntax-directed translator that converts C-style preprocessor directives and variable declarations into **Pascal (`.pas`)** source code. This project was developed using **ANTLR4** and **Java**.

Collaborator: **[JFuB](https://github.com/JFuB)**

---

## 🚀 Overview

This tool parses a source file with C-like syntax and restructuring it into a Pascal-compliant format. It specifically handles:
* **Constants:** Conversion of `#define` macros into `const` blocks.
* **Base Conversions:** Support for Decimal, Octal, and Hexadecimal integers and floats.
* **Structure:** Generation of the mandatory Pascal `program Main;` header and `var` blocks.

## 🛠 Prerequisites

* **Java JDK 8 or higher.**
* **ANTLR v4** 
* **IntelliJ IDEA** (Recommended) with the **ANTLR v4** plugin installed.

## 📋 Examples
The file Documento1 contains some of the examples given in the folder casos de prueba.
