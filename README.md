# Eiffel Web Framework


## Overview

Official project site for Eiffel Web Framework:

* http://eiffelwebframework.github.com/EWF/

For more information please have a look at the related wiki:

* https://github.com/EiffelWebFramework/EWF/wiki

For download, check
* https://github.com/EiffelWebFramework/EWF/downloads

## Requirements
* Compiling from EiffelStudio 7.2
* Developped using EiffelStudio 7.3 (on Windows, Linux)
* Tested using EiffelStudio 7.2 with "jenkins" CI server (not anymore compatible with 6.8 due to use of `TABLE_ITERABLE')
* The code have to allow __void-safe__ compilation and non void-safe system (see [more about void-safety](http://docs.eiffel.com/book/method/void-safe-programming-eiffel) )

## How to get the source code?

Using git 
* git clone https://github.com/EiffelWebFramework/EWF.git

* And to build the required and related Clibs
  * cd contrib/ise_library/cURL
  * geant compile

## Libraries under 'library'

### server
* __ewsgi__: Eiffel Web Server Gateway Interface [read more](library/server/ewsgi)
  * connectors: various web server connectors for EWSGI
* libfcgi: Wrapper for libfcgi SDK 
* __wsf__: Web Server Framework [read more](library/server/wsf)
  *  __router__: URL dispatching/routing based on uri, uri_template, or custom [read more](library/server/wsf/router)

### protocol
* __http__: HTTP related classes, constants for status code, content types, ... [read more](library/protocol/http)
* __uri_template__: URI Template library (parsing and expander) [read more](library/protocol/uri_template)
* __CONNEG__: CONNEG library (Content-type Negociation) [read more](library/protocol/CONNEG)

### client
* __http_client__: simple HTTP client based on cURL [read more](library/client/http_client)

### text
* __encoder__: Various simpler encoders: base64, url-encoder, xml entities, html entities [read more](library/text/encoder)

### Others
* error: very simple/basic library to handle error

## External libraries under 'contrib'
* [Eiffel Web Nino](contrib/library/server/nino)
* ..

## Draft folder = call for contribution ##

## Examples
..

## Contributing to this project

Anyone and everyone is welcome to contribute. Please take a moment to
review the [guidelines for contributing](CONTRIBUTING.md).

* [Bug reports](CONTRIBUTING.md#bugs)
* [Feature requests](CONTRIBUTING.md#features)
* [Pull requests](CONTRIBUTING.md#pull-requests)

## Community

Keep track of development and community news.

* Follow [@EiffelWeb on Twitter](https://twitter.com/EiffelWeb).
* Follow our [page](https://plus.google.com/u/0/110650349519032194479) and [community](https://plus.google.com/communities/110457383244374256721) on Google+.
* Have a question that's not a feature request or bug report? [Ask on the mailing list.](http://groups.google.com/group/eiffel-web-framework)


For more information please have a look at the related wiki:
* https://github.com/EiffelWebFramework/EWF/wiki
