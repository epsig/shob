
#include "HeadBottom.h"

namespace shob::pages
{
    general::MultipleStrings HeadBottom::getStyleSheet()
    {
        general::MultipleStrings out;
        out.addContent("<style type=\"text/css\">");
        out.addContent(R"(body{background:white;color:black;font-family:"Verdana","Arial";font-size:9pt})");
        out.addContent("h1{font-weight:bold;font-size:12pt}h2{font-weight:bold;font-size:11pt}acronym{font:italic;cursor:help;}");
        out.addContent("th,td{font-size:9pt;padding-top:2pt;padding-bottom:2pt;padding-left:4pt;padding-right:4pt}");
        out.addContent(".h{background:navy;color:white;font-weight:bold;font-size:11pt}");
        out.addContent(".r{text-align:right}.c{text-align:center}");
        out.addContent("</style>");
        return out;
    }

    general::MultipleStrings HeadBottom::getStyleSheetKlaverjas()
    {
        general::MultipleStrings out;
        out.addContent("<style type=\"text/css\">");
        out.addContent(R"(body {background:silver; color:black; font-family:"Verdana","Arial"; font-size:12pt})");
        out.addContent("th,td {background:white; font-size:12pt; padding-top:2pt; padding-bottom:2pt; padding-left:4pt; padding-right:4pt}");
        out.addContent("input,option {font-family:\"Verdana\",\"Arial\"; font-size:12pt}");
        out.addContent("input.k {font-family:\"Courier New\",\"Courier\"; font-weight: bold; font-size:14pt}");
        out.addContent("input.b {font-family:\"Courier New\",\"Courier\"; font-weight: bold; font-size:12pt}");
        out.addContent("</style>");
        return out;
    }

    general::MultipleStrings HeadBottom::getLinkToStyleSheet()
    {
        general::MultipleStrings out;
        out.addContent(R"(<meta name="viewport" content="width=device-width, initial-scale=1">)");
        out.addContent(R"(<link rel="stylesheet" type="text/css" href="epsig.css">)");
        return out;
    }

    bookmarks::ListOfEvents HeadBottom::getFooterLinks(const general::itdate& dd)
    {
        bookmarks::ListOfEvents out;
        out.add(bookmarks::Event{ "mail-me", "reactie.html" });
        out.add(bookmarks::Event{ "homepage", "index.html" });
        out.add(bookmarks::Event{ "klaverjassen", "klaverjas_faq.html" });
        out.add(bookmarks::Event{ "sport", "sport.html" });
        out.add(bookmarks::Event{ "d.d. " + dd.toString(false) + " ", ""});
        return out;
    }

    general::MultipleStrings HeadBottom::getFooter(const general::itdate& dd, FooterStyle footerStyle, FooterSubStyle footerSubStyle)
    {
        general::MultipleStrings out;
        if (footerStyle == FooterStyle::New)
        {
            auto links = getFooterLinks(dd);
            auto content = links.printAsFooterNewStyle();
            out.addContent(content);
        }
        else if (footerStyle == FooterStyle::Old)
        {
            auto links = getFooterLinks(dd);
            auto content = links.printAsFooterOldStyle();
            out.addContent(content);
        }
        else if (footerStyle == FooterStyle::Klaverjas)
        {
            out.addContent(R"(<table width=100%> <tr>
<td width=100% align=center><table border cellspacing=0>
<tr><td><a href="javascript:NieuwSpel();">nieuw&nbsp;spel</a></td>
<td><a href="klaverjas_faq.html">settings/faq</a></td>)");

            if (footerSubStyle == FooterSubStyle::KlaverjasAdamGfx)
            {
                out.addContent(
R"(<td><a href="kj_gfx_rdam.html">rotterdams</a></td>
<td><a href="kj_txt_adam.html">tekst-only</a></td>)");
            }
            else if (footerSubStyle == FooterSubStyle::KlaverjasAdamTxt)
            {
                out.addContent(
R"(<td><a href="kj_txt_rdam.html">rotterdams</a></td>
<td><a href="kj_gfx_adam.html">met&nbsp;plaatjes</a></td>)");
            }
            else if (footerSubStyle == FooterSubStyle::KlaverjasRdamGfx)
            {
                out.addContent(
R"(<td><a href="kj_gfx_adam.html">amsterdams</a></td>
<td><a href="kj_txt_rdam.html">tekst-only</a></td>)");
            }
            else if (footerSubStyle == FooterSubStyle::KlaverjasRdamTxt)
            {
                out.addContent(
R"(<td><a href="kj_txt_adam.html">amsterdams</a></td>
<td><a href="kj_gfx_rdam.html">met&nbsp;plaatjes</a></td>)");
            }

            out.addContent(
R"(<td><a href="reactie.html">mail-me</a></td>
<td><a href="index.html">homepage</a></td>
<td><a href="sport.html">sport</a></td>
</tr>
</table>
</td> </tr> </table>)");
        }

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

        if (input.js == JavaScriptType::KlaverjasGfx || input.js == JavaScriptType::KlaverjasTxt)
        {
            out.addContent("<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">");
        }

        if (input.css == StyleSheetType::InlineForKlaverjas)
        {
            auto style = getStyleSheetKlaverjas();
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
        else if (input.js == JavaScriptType::KlaverjasGfx)
        {
            out.addContent("<script type=\"text/javascript\" language=\"javascript\" src=\"include/kj_code_gfx.js\"></script>");
        }
        else if (input.js == JavaScriptType::KlaverjasTxt)
        {
            out.addContent("<script type=\"text/javascript\" language=\"javascript\" src=\"include/kj_code_txt.js\"></script>");
        }

        out.data.back() += "</head><body>";

        if (input.copyTitleToH1)
        {
            out.addContent("<h1>" + input.title + "</h1>");
        }

        out.addContent(input.body);

        if (input.withFooter)
        {
            auto footer = getFooter(input.dd, input.footerStyle, input.footerSubStyle);
            out.addContent(footer);
        }

        if (input.js == JavaScriptType::KlaverjasGfx || input.js == JavaScriptType::KlaverjasTxt)
        {
            out.addContent("<script type=\"text/javascript\"> StartSpel(); </script>");
        }

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

