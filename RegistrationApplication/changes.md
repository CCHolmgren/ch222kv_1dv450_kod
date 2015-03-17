This file will include all changes that will be made, or are made to the api
===
Todo
===
Authorization, users shouldn't be allowed to remove stuff that they did not create

Done
===
Login sends username and password to the server, which responds with a token for you to use for further requests.
Working towards more JSON based server code by returning responses on delete of events.
Added a Token based system, in which you send your login details to /login and you get a token back. This token is used to make requests, a little bit like JWT. Method is copied from the api key.
A little better handling of errors in the controllers, less red pages.
More authorization, no deleting events that you did not create.
Removed routes that should not be used.
Authorization check moved to only where it is needed.