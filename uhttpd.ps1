function httpd([string]$prefix, [string]$path, [int]$n = 1)
{
    $httpd = new-object System.Net.HttpListener
    $httpd.Prefixes.Add($prefix.Trim());
    
    $httpd.Start()
    
    $wwwhome = new-object System.IO.DirectoryInfo $path

    for ($i = 0; $i -lt $n; $i++)
    {
        $context = $httpd.GetContext()
        $request = $context.Request
        
        write-output "received request '$($request.HttpMethod) $($request.Url)' from $($request.RemoteEndPoint)"
        
        $response = $context.Response
        
        $response.StatusCode = 200
        $response.ContentType = "text/html"
 
        # navigate to file to serve... (trim off leading slash from absolute path)
        $file = $wwwhome.GetFiles($request.Url.AbsolutePath.Substring(1))[0]
        $responseStr = get-content ($file.FullName)
        
        $buf = [System.Text.Encoding]::UTF8.GetBytes($responseStr)
        
        $response.ContentLength64 = $buf.Length
        
        $out = $response.OutputStream
        $out.Write($buf, 0, $buf.Length)
        $out.Close()
        
        $response.Close()
    }
    
    $httpd.Stop()
}
