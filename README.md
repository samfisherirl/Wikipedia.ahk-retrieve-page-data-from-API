# Wikipedia.ahk - AutoHotkey v2 Class Library

This AutoHotkey library provides a convenient way to retrieve information from Wikipedia pages. It allows you to search for pages based on keywords and retrieve various details such as category, description, citations, summary, and links.

## Usage

### Prerequisites

- Include the `JXON.ahk` library in your AutoHotkey script. https://github.com/TheArkive/JXON_ahk2

### Example

```autohotkey
#Include _JXON.ahk
#Include Wikipedia.ahk
; set content header
wiki := Wikipedia() 
page := wiki.query("python coding") 
; python coding is NOT an exact match to the page title 
; this return value stores only the primary match. 
; up to 5 results will be returned with object.pages
; matches are based on keywords and not title 1:1

;source https://github.com/samfisherirl/Wikipedia.ahk-retrieve-page-data-from-API
;requires https://github.com/TheArkive/JXON_ahk2


MsgBox(page.text) ; the first result's text contents

msg := ""
for sections in wiki.pages[2].sections {
    /**
     * wiki.pages[] includes all 5 potential matchs, with best to worst order
     * page.sections or wiki.pages[2].sections returns=>
     * 
     * sections.category => "=== History ==="
     * sections.text => "Python was founded by...."
     */
    if sections.category && sections.text {
        msg .= sections.category ":`n" sections.text "`n`n`n"
    }
}
MsgBox(msg) ;prints all sections and text enumerated

MsgBox(page.links) ; this is a concaeted string but change to link_list and returns an array
enumerate_pages_returned(wiki.pages)




enumerate_pages_returned(wiki_pages){
    ;wiki.pages.ownprops()
    for page in wiki_pages {
        ; examples
        ; Msgbox(page.text)
        ; Msgbox(page.links)
        msg := Format("Match number{5} is {1}: `n{2}`n{3}`n`n{4}", page.title, page.links, page.text, A_Index)
        MsgBox(msg)
    }
}


/** Wikipedia(?headers).query("my request here") => object
 **  @return    > object.page.text
 **  @return    > object.pages[index<6].text
 * _______________________________________________
 *  @param headers user agent
 * *  @method Get >  winhttp simple request handler
 * * *  @param URL
 * *  @method query >  returns first page match, stores top matches in object
 * _______________________________________________
 *  @object  page __or__ pages[A_Index]
 *  @Prop  page.categories  "",
 *  @Prop  page.categories_list   [],
 *  @Prop  page.links   "",
 *  @Prop  page.text   "",
 *  @Prop  page.links_list   [],
 *  @Prop  page.summary   ""
 *  @Prop  page.title   page_title,
 *  @Prop  page.url   page_url
 * _______________________________________________
 * List of sections in each page = >
 * _______________________________________________
 *  @Object  object.page.sections   or   object.pages[2].sections
 *  @Prop  page.sections[A_Index].category
 *  @Returns  "=== History ==="
 *  @Prop  page.sections[A_Index].text    >   "Python was founded by...."
 *  @Returns  "Python was founded by...."
 */


```

