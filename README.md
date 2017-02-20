#METEOROLOGIST

##Installation

simply `gem install 'meteorologist'` or, in your Gemfile:

`gem 'meteorologist'`

and then `require 'meteorologist'` where necessary

##Set up

You **MUST** provide the following environment variables:  

`DARKSKYSECRET`   - secret key for your [Darksky API account](https://darksky.net/dev)  
`GOOGLEMAPSECRET` - secret key for your [Google Maps API account](https://developers.google.com/maps/)

You can optionally set a cache path - this will be used to cache searched
location coordinates and limit calls made to the Google Maps API: 

`CACHE_PATH`      - path to YAML file used for location cache

##Use

```
weatherman = Meteorologist.new("berlin")

weatherman.location_name
=> "Berlin, Germany"

weatherman.forecast.methods
=> [:current_summary, :current_temperature, :current_apparent_temperature,
:current_humidity, :todays_summary, :sunrise, :sunset, :moon_phase,
:minimum_temperature, :apparent_minimum_temperature, :maximum_temperature,
:apparent_maximum_temperature]
```

Most of the `forecast` methods are self-explanatory.  

Both `sunrise` and `sunset` take into account the time offset given by Darksky
for the forecasted location, so they should be adjusted to local time.  

The `moon_phase` returns Darksky's phase estimation which does what it says on
the tin, but is not terribly helpful.  It's literally the percent of the cycle
complete - so 0% is the new moon, 50% is the full moon and 100% is the next new
moon.

```
weatherman.moon
=> nil
```

This is not yet implemented but it will include some helpers related to moon
information, such as phase name, illumination, and associated elements.
