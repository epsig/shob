#include "TestFormatRest.h"
#include "../shob.pages/FormatRest.h"
#include <gtest/gtest.h>

namespace shob::pages::test
{
    void TestFormatRest::testLettersPage()
    {
        const auto page = shob::pages::FormatRest("").getLetters();
        EXPECT_GE(page.findString("<title>Te bekijken met elke browser</title>"), 0);
        EXPECT_GE(page.findString("<h1>Te bekijken met elke browser</h1>"), 0);
        EXPECT_GE(page.findString("23 okt 2026"), 0);
        EXPECT_GE(page.findString("href=\"reactie.html\""), 0);
        EXPECT_GE(page.findString("include/anybrowser_coffee.gif"), 0);
        EXPECT_GE(page.findString("Windows, Linux en Mac/Apple"), 0);
        EXPECT_GE(page.findString("&lt;sup&gt;TM&lt;/sup&gt; = <sup>TM</sup>"), 0);
        EXPECT_GE(page.findString("CH&lt;sub&gt;2&lt;/sub&gt;O = CH<sub>2</sub>O"), 0);
        for (const auto entity : { "amp", "euro", "micro", "gt", "pound", "para", "lt", "yen",
            "sect", "quot", "curren", "deg", "pi", "cent", "plusmn", "nbsp", "copy", "reg",
            "szlig", "aelig", "ccedil" })
        {
            EXPECT_GE(page.findString(std::string("&amp;") + entity + "; = &" + entity + ";"), 0)
                << entity;
        }
        EXPECT_GE(page.findString("</body></html>"), 0);
    }

    void TestFormatRest::testLettersEntityRows()
    {
        const auto page = shob::pages::FormatRest("").getLetters().toString();
        const std::vector<std::vector<std::string>> expected = {
            { "Aacute", "Acirc", "Agrave", "Atilde", "Auml", "Aring" },
            { "aacute", "acirc", "agrave", "atilde", "auml", "aring" },
            { "Eacute", "Ecirc", "Egrave", "", "Euml", "" },
            { "eacute", "ecirc", "egrave", "", "euml", "" },
            { "Iacute", "Icirc", "Igrave", "", "Iuml", "" },
            { "iacute", "icirc", "igrave", "", "iuml", "" },
            { "", "", "", "Ntilde", "", "" },
            { "", "", "", "ntilde", "", "" },
            { "Oacute", "Ocirc", "Ograve", "Otilde", "Ouml", "Oslash" },
            { "oacute", "ocirc", "ograve", "otilde", "ouml", "oslash" },
            { "Uacute", "Ucirc", "Ugrave", "", "Uuml", "" },
            { "uacute", "ucirc", "ugrave", "", "uuml", "" },
            { "Yacute", "", "", "", "Yuml", "" },
            { "yacute", "", "", "", "yuml", "" }
        };

        auto position = page.find("<tr><td> &amp;Aacute;");
        ASSERT_NE(position, std::string::npos);
        for (const auto& entities : expected)
        {
            std::string row = "<tr>";
            for (const auto& entity : entities)
            {
                row += entity.empty() ? "<td>&nbsp;</td>"
                    : "<td> &amp;" + entity + "; = &" + entity + "; </td>";
            }
            row += "</tr>";
            EXPECT_EQ(page.substr(position, row.size()), row);
            position += row.size();
            position = page.find_first_not_of("\r\n", position);
            ASSERT_NE(position, std::string::npos);
        }
        EXPECT_EQ(page.substr(position, 8), "</table>");
    }
}
