# Any2Json-Documents

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

This repository contains the documentation how you can use the [Any2Json](https://github.com/RomualdRousseau/Any2Json)
to load documents from "real life".

## Description

In today's data-driven landscape, navigating the complexities of semi-structured documents poses a significant challenge
for organizations. These documents, characterized by diverse formats and a lack of standardization, often require
specialized skills for effective manipulation and analysis. However, we propose a novel framework to address this
challenge. By leveraging innovative algorithms and machine learning techniques, [Any2Json](https://github.com/RomualdRousseau/Any2Json)
offers a solution that transcends manual coding, providing enhanced accessibility to users across diverse skill levels.
Moreover, by automating the extraction process, it not only saves time but also minimizes errors, particularly beneficial
for industries dealing with large volumes of such documents. Crucially, this framework integrates seamlessly with machine
learning workflows, unlocking new possibilities for data enrichment and predictive modeling. Aligned with the paradigm of
data as a service, it offers a scalable and efficient means of managing semi-structured data, thereby expanding the toolkit
of data services available to organizations.

## Getting Started

### Dependencies

* Python 3.8.2 or above.
* Pip 20.0.2 or above.
* Just 1.24.0 or above.

### MkDocs Installation

To install MkDocs, run the following command from the command line:

```bash
pip install mkdocs
```

For more details, see the [Installation Guide](https://www.mkdocs.org/user-guide/installation/).

### Just Installation

For more details, see the [Installation Guide](https://github.com/casey/just).

### Build and run the documentation locally

Run the following command line:

```bash
just run
```

### Build and deploy the documentation on GitHub

Run the following command line:

```bash
just deploy
```

## Authors

* Romuald Rousseau, romuald.rousseau@servier.com

## Version History

* 1.0-SNAPSHOT
* Initial Release

## TODO

* Complete articles
  * [x] Article - Revolutionizing Data Management: The Transformative Potential of a Novel Framework for Semi-Structured Documents
* Complete tutorials
  * [x] Tutorial 1 - Getting Started
  * [x] Tutorial 2 - Data extraction with a complex semi-structured layout
  * [x] Tutorial 3 - Data extraction with defects
  * [x] Tutorial 4 - Data extraction with tags
  * [x] Tutorial 5 - Data extraction with pivot
  * [x] Tutorial 6 - More complex noise reduction
  * [ ] Tutorial 7 - Make a classifier
* Completes white papers
  * [x] Table Layout Regular Expression - Layex
  * [x] Semi-structured Document Feature Extraction
  * [x] Stats in white paper Layex
* Completes patents
  * [-] Patent 1 - Patent 1 - Method to Consistently and Efficiently Extract Table Layout Feature
  * [-] Patent 2 - Patent 2 - Method to Extract Semi-structured Document Features
* Build and Deploy site
  * [x] Write justfile
  * [x] svg -> png
