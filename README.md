# METEOROLOGIST

## Installation

simply `gem install 'meteorologist'` or, in your Gemfile:

`gem 'meteorologist'`

and then `require 'meteorologist'` where necessary

## Set up

You **MUST** provide the following environment variables:  

`DARKSKYSECRET`   - secret key for your [Darksky API account](https://darksky.net/dev)  
`GOOGLEMAPSECRET` - secret key for your [Google Maps API account](https://developers.google.com/maps/)

You can optionally set a cache path - this will be used to cache searched
location coordinates and limit calls made to the Google Maps API: 

`CACHE_PATH`      - path to YAML file used for location cache

## Use

```
options = {
  units: 'si', # default
  forecast_time: Time.new(2016, 2, 23) # defaults to Time.now
}
weatherman = Meteorologist.new("berlin")

weatherman.location_name
=> "Berlin, Germany"

weatherman.forecast.methods
=> [:current_summary, :current_temperature, :current_apparent_temperature,
:current_humidity, :todays_summary, :sunrise, :sunset, :moon_phase,
:minimum_temperature, :apparent_minimum_temperature, :maximum_temperature,
:apparent_maximum_temperature]

weatherman.moon.methods
=> [:illumination, :waxing?, :waning?, :phase_name, :active_elements]
```

#### Options

The `units` option defaults to `'si'`, which is metric units.  For the full list
of other available units, please see the [Darksky documentation](https://darksky.net/dev/docs/forecast)  

The `forecast_time` option can be used to get historical forecast data. It 
defaults to `Time.now`.  

#### Methods

Most of the `forecast` methods are self-explanatory.  

Both `sunrise` and `sunset` take into account the time offset given by Darksky
for the forecasted location, so they should be adjusted to local time.  

The `moon_phase` returns Darksky's phase estimation which does what it says on
the tin, but is not terribly helpful.  It's literally the percent of the cycle
complete - so 0% is the new moon, 50% is the full moon and 100% is the next new
moon.  

The `moon` method returns some helpers related to moon information:  
 * `illumination` - percent of the moon which is illuminated  
 * `waxing?`/`waning?` - boolean if the moon is waxing or waning  
 * `phase_name` - string value of the moon's current phase (new, crescent,
   first quarter, etc)  
 * `active_elements` - array of astrological elements related to the current moon phase. In the case of two elements, a transition is being made from the first element to the last.

