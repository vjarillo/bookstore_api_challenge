# Bookstore API

## Introduction

Congratulations!, you have been selected to build the new book selling platform that
is going to compete with Amazon.com.

Don't worry, Rome wasn't built in a day, then you're not going to build all the Amazon
features, just a very simple book catalog.

Also you don't need to build a UI for this, because we already selected a great UI/UX
person that is going to built that part.

Instead, you have to create a robust API that they can use to perform operations on
the backend.

You have a week for this task because we need to present this to our stake hodlers.

_Please fork this repository to your personal github and create a PR on your github for code review_


## Bookstore

The bookstore (for now) it's simple we only need to store books an authors.

A book is composed by just a few fields like "name", "synopsis"
(which is just a brief description of the book), "release date", "edition" (the edition is
just an ordinal number), and a "price"  (don't worry about the currency).

An author is composed by a "first name", "last name", "date of birth".

We need to perform CRUD operations for books and authors in our API.

The API must send and receive JSON files.


## Constraints

Even though this is an MVP we have some constraints about the system that were listed as
requirements for our MVP.

The first one is that an author can have published multiple books in our system (for example:
JK Rowling, have released many Harry Potter books). And also a book can be written by multiple
authors.

The second one is a request from our stakeholders. We need to throttle requests if we have
received more than `REQUESTS_PER_SECOND` requests from the same IP address. This is to avoid
people scraping our system. **Do not use a gem for this request**


## Bonus points

- If you add some business logic to the tests (i.e. check that authors were born before the books were released)

- If you build the system inside docker containers.

- If you add tests to the application

- If you handle errors gracefully

- If you check the JSON schemas

- If only authenticated users can create, update or delete.
