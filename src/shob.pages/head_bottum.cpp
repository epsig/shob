
#include "head_bottum.h"

namespace shob::pages
{
    general::multipleStrings headBottum::getStyleSheet()
    {
        general::multipleStrings out;
        out.addContent("<style type = \"text/css\">");
        out.addContent("body{ background:white; color:black; font-family:\"Verdana\",\"Arial\"; font-size:9pt }");
        out.addContent("h1{font-weight:bold; font - size:12pt }acronym{ font:italic; cursor:help; }");
        out.addContent("th,td{font-size:9pt; padding-top:2pt; padding-bottom:2pt; padding-left:4pt; padding-right:4pt }");
        out.addContent(".h{background:navy; color:white; font-weight:bold; font-size:11pt }");
        out.addContent(".r{text-align:right }.c{text-align:center }");
        out.addContent("</style>");
        return out;
    }

    general::multipleStrings headBottum::getLinkToStyleSheet()
    {
        general::multipleStrings out;
        out.addContent("<meta name = \"viewport\" content = \"width = device-width, initial-scale = 1\">");
        out.addContent("<link rel = \"stylesheet\" type = \"text/css\" href = \"epsig.css\">");
        return out;
    }

    general::multipleStrings headBottum::getPage(headBottumInput& input)
    {
        general::multipleStrings out;
        out.addContent("<html> <head> <title>" + input.title + "</title>");
        if (input.css == styleSheetType::inlineInHead)
        {
            auto style = getStyleSheet();
            out.addContent(style);
        }
        else
        {
            auto style = getLinkToStyleSheet();
            out.addContent(style);
        }
        out.addContent("</head> <body>");

        out.addContent("<h1>" + input.title + "</h1>");

        out.addContent(input.body);
        out.addContent("</body> </html>");

        return out;
    }
}

