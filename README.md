# Momentos
`HTML` `CSS` `JavaScript` `Ruby` `SQL`

Simple photo-sharing web app hosted on Heroku [here](https://salty-badlands-39010.herokuapp.com).

## User stories
You can find these on the [Trello board](https://trello.com/b/XLyquByK).

## Entity-relationship diagram
The entity-relationship diagram is made with [draw.io](https://www.draw.io/?lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=er_diagram.xml#Uhttps%3A%2F%2Fraw.githubusercontent.com%2Fchanjk%2Fmomentos%2Fmaster%2Fer_diagram.xml).

## Wireframes
Wireframes are made with [draw.io](https://www.draw.io/?lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=wireframe.xml#Uhttps%3A%2F%2Fraw.githubusercontent.com%2Fchanjk%2Fmomentos%2Fmaster%2Fwireframe.xml).

## Technologies

* Front-end written in: **HTML**, **CSS**, **JavaScript**
* Back-end written in: **Ruby**
* Web framework: **Sinatra**
* Database: **PostgreSQL**
* ORM framework: **Active Record**

## Approach
This app has three main resources: users, albums, and photos. For each resource, a model was created with the following relationships:

* `User`: `has_many :albums`
* `Album`: `belongs_to :user`, `has_many :photos`
* `Photo`: `belongs_to :album`

Complete RESTful routes (GET, POST, PUT and DELETE) are available for `User` and `Album`. `Photo` has GET, POST and DELETE routes, and no PUT route.

[Bootstrap](http://getbootstrap.com) is also used to reduce the work of styling the web pages.

## Unresolved problems

* The search bar currently lists all users and albums, and does not use the search term to filter the results.

* Photos are added as links pointing to their original locations. The goal is to download the photos and save them locally instead.

* Upload photo from device functionality not finished yet.

* Styling still rough in places, due to poor understanding of Bootstrap.

## Lessons learnt

* Bootstrap is powerful, but takes time (definitely much more than a week) to learn.

* Feature creep is real&mdash;making a wireframe is easy compared to actually implementing it; this means that elements and features are 'easily' added to the wireframe, and cause anguish later when trying to realise the wireframe.

* Partials are awesome.
