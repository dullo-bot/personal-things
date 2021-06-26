function New-BookFromAsciiDoc
{
    <#
    .SYNOPSIS
    this function creates a human-readable file from the Github Repos of "Mastering Bitcoin" and "Mastering Ethereum"
    .DESCRIPTION
    you can create either a .pdf or an .epub-File of the Open Source Versions of the books "Mastering Bitcoin" or "Mastering Ethereum"
    the bitcoinbook-repo is a private fork, where I added some changes from open pull requests regarding formatting and wording
    to use this function, you need asciidoctor, asciidoctor-pdf and asciidoctor-epub3, which you can find via https://asciidoctor.org
    .EXAMPLE
    New-BookFromAsciiDoc -Book BTC -Medium epub -verbose

    Creates a .epub from "Mastering Bitcoin"
    .EXAMPLE
    New-BookFromAsciiDoc ETH pdf

    Creates a .pdf from "Mastering Ethereum"
    .PARAMETER Book
    Specifies the preferred book
    either BTC or ETH
    .PARAMETER Medium
    Specifies the preferred file extension
    either epub or pdf
    .NOTES
    created by: dullo-bot
    Date: 20210626
    Tested with: MacOS 11.3; PS 7.1 BTC and epub
    #>
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