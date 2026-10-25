#include "TestFormatRest.h"
#include "../shob.pages/FormatRest.h"
#include "../shob.general/shobException.h"
#include <chrono>
#include <filesystem>
#include <fstream>
#include <gtest/gtest.h>

namespace shob::pages::test
{
    namespace
    {
        class FormatRestStats : public ::testing::Test
        {
        protected:
            std::filesystem::path folder;
            bool ownsFolder = false;

            void SetUp() override
            {
                folder = std::filesystem::temp_directory_path() / ("shob-format-rest-stats-" +
                    std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
                ownsFolder = std::filesystem::create_directory(folder);
                ASSERT_TRUE(ownsFolder);
            }

            void TearDown() override
            {
                if (ownsFolder) std::filesystem::remove_all(folder);
            }

            void writeStats(const std::filesystem::path& relativePath, int days,
                const std::string& month = "Jan", int year = 2003)
            {
                const auto path = folder / relativePath;
                std::filesystem::create_directories(path.parent_path());
                std::ofstream file(path);
                ASSERT_TRUE(file.is_open());
                for (int day = 1; day <= days; ++day)
                {
                    file << day << " " << month << " " << year << "\n";
                }
                file << "traffickb = 1048576.0;\n"
                    << "http://epsig.nl/index.html 100000 (1.0Kb)\n"
                    << "HTTP://epsig.nl/SPORT.html 20000 (1.0KB)\n"
                    << "http://epsig.nl/kj_code.html 30000 (1.0Kb)\n"
                    << "http://epsig.nl/include/kj_code.js 40000 (1.0Kb)\n"
                    << "http://epsig.nl/sport.JPG 50000 (1.0Kb)\n"
                    << "http://epsig.nl/image.gif 10000 (1.0Kb)\n"
                    << "http://epsig.nl/favicon.ico 10000 (1.0Kb)\n"
                    << "http://epsig.nl/robots.txt 10000 (1.0Kb)\n";
                file.close();
                ASSERT_TRUE(file.good());
            }
        };
    }

    TEST_F(FormatRestStats, FullMonthAndFilters)
    {
        writeStats(std::filesystem::path("2003") / "stats_epsig_Jan2003.txt", 20);
        const auto page = FormatRest(folder.string()).getStats(20031231);
        EXPECT_GE(page.findString("<title>stats www.epsig.nl</title>"), 0);
        EXPECT_GE(page.findString("20 jan 2003"), 0);
        EXPECT_GE(page.findString("<tr><td>Jan 2003</td><td>1.00 Gb</td><td>0.27</td>"
            "<td>150000</td><td>70000</td><td>20000</td></tr>"), 0);
        EXPECT_GE(page.findString("pageviews klaverjassen"), 0);
        EXPECT_GE(page.findString("*: en voorganger www.xs4all.nl/~spee t/m mei 2005."), 0);
        EXPECT_GE(page.findString("<p>italic: cijfers aangepast vanwege ontbrekende dagen."), 0);
        EXPECT_GE(page.findString("href=\"reactie.html\""), 0);
        EXPECT_GE(page.findString("</body></html>"), 0);
    }

    TEST_F(FormatRestStats, FilenameFallbacksOrderingAndYearLimit)
    {
        writeStats(std::filesystem::path("2003") / "stats_epsig_Jan2003.txt", 20);
        writeStats(std::filesystem::path("2003") / "stats_Jan2003.txt", 10);
        writeStats("stats_epsig_Jan2003.txt", 10);
        writeStats("stats_Jan2003.txt", 10);
        writeStats(std::filesystem::path("2003") / "stats_Feb2003.txt", 10, "feb");
        writeStats("stats_epsig_Feb2003.txt", 20, "Feb");
        writeStats("stats_epsig_Mar2003.txt", 19, "Mar");
        writeStats("stats_Mar2003.txt", 20, "Mar");
        writeStats("stats_Apr2003.txt", 1, "Apr");
        writeStats(std::filesystem::path("2004") / "stats_epsig_Jan2004.txt", 20, "Jan", 2004);
        const auto page = FormatRest(folder.string()).getStats(20030101);
        const auto january = page.findString("<tr><td>Jan 2003</td><td>1.00 Gb</td><td>0.27</td>");
        const auto february = page.findString("<tr><td>Feb 2003</td><td>3.00 Gb</td><td>0.81</td>"
            "<td><i>450000</i></td><td><i>210000</i></td><td><i>60000</i></td></tr>");
        const auto march = page.findString("<tr><td>Mar 2003</td><td>1.58 Gb</td><td>0.43</td>"
            "<td><i>236842</i></td><td><i>110526</i></td><td><i>31579</i></td></tr>");
        const auto april = page.findString("<tr><td>Apr 2003</td><td>30.00 Gb</td><td>8.10</td>");
        ASSERT_GE(april, 0);
        EXPECT_GT(march, april);
        EXPECT_GT(february, march);
        EXPECT_GT(january, february);
        EXPECT_EQ(page.findString("Jan 2004"), -1);
        EXPECT_GE(page.findString("1 apr 2003"), 0);
    }

    TEST_F(FormatRestStats, MissingMonths)
    {
        const auto page = FormatRest(folder.string()).getStats(20031231);
        EXPECT_GE(page.findString("pageviews total"), 0);
        EXPECT_EQ(page.findString("<tr><td>Jan 2003"), -1);
        EXPECT_GE(page.findString("</body></html>"), 0);
    }

    TEST_F(FormatRestStats, RejectsFilesWithoutDailyDates)
    {
        writeStats("stats_Jan2003.txt", 0);
        EXPECT_THROW(FormatRest(folder.string()).getStats(20031231), general::shobException);
    }

    TEST_F(FormatRestStats, RejectsInvalidDates)
    {
        writeStats("stats_Feb2003.txt", 30, "Feb");
        EXPECT_THROW(FormatRest(folder.string()).getStats(20031231), general::shobException);
    }

    void TestFormatRest::testAsciiCodes()
    {
        const auto page = FormatRest("").getAsciiCodes();
        EXPECT_GE(page.findString("<title>Ascii codes in HTML</title>"), 0);
        EXPECT_GE(page.findString("<h1>Ascii codes in HTML</h1>"), 0);
        EXPECT_GE(page.findString("23 okt 2026"), 0);
        EXPECT_GE(page.findString("href=\"reactie.html\""), 0);
        EXPECT_GE(page.findString("</body></html>"), 0);

        const auto tableStart = page.findString("<table border cellspacing=0>");
        ASSERT_GE(tableStart, 0);
        const auto start = static_cast<size_t>(tableStart);
        ASSERT_GT(page.data.size(), start + 25);
        EXPECT_EQ(page.data[start], "<table border cellspacing=0>");
        EXPECT_EQ(page.data[start + 1], "<tr><th colspan=\"10\" class=h>escape codes</th></tr>");

        for (int row = 0; row < 23; ++row)
        {
            std::string expected = "<tr>";
            for (int column = 0; column < 10; ++column)
            {
                const auto code = 30 + 10 * row + column;
                expected += "<td>" + std::to_string(code) + ": ";
                if (code >= 33 && code <= 255)
                {
                    expected += "&#" + std::to_string(code) + ";";
                }
                else
                {
                    expected += "&nbsp;";
                }
                expected += "</td>";
            }
            expected += "</tr>";
            EXPECT_EQ(page.data[start + 2 + row], expected) << "row " << row;
        }
        EXPECT_EQ(page.data[start + 25], "</table>");
    }

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
