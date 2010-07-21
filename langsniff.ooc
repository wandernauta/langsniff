import structs/[ArrayList, HashMap]
import words/[English, Esperanto, French, German, Italian, Spanish, Dutch, Hungarian]
import text/StringTokenizer
import io/File

main: func(args: ArrayList<String>) {
    langs := HashMap<String, ArrayList<String>> new(7)
    
    langs put("English", English as ArrayList<String>)
    langs put("Esperanto", Esperanto as ArrayList<String>)
    langs put("French", French as ArrayList<String>)
    langs put("German", German as ArrayList<String>)
    langs put("Italian", Italian as ArrayList<String>)
    langs put("Spanish", Spanish as ArrayList<String>)
    langs put("Dutch", Dutch as ArrayList<String>)                
    langs put("Hungarian", Hungarian as ArrayList<String>)     
    langnames := langs getKeys()
    
    if (args size() < 2) { "Usage: langsniff FILE" println(); exit(0); }
    
    /* 
    "This is %s, analyzing with %d word lists:" printfln(args[0] split("/") toList() last(), langs size())
    for (lang in langnames) { "- %s (built-in)" printfln(lang, langs[lang] size()) }
    */
    
    /* Set up scoring */
    
    scores := HashMap<String, Int> new()
    for (lang in langnames) { scores[lang] = 0; }
    
    /* Run the 'algorithm' */
    
    words := File new(args[1]) read() split(" ")
    wc := 0
    
    for (word in words) {
        word = word toLower()
        for (lang in langnames) {
            curlang := langs[lang] as ArrayList<String>
            for (lword in curlang) {
                if (lword == word) {
                    scores[lang] = scores[lang] + (100 - curlang indexOf(lword))
                }
            }
        }
        wc += 1
    }
    
    // ^ Heh 'algorithm' makes it sound all high-tech
    
    /* Sort the outputs */
    
    highestscore := 0
    highestlang := "Unknown"
    
    for (lang in scores getKeys()) {
        if (scores[lang] > highestscore) {
            highestscore = scores[lang]
            highestlang = lang
        }
    }
    
    /* Output the results */

    "Identified %s as %s (with %d pts or %d pts/word)" printfln(args[1], highestlang, highestscore, (highestscore/wc))
}
