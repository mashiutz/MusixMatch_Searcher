# **Mobileye HA - Wrapper for MusixMatch RestAPI**

This Git repository contains the files needed for testing the MusixMatch RestAPI wrapper,
and guidlines on how to test it.

The solution was built with PowerShell.

## **Assignment 1**

*Important notice* - The assignment requests the song to be included in an album (not a single or EP).<br />Even though i saw that MusixMatch published an endpoint that allows to request the type of the album of a song,
I did not know how to search for a word in a lyrics of a song **and** filter for the album type.

### Script Information

The script is APIScripts\APIConsumer.ps1, and it has 3 function defined:

**RestApiInvoker**

a helper function that is in charge of building the URI string for querying, and running it againts the MusixMatch API.<br /> it accepts 4 paramaters:<br /> **endpoint** - the URL of the API<br /> **query** - the query that should be passed to the endpoint <br /> **key** - key used to authenticate <br /> **method** - REST method to be used (it is GET by default, if we want to build upon it in the future, it can be changed)

**ExportResultsCsv**

a helper function that exports the data to the CSV.<br /> it accepts 2 paramaters:<br /> **Path** - Path of the CSV that the data should be exported to<br /> **Data** - The objects \ data that should be exported to the CSV

**Search-MusixMatch**

The main function that is being called, the which the user needs to "interact" with.<br />it accepts 5 paramaters:<br /> **ApiURI** - the URL of the API, being passed to RestApiInvoker. has a default value of https://api.musixmatch.com/ws/1.1/ (user can use any other URL if specifying a different value)<br /> **Lyrics** - The word that we want to search in the lyrics of songs.<br /> **ApiKey** - The API Key that is being used to authenticate with MusixMatch. It has a default value of my API key, that will be deleted in the future. **In real world situations, this should never be done**<br /> **RestApiMode** - This paramter shoulbe be used in the second assignment - basically it prevents the script from exporting to CSV<br /> **CSVPath** - the path of CSV - being passed to ExportResultsCsv. has a default value of (in Windows) C:\users\%username%\MusixMatch.csv

### Using the script

First, from a PowerShell promot, CD into the root folder of the git repo:

```language
CD C:\musixmatch
```
Next, Import the APIConsumer.ps1 script:
```language
Import-Module .\APIScripts\APIConsumer.ps1
```

*if you get an error while importing the script, run the following command:*
```language
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
```
Now run the Search-MusixMatch function:
```language
Search-MusixMatch -Lyrics "california dreamin"
```
If you want to export the CSV to a different path, desktop for example:
```language
Search-MusixMatch -Lyrics "california dreamin" -CSVPath "$env:userprofile\Desktop\MusixMatch.csv"
```
If you want to show the results in the console, use the RestApiMode switch parameter:
```language
Search-MusixMatch -Lyrics "california dreamin" -RestApiMode
```

## **Assignment 2**

Thhe docker file uses the latest alpine image, copies the Pode PowerShell module, and run the server.ps1 scripts which hosts a REST api server.
That REST api server is used to query the MusixMatch api using the Search-MusixMatch function with the -RestApiMode paramter.
run http://localhost:8088/ for more information :)