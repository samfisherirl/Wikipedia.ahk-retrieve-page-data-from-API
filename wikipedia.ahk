;source and examples: https://github.com/samfisherirl/Wikipedia.ahk-retrieve-page-data-from-API
;requires https://github.com/TheArkive/JXON_ahk2

/** Wikipedia(?headers).query("my request here") => object
 **  @return    > object.page.text
 **  @return    > object.pages[index<6].text
 * _______________________________________________
 *  @param headers user agent
 * *  @method Get >  winhttp simple request handler
 * * *  @param URL
 * *  @method query >  returns first page match, stores top matches in object
 * _______________________________________________
 *  @object  page
 *  @Prop  page.categories  "",
 *  @Prop  page.categories_list   [],
 *  @Prop  page.links   "",
 *  @Prop  page.text   "",
 *  @Prop  page.links_list   [],
 *  @Prop  page.summary   ""
 *  @Prop  page.title   page_title,
 *  @Prop  page.url   page_url
 *  @Prop  page.sections[1].category, 
 *  @Prop  page.sections[1].text
 * _______________________________________________
 * List of sections in each page = >
 * _______________________________________________
 *  @Object  object.page.sections   or   object.pages[2].sections
 *  @Prop  page.sections[A_Index].category
 *  @Returns  "=== History ==="
 *  @Prop  page.sections[A_Index].text    >   "Python was founded by...."
 *  @Returns  "Python was founded by...."
 */
Class Wikipedia
{
    __New(
     /** Wikipedia(?headers).query("my request here") => object
     ** return => this.object.page.text
     ** return => object.pages[index<6].text
     * _______________________________________________
     * @param headers user agent
     * * @method Get =>  winhttp simple request handler
     * * * @param URL
     * * @method query =>  returns first page match, stores top matches in object
     * _______________________________________________
     */
        headers := "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"
    )
    {
        /**
        */
        this.url := "https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch={1}&srprop=size&srlimit=5"
        this.headers := headers
        this.first_match_storage := ""
        this.matches := Map()
        this.page := ""
        this.pages := []
    }
    Get(url)
    {
        https := ComObject("WinHttp.WinHttpRequest.5.1")
        https.Open("GET", url, false)
        https.SetRequestHeader("User-Agent", Trim(this.headers))
        https.Send()
        https.WaitforResponse()
        try {
            this.response := https.ResponseText
        }
        catch {
            this.response := false
        }
        return this.response
    }
    query(keywords)
    {
        this.url := Format("https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch={1}&srprop=size&srlimit=5", keywords)
        response := this.Get(this.url)
        if InStr(this.response, "query") && InStr(this.response, "search")
        {
            jdata := Jxon_Load(&response)
            results := jdata["query"]["search"]
            if results {
                this.first_match_storage := false
                for result in results 
                {
                    page_title := result["title"]
                    page_title := StrReplace(page_title, " ", "_")
                    page_url := "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts|categories|extlinks&explaintext=True&titles=" page_title "&format=json"
                    this.matches.Set(page_title, page_url)
                    response := this.Get(page_url)
                    jdata := Jxon_Load(&response)
                    this.segment_page(jdata, page_title, page_url)
                }
                return this.page
            }
        }
    }
    segment_page(jdata, page_title, page_url)
    {
        for pageID, val in jdata['query']['pages']
            {
                page_data := jdata['query']['pages'][pageID]
                page := {
                    categories_list: [],
                    links: "",
                    text: "",
                    links_list: [],
                    summary: "",
                    ;sections := [],
                    title: page_title,
                    url: page_url
                }
                page.text := page_data['extract']
                if page_data["categories"]
                {
                    categories := page_data["categories"]
                    for category in categories {
                        page.categories_list.Push(category["title"])
                    }
                }
                if page_data["extlinks"]
                {
                    extlinks := page_data["extlinks"]
                    for extlink in extlinks {
                        page.links_list.Push(extlink["*"])
                        page.links .= extlink["*"] "`n"
                    }
                }
                page.summary := this.retieve_summary(page_title)
                if not page.summary
                {
                    if InStr(page.text, "`n`n") {
                        page.summary := StrSplit(page.text, "`n`n")[1]
                    }
                }
                if not (this.first_match_storage)
                {
                    this.first_match_storage := page_data['extract']
                    this.page := page
                }
                page.sections := this.segment_sections(page.text)
                if (page.links != "") && (page.text != "") && (page.sections != [])
                {
                    this.pages.Push(page)
                }
            }
    }
    retieve_summary(page_title) 
    {
        response := this.Get(
            Format(
                "https://en.wikipedia.org/api/rest_v1/page/summary/{1}",
                page_title
            ))
        if response {
            data := Jxon_Load(&response)
            if data["extract"] {
                return data["extract"]
            }
        }
    }
    segment_sections(page_text)
    {
        between_linebreaks := StrSplit(page_text, "`n`n`n")
        first_line := 0
        categories := []
        for line in between_linebreaks {
            section := {
                category: "",
                text: ""
            }
            if InStr(line, "==") {
                split_line := StrSplit(line, "=")
                i := split_line.Length
                section.text := StrReplace(split_line[split_line.Length], "`n", " ")
                section.text := Trim(section.text)
                loop i {
                    if A_Index < i {
                        section.category .= split_line[A_Index]
                    }
                }
                if StrLen(section.category) > 100 {
                    continue
                }
                section.category := Trim(section.category)
                if section.category != "" && section.text != "" {
                    categories.Push(section)
                }
            }
        }
        return categories
    }
}


;response := https.request(StrReplace(url, " ", "%20"))
;response := http.request(url)
