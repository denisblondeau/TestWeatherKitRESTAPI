# TestWeatherKitRESTAPI
iOS Demo of Apple's WeatherKit REST API.

Note: This demo uses a BETA API - i.e. it may break at any time...

To get started with the WeatherKit: https://developer.apple.com/weatherkit/get-started/#attribution-requirements
Details on the REST API: https://developer.apple.com/documentation/weatherkitrestapi

You need an Apple Developer account. 

Before you can run this demo, you will need the following from your Developer account:
1) Team ID
2) Service ID
3) WeatherKit Key ID
4) A prviate key (downloaded as .p8 file)

See https://developer.apple.com/documentation/weatherkitrestapi/request_authentication_for_weatherkit_rest_api for more details.

You need to install the SwiftJWT package - needed to generate a JSON Web Token (JWT).

You will also note that this demo does not use the header id to generate the JWT - even though it is part of the WetherKit REST API requirements. However, the demo still works without that id header. That id header cannot be used with the SwiftJWT package because SwiftJWT does not accept custom headers. 
