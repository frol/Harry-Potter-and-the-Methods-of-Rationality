Harry Potter and the Methods of Rationality
===========================================

Petunia married a biochemist, and Harry grew up reading science and science
fiction. Then came the Hogwarts letter, and a world of intriguing new
possibilities to exploit. And new friends, like Hermione Granger, and Professor
McGonagall, and Professor Quirrell...


This github repo is ...
-----------------------

This project is just for fun. I'm not an author of the book, but I have created
this project to provide readers with an easy automatic method of making
up-to-date version of a book-style PDF.


How to read?
------------

Open `book/build/book.pdf` and start reading! Enjoy it!


How to update and build?
------------------------

There are three steps:

1. Download .html files of missing chapters and save them into `part_N.html`;
1. Use `parser/parser.sh` to generate new `blocks/part_N.tex`;
1. Run `make` command in `book` folder to build a PDF.


Build requirements
------------------

I'm doing all the work on Ubuntu 14.04 though it doesn't have any strict
requirements to the environment.

* bash
* sed
* grep
* make
* latex (I use Texlive-base 2013.20140215-1, but I believe early versions will
  work as well)
* ps2pdf
