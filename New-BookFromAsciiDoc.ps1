function New-BookFromAsciiDoc {
    param (
        [Parameter(Mandatory,Position=0)]
        [ValidateSet("BTC","ETH")]
        [string]
        $Book,
        [Parameter(Mandatory,Position=1)]
        [ValidateSet("epub","pdf")]
        [string]
        $Medium
    )
    begin
    {
        switch ($Book)
        {
            "BTC"
            {
                Write-Verbose "Downloading the bitcoinbook Repo"
                Invoke-Webrequest https://github.com/dullo-bot/bitcoinbook/archive/refs/heads/develop.zip -OutFile ./zipped.zip
            }
            "ETH"
            {
                Write-Verbose "Downloading the ethereumbook Repo"
                Invoke-WebRequest https://github.com/ethereumbook/ethereumbook/archive/refs/heads/develop.zip -OutFile ./zipped.zip
            }
            Default
            {

            }
        }
        Write-Verbose "expanding the zipped archive"
        Expand-Archive ./zipped.zip
    }
    process
    {
        Set-Location ./zipped/bitcoinbook-develop/
        switch ($Book)
        {
            "BTC"
            {
                switch ($Medium)
                {
                    "pdf"
                    {
                        Write-Verbose "creating the pdf"
                        asciidoctor-pdf ./book.asciidoc
                        Copy-Item ./book.epub ../../Bitcoinbook.pdf
                    }
                    "epub"
                    {
                        Write-Verbose "creating the epub"
                        asciidoctor-epub3 ./book.asciidoc
                        Copy-Item ./book.epub ../../Bitcoinbook.epub
                    }
                }
            }
            "ETH"
            {
                switch ($Medium)
                {
                    "pdf"
                    {
                        Write-Verbose "creating the pdf"
                        asciidoctor-pdf ./book.asciidoc
                        Copy-Item ./book.epub ../../Ethereumbook.pdf
                    }
                    "epub"
                    {
                        Write-Verbose "creating the epub"
                        asciidoctor-epub3 ./book.asciidoc
                        Copy-Item ./book.epub ../../Ethereumbooks.epub
                    }
                }
            }            
        }
    }
    end
    {
        Set-Location ../..
        Write-Verbose "deleting the directory"
        Remove-Item -Recurse ./zipped -Force
        Write-Verbose "deleting the zip-File"
        Remove-Item ./zipped.zip -Force
    }
}