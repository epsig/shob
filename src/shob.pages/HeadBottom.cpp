
#include "HeadBottom.h"

namespace shob::pages
{
    general::MultipleStrings HeadBottom::getStyleSheet()
    {
        general::MultipleStrings out;
        out.addContent("<style type=\"text/css\">");
        out.addContent("body{background:white;color:black;font-family:\"Verdana\",\"Arial\";font-size:9pt}");
        out.addContent("h1{font-weight:bold;font-size:12pt}h2{font-weight:bold;font-size:11pt}acronym{font:italic;cursor:help;}");
        out.addContent("th,td{font-size:9pt;padding-top:2pt;padding-bottom:2pt;padding-left:4pt;padding-right:4pt}");
        out.addContent(".h{background:navy;color:white;font-weight:bold;font-size:11pt}");
        out.addContent(".r{text-align:right}.c{text-align:center}");
        out.addContent("</style>");
        return out;
    }

    general::MultipleStrings HeadBottom::getLinkToStyleSheet()
    {
        general::MultipleStrings out;
        out.addContent("<meta name = \"viewport\" content = \"width = device-width, initial-scale = 1\">");
        out.addContent("<link rel = \"stylesheet\" type = \"text/css\" href = \"epsig.css\">");
        return out;
    }

    general::MultipleStrings HeadBottom::getFooter(const general::itdate& dd)
    {
        general::MultipleStrings out;
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

    general::MultipleStrings HeadBottom::getPage(HeadBottomInput& input)
    {
        general::MultipleStrings out;
        out.addContent("<!doctype html>");
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
        if (input.js == JavaScriptType::SortTable)
        {
            auto js = getJsSortTable();
            out.addContent(js);
        }
        out.data.back() += "</head><body>";

        out.addContent("<h1>" + input.title + "</h1>");

        out.addContent(input.body);

        auto footer = getFooter(input.dd);
        out.addContent(footer);

        out.addContent("</body></html>");

        return out;
    }

    general::MultipleStrings HeadBottom::getJsSortTable()
    {
        general::MultipleStrings out;
        out.addContent("<script type=\"text/javascript\">");
        out.addContent("function sortTable(tableId, col, headerSize, upDown) {");
        out.addContent("var table, rows, switching, i, x, y, shouldSwitch;");
        out.addContent("table = document.getElementById(tableId);");
        out.addContent("switching = true;");
        //Make a loop that will continue until no switching has been done:
        out.addContent("while (switching) {");
        //start by saying: no switching is done:
        out.addContent("switching = false;");
        out.addContent("rows = table.rows;");
        //Loop through all table rows (except the first, which contains table headers):
        out.addContent("for (i = headerSize; i < (rows.length - 1); i++) {");
        //start by saying there should be no switching:
        out.addContent("shouldSwitch = false;");
        //Get the two elements you want to compare, one from current row and one from the next:
        out.addContent("x = rows[i].getElementsByTagName(\"TD\")[col];");
        out.addContent("y = rows[i + 1].getElementsByTagName(\"TD\")[col];");
        //check if the two rows should switch place:
        out.addContent("var compare;");
        out.addContent("if (upDown == 2) { compare = (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()); }");
        out.addContent("else { compare = (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()); }");
        out.addContent("if (compare) {");
        //if so, mark as a switch and break the loop:
        out.addContent("shouldSwitch = true;");
        out.addContent("break;");
        out.addContent("}}");
        out.addContent("if (shouldSwitch) {");
        //If a switch has been marked, make the switch and mark that a switch has been done:
        out.addContent("rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);");
        out.addContent("switching = true;");
        out.addContent("}}}");
        out.addContent("</script>");
        return out;
    }
}

