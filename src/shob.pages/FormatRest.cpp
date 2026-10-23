#include "FormatRest.h"
#include "HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.general/FileIO.h"
#include <array>
#include <map>

namespace shob::pages
{
    void FormatRest::rebuildLetters() const
    {
        const auto page = getLetters();
        html::updateIfDifferent::update("../pages/anybrowser.html", page);
    }

    general::MultipleStrings FormatRest::getLetters() const
    {
        auto hb = HeadBottomInput(20261023);
        hb.title = "Te bekijken met elke browser";
        hb.body.addContent(R"(<p align="left">
<a href="http://www.anybrowser.org/campaign/">
<img src="include/anybrowser_coffee.gif" width="157" height="44"
alt="This site is best viewed from a comfortable chair with a cup of (Java) coffee" border="0">
</a></p>
Om de pagina's van mijn website te kunnen bekijken,
is alleen nodig dat je browser met tabellen en heel elementair JavaScript overweg kan
(mijn klaverjas-programma kan echt niet zonder).
<br> HTML is dan ook uitgevonden om Internet pagina's leesbaar te houden
op diverse computersystemen (Windows, Linux en Mac/Apple).
<br> Helaas lukt dat steeds minder.
<br> Bekijk daarom je website eens met een andere browser, of vraag een bekende dat te doen.
<p>
De tekens op deze pagina zijn probleemloos te gebruiken.
Let er verder op dat de symbolen &amp;, &gt;, &lt; en &quot; een aparte betekenis hebben binnen HTML.
<table border cellspacing=0>
<tr><td colspan=2> &amp;amp; = &amp; </td>
<td colspan=2> &amp;euro; = &euro; </td>
<td colspan=2> &amp;micro; = &micro; </td> </tr>
<tr><td colspan=2> &amp;gt; = &gt; </td>
<td colspan=2> &amp;pound; = &pound; </td>
<td colspan=2> &amp;para; = &para; </td> </tr>
<tr><td colspan=2> &amp;lt; = &lt; </td>
<td colspan=2> &amp;yen; = &yen; </td>
<td colspan=2> &amp;sect; = &sect; </td> </tr>
<tr><td colspan=2> &amp;quot; = &quot; </td>
<td colspan=2> &amp;curren; = &curren; </td>
<td colspan=2> &amp;deg; = &deg; </td> </tr>
<tr><td colspan=2> &amp;pi; = &pi; </td>
<td colspan=2> &amp;cent; = &cent; </td>
<td colspan=2> &amp;plusmn; = &plusmn; </td> </tr>
<tr><td colspan=6> &nbsp; </td> </tr>
<tr><td colspan=6> &amp;nbsp; = &nbsp; (non braking space) </td> </tr>
<tr><td colspan=2> &amp;copy; = &copy; </td>
<td colspan=2> &amp;reg; = &reg; </td>
<td colspan=2> &lt;sup&gt;TM&lt;/sup&gt; = <sup>TM</sup> </td> </tr>
<tr><td colspan=3> O(&lt;sup&gt;1&lt;/sup&gt;D) = O(<sup>1</sup>D) </td>
<td colspan=3> CH&lt;sub&gt;2&lt;/sub&gt;O = CH<sub>2</sub>O </td> </tr>
<tr><td colspan=2> &amp;szlig; = &szlig; </td>
<td colspan=2> &amp;aelig; = &aelig; </td>
<td colspan=2> &amp;ccedil; = &ccedil; </td> </tr>
<tr><td colspan=6> &nbsp; </td> </tr>)");

        const std::array<std::string, 6> accents = { "acute", "circ", "grave", "tilde", "uml", "slash" };
        const std::array<char, 7> letters = { 'A', 'E', 'I', 'N', 'O', 'U', 'Y' };
        const std::array<std::array<bool, 6>, 7> masks = {{
            { true, true, true, true, true, true },
            { true, true, true, false, true, false },
            { true, true, true, false, true, false },
            { false, false, false, true, false, false },
            { true, true, true, true, true, true },
            { true, true, true, false, true, false },
            { true, false, false, false, true, false }
        }};

        for (size_t i = 0; i < letters.size(); ++i)
        {
            const auto upper = letters[i];
            const auto lower = static_cast<char>(upper - 'A' + 'a');
            for (const auto letter : { upper, lower })
            {
                std::string row = "<tr>";
                for (size_t j = 0; j < accents.size(); ++j)
                {
                    if (masks[i][j])
                    {
                        const auto accent = (upper == 'A' && accents[j] == "slash") ? "ring" : accents[j];
                        const auto entity = letter + accent;
                        row += "<td> &amp;" + entity + "; = &" + entity + "; </td>";
                    }
                    else
                    {
                        row += "<td>&nbsp;</td>";
                    }
                }
                row += "</tr>";
                hb.body.addContent(row);
            }
        }
        hb.body.addContent("</table>");
        hb.css = StyleSheetType::SeparateFile;
        return HeadBottom::getPage(hb);
    }

    void FormatRest::rebuildTechDoc(const TechDocType type, const int dd) const
    {
        const auto type_str = std::map<TechDocType, std::string>{
            { TechDocType::Klaverjas, "tech_doc_kj.html" },
            { TechDocType::Shob, "tech_doc_shob.html" },
            { TechDocType::Adressen, "tech_doc_adressen.html" }
        } [type] ;

        const auto page = getTechDoc(type_str, type, dd);
        html::updateIfDifferent::update("../pages/" + type_str, page);
    }

    general::MultipleStrings FormatRest::getTechDoc(const std::string& type_str, const TechDocType type, const int dd) const
    {
        const auto title = std::map<TechDocType, std::string>{
            { TechDocType::Klaverjas, "Klaverjassen" },
            { TechDocType::Shob, "Shob" },
            { TechDocType::Adressen, "Adressen" }
        } [type] ;

        auto content = general::FileIO::readFile("doc/" + type_str);

        auto hb = HeadBottomInput(dd);
        hb.title = "Technische documentatie " + title;
        hb.css = StyleSheetType::SeparateFile;
        std::swap(hb.body, content);

        auto page = HeadBottom::getPage(hb);
        return page;
    }
}
