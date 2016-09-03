# agate
coffeescript modules

## Application Structure

The structure is to run a multi page website as a collection 
of single page applications.  The webserver will provide an empty 
page, with only *font-awesome* and *bootstrap* css resources loaded 
in the head of the page.  The body is expected to be empty, or filled
with content expressing that the app is loading.

Backbone.Radio is being used to provide an "api"(I hope to flesh it out
more in the future) for communication between the child applets and the 
application, as well as between the children.  The main application has 
two channels, the main "global" channel and a "messages" channel.  Each 
applet should also provide it's own channel.  **An applet that depends 
on another applet's channel should be "required" after that other 
applet in the main app file.** 


### Global Radio Channel

#### Replies

- **main:app:object**

	- returns the marionette app object
	
	- set in agate when creating app
  
- **mainpage:init** 

	- signature (appmodel) ->
	
	- renders main page layout and child views
	
	- triggers **mainpage:displayed** event
	
	- set handler in application
	
- **applet:{*appname*}:route**

	- initializes approute and controller for applet
	
- **main:app:get-region**

	- retrieve a region from the root layout
	
	- this will be either removed or renamed to make it known 
	  that only root layout regions can be retrived through this
	  request

- **main:app:appmodel**

	- returns the appmodel
	
	- set handler in application

#### Events

- **mainpage:displayed** 

	- use this to render child views
	
	- set handler in application

### The Entry File

I keep the app for each page in an "entries" directory in the client source 
tree.  This lets me "require" a "base" or "startup" module that is common to 
each page, holding much of the boilerplate.  In the base entry file, the 
initial requirements are performed, such as importing the bootstrap 
javascript , as well as the modules that define handlers for the application 
and message radio channels.

#### App Model

After that an Appmodel should be defined, based on the BaseAppModel in agate.  
The appmodel contains basic structure of your application:

- **apiRoot:** this is new, but it will be the prefix to api calls

- **brand:**

	- name: the name of the brand at the top left corner
	- url: the link

- **container:** either "container" or "container-fluid"

- **layout_template:** if this is defined, it will be used
  instead of the default layout template.

- **frontdoor_app:**  This is the name of the applet 
  that will be used for the initial entry to the page.  **No** 
  backbone routing is setup in the main application space, and 
  responding to routing requests is the responsibility of the 
  applet.  Even though requiring the applets is still necessary in 
  the main application file, the application itself is just the 
  shell to run applets, and this requires an applet for initial 
  entry.
  
- **hasUser:** Are we running from a web server and expecting a login, or
  are we on a static site like github pages.  This being true, by default, 
  expects a "userprofile" app **(FIXME: which should be named in the 
  appmodel)** to be required and ready.
  
- **needUser:**  This isn't used yet, but can be used to force 
  a user to a login view.
  
- **frontdoor_sidebar:**  This isn't being used now, and may not 
  be supported anymore.
  
- **applets:**  This is a list (an array) of objects representing the applets
  being used with the application.  The "frontdoor" and "userprofile" 
  applets don't need to be listed here.  **Even though these are being 
  listed here, they need to be required separately and expressly in the 
  application file, due to how the webpack configuration works.**
  
  - Each applet should have a set of properties:
  
	  - **name:**  This is the label displayed on the navbar.
	  
	  - **url**  This is the url for the applet (#appname).
	  
	  - **appname:**  This is the name of the app and every route
	  it desribes should begin with "appname," e.g. "/#appname/viewstatus."
	  
  - An "applet" in the array that has no name will be treated as a 
  simple link, using the name and url properties.
  
- **regions:**  This is a list of regions for the region manager and should
  correspond to the layout template.  The named regions that are used most 
  are "content, sidebar, messages, and modal."

- **routes:**  This is not being used.


#### Prepare the App

*This procedure needs to be modularized.*

The "prepare_app" function takes a Marionette.Application object and 
an App Model as paramaters, and uses the app model to prepare the 
application to display views and handle events.

The function is responsible for creating the region manager and 
using the appregion property of the app model to initialize the 
different regions and add them to the manager.  By default, he region 
named "modal" uses a special region to handle the special requirements 
of a modal view.  Also, the *navbar* and *content* regions use a 
special region class providing for a jquery slide-down effect on
showing the view.

Once the region manager is setup, the *navbar* region is set to 
listen to the show event and trigger an event on the global 
channel named *"appregion:navbar:displayed"*

The function also registers handlers on the global channel 
providing access to the app object, the region manager, and 
a request for each region by name.

The function then creates a handler for the 'start' event on 
the marionette application.  This handler starts everything when
app.start() is called.  The handler uses the appmodel to get the 
appnames of the applets, then requests "applet:#{appname}:route" 
on the global channel to register the routes for each applet.  
The handler also call the *route* request for the frontdoor applet, 
and if the *hasUser* property of the app model is true, the *route* 
request for the user profile applet is called as well.  

The app.start handler then uses the global radio channel to call the 
init page function passing the app model as an argument.  Then finally, 
it invokes Backbone.history.start(), if necessary.

#### Start the App

After being prepared, the app is started with app.start().  Currently,
work is being done to load the authenticated user before starting the 
app, if needed by the app model, which will provide a simple startup 
procedure that can be dictated almost wholly by the app model.


#### Init Page

The init page function initializes the main layout view using the default 
layout template, which can be overridden in the app model.

A handler is defined to listen for the *show* event on the layout view.  
When the view is shown, the *navbar* and *messages* views are then 
shown.

The *mainview* region, which is attached to the *<body>* tag is then 
told to *show* the layout view, starting the entire page view sequence.


### Applets



# this is 1.3G look at this laterx
git@github.com:David20321/FTJ.git
