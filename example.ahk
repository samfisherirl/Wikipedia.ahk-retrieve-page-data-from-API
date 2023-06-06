#Include _JXON.ahk
#Include Wikipedia.ahk
; set content header
wiki := Wikipedia() 
page := wiki.query("python coding") ;python coding is NOT an exact match to the page title 
    ; this return value stores only the primary match. 
    ; up to 5 results will be returned with object.pages
    ; matches are based on keywords and not title 1:1
    ;     page := {
    ;             @Prop categories : "",
    ;             @Prop category_list: [],
    ;             @Prop links: "",
    ;             @Prop text: "",
    ;             @Prop link_list: [],
    ;             @Prop summary: ""
    ;             @Prop title: page_title,
    ;             @Prop url: page_url
    ;     }

MsgBox(page.text) ; the first result's text contents
MsgBox(page.categories) ; this is a concaeted string but change to category_list and returns an array
MsgBox(page.links) ; this is a concaeted string but change to link_list and returns an array
enumerate_pages_returned(wiki.pages)


enumerate_pages_returned(wiki_pages){
    ;wiki.pages.ownprops()
    for page in wiki_pages {
        ; examples
        ; Msgbox(page.text)
        ; Msgbox(page.links)
        msg := Format("Match number{5} is {1}: `n{2}`n{3}`n`n{4}", page.title, page.links, page.categories, page.text, A_Index)
        MsgBox(msg)
    }
}
