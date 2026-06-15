Device/simulator used + iOS version
-iPhone 17, iOS 26

Which Weather API you used + required params
-api.open-meteo.com

How you built the URL (URLComponents)
1. since the app is using lat and long to get city and weather.
    use apple native Corelocation to map the latitude and longitude to city name
2. The api call for city name input, use response target city to fetchWeather.
    urlComponenets contact endpoint with queryItems as url parameters
    for getting lattidue, longitude, current_weather and timezone.
    

MVVM structure (brief)
Models: CheckIn, Weather
Service: APIService, LocationManager
Views: PermissionView, LocationReadyView, WeatherView
MainView: ContentView

1–2 screenshots of the main UI
![App Screenshot](README_Images/log.png)
![App Screenshot](README_Images/dayWeather.png)
![App Screenshot](README_Images/nightWeather.png)



