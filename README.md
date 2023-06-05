# Wikipedia AutoHotkey Library

This AutoHotkey library provides a convenient way to retrieve information from Wikipedia pages. It allows you to search for pages based on keywords and retrieve various details such as category, description, citations, summary, and links.

## Usage

### Prerequisites

- Include the `JXON.ahk` library in your AutoHotkey script. https://github.com/TheArkive/JXON_ahk2

### Example

```autohotkey
#Include JXON.ahk
#Include Wikipedia.ahk
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
        /*
        page := {
                @Prop categories : "",
                @Prop category_list: [],
                @Prop links: "",
                @Prop text: "",
                @Prop link_list: [],
                @Prop summary: ""
                @Prop title: page_title,
                @Prop url: page_url
        }
        */

        msg := Format("{1}:\n{2}\n{3}\n\n{4}", page.title, page.links, page.categories, page.text)
        MsgBox(msg)
    }
}

```

