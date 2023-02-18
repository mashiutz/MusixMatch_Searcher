
function RestApiInvoker ([string]$endpoint, [string]$query, [string]$key, $Method = "GET") {
# Helper function for building the URI query string and invoking it.
# Error will be thrown and fucntion will exit, if invocation failed, or if http status code is not 200
# HTTP Method is GET by default

    $QueryUriStr = $endpoint + $query + "&apikey=$key"
    Write-Host "Query URI string is $QueryUriStr"
    try {
        $response = Invoke-RestMethod -Uri $QueryUriStr -Method $Method -SkipCertificateCheck -ErrorAction Stop
        if ($response.message.header.status_code -ne 200) {
            Write-Host "Rest Invocation is done, but status code is not 200"
            throw "http status code for rest invcation - $($response.message.header.status_code)"
        }
    }
    catch {
        Write-Host "Query failed - $_"
        throw $_
    }

    Write-Output $response
}

function ExportResultsCsv ($Path, $Data) {
# Helper function for exporting to csv - will exit script if failed

    Write-Host "Exporting Information to $Path"
    try {
        $Data | Export-Csv -Path $Path -NoTypeInformation -ErrorAction Stop -Force
        Write-Host "Exporting Information to $Path - succeeded" -ForegroundColor Green
    }
    catch {
        Write-Host "Exporting Information to $Path - failed"
        $_
    }
}

# Main function to run that the user should interact with.
# All of the parameters come with default values (see annotation above parameter decleration)
# RestAPI mode is a switch paramter that is used to output the data instead of exporting to CSV (when running in a container)
function Search-MusixMatch {
    [CmdletBinding()]
    param (
        # URI / URL of the API
        [string]
        $ApiURI = "https://api.musixmatch.com/ws/1.1/",

        # Query parameters to be used
        # is "car" by default
        [string]
        $Lyrics = "car",

        # ApiKey to be used (required by the endpoint)
        # In real world situation, this will be stored in a key vault, and should not be logged or seen
        [string]
        $ApiKey = "38d33888a480c2cf0f65f8364f5578fd",

        # to be used with REST API mode - if not specified, results will be exported to CSV
        [switch]
        $RestApiMode,

        # CSV path (for assignment number 1) - by default, will be exported to the user home folder
        $CSVPath = "$home\MusixMatch.csv"
    )
        # according to assignment, query is static except the q_lyrics attribute
        $Query = "track.search?format=json&q_lyrics=$Lyrics&f_lyrics_language=en"

        # run the helper function with the query
        $MusixMatchData = RestApiInvoker -endpoint $ApiURI -query $Query -key $ApiKey
        $tracks = $MusixMatchData.message.body.track_list.track
        Write-Host "found $($tracks.count) song with lyrics: $Lyrics"

        # if used in RestAPI mode, only output the objects.
        # else, export filtered properties requested by assingnment to csv

        if ($RestApiMode) {
            # return the output
            Write-Output ($tracks | Select-Object track_name,artist_name,album_name,track_share_url)
        }
        else {
            $CSVData = $tracks | Select-Object track_name,artist_name,album_name,track_share_url
            ExportResultsCsv -Path $CSVPath -Data $CSVData
        }
        
}

# Search-MusixMatch -Lyrics "don't have a gun"
# $lyrics = "You know the one that takes you to the places where all the veins meet"
# $response = Invoke-RestMethod "https://api.musixmatch.com/ws/1.1/track.search?format=json&q_lyrics=$lyrics&f_lyrics_language=en&page_size=100&apikey=5c1c8c60f37c851d17ce06aad9025489" -Method 'GET'
# $response | ConvertTo-Json
# $response.message.body.track_list | foreach {$_.track | Select-Object track_name,artist_name,album_name,track_share_url}
# $response.message.body.track_list.count
# # "https://api.musixmatch.com/ws/1.1/album.get?format=json&callback=<string>&album_id=<string>&apikey=5c1c8c60f37c851d17ce06aad9025489"
# # "https://api.musixmatch.com/ws/1.1/track.search?format=json&q_lyrics=<string>&f_lyrics_language=en&apikei=5c1c8c60f37c851d17ce06aad9025489"