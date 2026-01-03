
#include "HeadBottom.h"

namespace shob::pages
{
    general::multipleStrings HeadBottom::getStyleSheet()
    {
        general::multipleStrings out;
        out.addContent("<style type=\"text/css\">");
        out.addContent("body{background:white;color:black;font-family:\"Verdana\",\"Arial\";font-size:9pt}");
        out.addContent("h1{font-weight:bold;font-size:12pt}h2{font-weight:bold;font-size:11pt}acronym{font:italic;cursor:help;}");
        out.addContent("th,td{font-size:9pt;padding-top:2pt;padding-bottom:2pt;padding-left:4pt;padding-right:4pt}");
        out.addContent(".h{background:navy;color:white;font-weight:bold;font-size:11pt}");
        out.addContent(".r{text-align:right}.c{text-align:center}");
        out.addContent("</style>");
        return out;
    }

    general::multipleStrings HeadBottom::getLinkToStyleSheet()
    {
        general::multipleStrings out;
        out.addContent("<meta name = \"viewport\" content = \"width = device-width, initial-scale = 1\">");
        out.addContent("<link rel = \"stylesheet\" type = \"text/css\" href = \"epsig.css\">");
        return out;
    }

    general::multipleStrings HeadBottom::getFooter(const general::itdate& dd)
    {
        general::multipleStrings out;
        out.addContent("<table width=100%> <tr> <td width=10%>&nbsp;</td>");
        out.addContent("<td width=80% align=center><table border cellspacing=0>");
        out.addContent("<tr><td><a href=\"reactie.html\">mail-me</a></td> ");
        out.addContent("<td><a href=\"index.html\">homepage</a></td> ");
        out.addContent("<td><a href=\"klaverjas_faq.html\">klaverjassen</a></td> ");
        out.addContent("<td><a href=\"sport.html\">sport</a></td> ");
        out.addContent("<td>d.d. " + dd.toString(false) + " </td> </tr> ");
        out.addContent("</table> ");
        out.addContent("</td> <td width=10%>&nbsp;</td> </tr> </table>");

        return out;
    }

    general::multipleStrings HeadBottom::getPage(HeadBottomInput& input)
    {
        general::multipleStrings out;
        out.addContent("<html lang=\"NL\"><head><title>" + input.title + "</title>");
        if (input.css == StyleSheetType::InlineInHead)
        {
            auto style = getStyleSheet();
            out.addContent(style);
        }
        else
        {
            auto style = getLinkToStyleSheet();
            out.addContent(style);
        }
        out.data.back() += "</head><body>";

        out.addContent("<h1>" + input.title + "</h1>");

        out.addContent(input.body);

        auto footer = getFooter(input.dd);
        out.addContent(footer);

        out.addContent("</body></html>");

        return out;
    }
}

