---
layout: post
title: Document Scanning Workflow with ImageMagick and Canon MX922 Scanner
comments: true
---

I have a WLAN scanner Canon MX922. It has a document feeder on the top that can take multiple pages. The default Windows scanner application 
revert every other page. Installing the [MX920 series MP Drivers and software][driver] from Canon solved the issue.

If the pages are scanned as JPEGs, they can be merged into PDF with ImageMagick:

    convert "*.jpg" output.pdf
    
To avoid naming conflict with Windows builtin filesystem conversion tool (`convert.exe`), I renamed ImageMagick tool to `convertimg.exe`.

Note the Canon scan utility is able to output PDF directly. But I like separte images files since I like to feed in several multi-page
documents at once, and I don't like to have them mixed into a single PDF.

If the images have their orientations adjusted in Windows File Explorer by setting EXIF info, the above command does not respect the 
orientation setting. Instead, use the below command:

    convert "*.jpg" -auto-orient output.pdf
    
There is also a PDF utility command line tool called PDFtk, more specificaly [PDFtk server][PDFtkServer]. It's open source and seems to be of good quality
and have a large user base. I might want to add it to my toolkit in the future, but for this scanning scenario, I don't need it yet.

[driver]: https://www.usa.canon.com/internet/portal/us/home/support/details/printers/inkjet-multifunction/mx-series-inkjet/mx922
[PDFtkServer]: https://www.pdflabs.com/tools/pdftk-server/
