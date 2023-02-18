# Import apiserver module
Import-Module -Name Pode
# Import MusixMatch wrapper script
Write-PodeHost "Importing Functions from APIConsumer Script"
Import-Module .\APIConsumer.ps1

Start-PodeServer {
    Add-PodeEndpoint -Address 0.0.0.0 -Port 8088 -Protocol Http

    Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
        Write-PodeHost "Get method was called on endpoint /"
        $response = @"
Welcome to MusixMatch lyrics searcher!
Please use it throgh a browser, or curl, as follows:

To get a list of 10 songs with the word `'california dreamin`' in the lyrics:

http://localhost:8088/Lyrics?California dreamin
"@
        Write-PodeTextResponse -Value $response
    }

    Add-PodeRoute -Method Get -Path '/Lyrics?:query' -ScriptBlock {
        $LyricsQuery = $($WebEvent.Parameters.query)
        Write-PodeHost "Get method was called on endpoint /Lyrics with the following paramter: $LyricsQuery"
        $response = Search-MusixMatch -RestApiMode -Lyrics $LyricsQuery
        Write-PodeHtmlResponse $response
    }
}