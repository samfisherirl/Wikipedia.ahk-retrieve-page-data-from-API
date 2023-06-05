# Wikipedia AutoHotkey Library

This AutoHotkey library provides a convenient way to retrieve information from Wikipedia pages. It allows you to search for pages based on keywords and retrieve various details such as category, description, citations, summary, and links.

## Installation

To use this library, you'll need to have AutoHotkey installed. You can download and install AutoHotkey from the official website: [AutoHotkey](https://www.autohotkey.com/)

## Usage

### Prerequisites

- Include the `JXON.ahk` library in your AutoHotkey script.

### Example

```autohotkey
#Include JXON.ahk
; Set content header
wiki := Wikipedia("python coding") ; "python coding" is NOT an exact match to the page title
page := wiki.query()

MsgBox(page.text) ; The first result's text contents
MsgBox(page.categories) ; This is a concatenated string; change to category_list to return an array
MsgBox(page.links) ; This is a concatenated string; change to link_list to return an array
EnumeratePagesReturned(wiki.pages)

EnumeratePagesReturned(wiki_pages) {
    ; wiki.pages.ownprops()
    for page in wiki_pages {
        ; Examples
        ; MsgBox(page.text)
        ; MsgBox(page.links)
        msg := Format("{1}:\n{2}\n{3}\n\n{4}", page.title, page.links, page.categories, page.text)
        MsgBox(msg)
    }
}

; Wikipedia class definition
Class Wikipedia {
    ; Constructor
    __New(keywords, headers := "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36") {
        ; Implementation details...
    }

    ; Methods...
}

