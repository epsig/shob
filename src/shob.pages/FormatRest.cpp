#include "FormatRest.h"
#include "HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.general/FileIO.h"
#include "../shob.html/table.h"
#include "../shob.general/shobException.h"
#include <algorithm>
#include <array>
#include <cctype>
#include <cmath>
#include <filesystem>
#include <format>
#include <fstream>
#include <map>
#include <regex>

namespace shob::pages
{
    using namespace shob::general;
    using namespace shob::html;

    void FormatRest::rebuildAsciiCodes() const
    {
        const auto page = getAsciiCodes();
        html::updateIfDifferent::update("../pages/tmp_ascii_codes.html", page);
    }

    general::MultipleStrings FormatRest::getAsciiCodes() const
    {
        html::tableContent content;
        content.title = "escape codes";
        for (int i = 3; i < 26; ++i)
        {
            general::MultipleStrings row;
            for (int j = 0; j < 10; ++j)
            {
                const auto code = 10 * i + j;
                const auto character = (code <= 32 || code > 255)
                    ? "&nbsp;" : "&#" + std::to_string(code) + ";";
                row.addContent(std::to_string(code) + ": " + character);
            }
            content.body.push_back(std::move(row));
        }

        auto settings = html::settings();
        settings.isCompatible = true;
        auto hb = HeadBottomInput(20261023);
        hb.title = "Ascii codes in HTML";
        hb.css = StyleSheetType::SeparateFile;
        hb.body = html::table(settings).buildTable(std::vector<html::tableContent>{ content });
        return HeadBottom::getPage(hb);
    }

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

    void FormatRest::rebuildEpsig(const int dd) const
    {
        const auto page = getEpsig(dd);
        html::updateIfDifferent::update("../pages/epsig.html", page);
    }

    general::MultipleStrings FormatRest::getEpsig(const int dd) const
    {
        auto content = general::MultipleStrings();
        content.addContent(R"(
epsig = eps + sig (zonder dubbele s)
<br> eps = epsilon = Griekse e; e = eerste letter van Edwin
<br> sig = sigma = Griekse s; s = eerste letter van Spee
<p>
Het was in 2005 &eacute;&eacute;n van de weinige vrije domeinnamen met weinig letters
en nog uit te spreken ook.
<p>
Verder worden epsilon en sigma veel gebruikt in <a href="cv.html">mijn vakgebied</a>.
<p>
Geinig, toch?
<p>
Edwin Spee
<br>webmaster www.epsig.nl.
<p> &nbsp;
)");

        auto hb = HeadBottomInput(dd);
        hb.title = "Hoezo, epsig?";
        hb.css = StyleSheetType::SeparateFile;

        hb.copyTitleToH1 = false;
        hb.footerStyle = FooterStyle::New;
        hb.body = table::yellowRed(content, hb.title);

        auto page = HeadBottom::getPage(hb);
        return page;
    }

    void FormatRest::rebuildStats(const int dd) const
    {
        const auto page = getStats(dd);
        html::updateIfDifferent::update("../pages/stats.html", page);
    }

    general::MultipleStrings FormatRest::getStats(const int dd) const
    {
        const std::array<std::string, 12> months = {
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        };
        const std::regex datePattern(R"(^ *(\d+) ([A-Za-z]{3}) (\d{4}))", std::regex::icase);
        const std::regex trafficPattern(R"(traffickb = (\d+\.\d);)", std::regex::icase);
        const std::regex hitPattern(R"((http\S*)\s+(\d+)\s*\((\d+.\d)Kb\))", std::regex::icase);
        const std::regex excludedPattern("include|jpg|gif|ico|robots", std::regex::icase);
        const std::regex sportPattern("sport", std::regex::icase);
        const std::regex klaverjasPattern("kj_code", std::regex::icase);

        tableContent stats;
        stats.header.data = { "periode", "traffic", "M hits", "pageviews total",
            "pageviews klaverjassen", "pageviews sport" };
        int lastDate = -1;
        const auto root = std::filesystem::path(data_folder);
        for (int year = 2003; year <= dd / 10000; ++year)
        {
            for (const auto& month : months)
            {
                const auto suffix = month + std::to_string(year) + ".txt";
                const std::array<std::filesystem::path, 4> paths = {
                    root / std::to_string(year) / ("stats_epsig_" + suffix),
                    root / std::to_string(year) / ("stats_" + suffix),
                    root / ("stats_epsig_" + suffix),
                    root / ("stats_" + suffix)
                };
                std::ifstream input;
                std::filesystem::path filename;
                for (const auto& path : paths)
                {
                    input.open(path);
                    if (input.is_open())
                    {
                        filename = path;
                        break;
                    }
                    if (std::filesystem::exists(path))
                    {
                        throw shobException("Cannot read statistics file: " + path.string());
                    }
                    input.clear();
                }
                if (!input.is_open()) continue;

                int days = 0;
                double traffic = 0;
                double hits = 0;
                std::array<long long, 3> pageviews = {};
                std::string line;
                std::smatch match;
                while (std::getline(input, line))
                {
                    if (std::regex_search(line, match, datePattern))
                    {
                        const auto dateMonthName = match[2].str();
                        const auto monthIt = std::find_if(months.begin(), months.end(),
                            [&](const std::string& name) {
                                return std::equal(name.begin(), name.end(), dateMonthName.begin(),
                                    [](unsigned char left, unsigned char right) {
                                        return std::tolower(left) == std::tolower(right);
                                    });
                            });
                        if (monthIt == months.end())
                        {
                            throw shobException("Invalid date in statistics file: " + filename.string());
                        }
                        const auto day = std::stoi(match[1].str());
                        const auto dateYear = std::stoi(match[3].str());
                        const auto dateMonth = static_cast<int>(monthIt - months.begin()) + 1;
                        if (day < 1 || day > static_cast<int>(shobDate::maxDays(dateYear, dateMonth)))
                        {
                            throw shobException("Invalid date in statistics file: " + filename.string());
                        }
                        lastDate = dateYear * 10000 + dateMonth * 100 + day;
                        ++days;
                    }
                    else if (std::regex_search(line, match, trafficPattern))
                    {
                        traffic = std::stod(match[1].str()) / (1024 * 1024);
                    }
                    else if (std::regex_search(line, match, hitPattern))
                    {
                        const auto url = match[1].str();
                        const auto count = std::stoll(match[2].str());
                        hits += count;
                        if (!std::regex_search(url, excludedPattern))
                        {
                            pageviews[0] += count;
                            if (std::regex_search(url, sportPattern)) pageviews[2] += count;
                        }
                        if (std::regex_search(url, klaverjasPattern)) pageviews[1] += count;
                    }
                }
                if (input.bad())
                {
                    throw shobException("Cannot read statistics file: " + filename.string());
                }
                if (days == 0)
                {
                    throw shobException("No daily dates in statistics file: " + filename.string());
                }

                hits *= 1e-6;
                const bool estimated = days < 20;
                const double scale = estimated ? 30.0 / days : 1.0;
                MultipleStrings row;
                row.data = { month + " " + std::to_string(year),
                    std::format("{:.2f} Gb", traffic * scale), std::format("{:.2f}", hits * scale) };
                for (const auto count : pageviews)
                {
                    const auto value = estimated
                        ? std::to_string(static_cast<long long>(std::floor(0.5 + count * scale)))
                        : std::to_string(count);
                    row.addContent(estimated ? "<i>" + value + "</i>" : value);
                }
                stats.body.push_back(std::move(row));
            }
        }
        std::reverse(stats.body.begin(), stats.body.end());

        MultipleStrings content;
        content.addContent(R"(De website www.epsig.nl <sup>*</sup>
haalt de volgende hoeveelheid hits (dat is inclusief plaatjes) en pageviews:
<p>&nbsp;)");
        auto settings = html::settings();
        settings.isCompatible = true;
        auto statsTable = table(settings).buildTable(stats);
        content.addContent(statsTable);
        content.addContent("*: en voorganger www.xs4all.nl/~spee t/m mei 2005.");
        content.addContent("<p>italic: cijfers aangepast vanwege ontbrekende dagen.");

        auto hb = HeadBottomInput(lastDate);
        hb.title = "stats www.epsig.nl";
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        hb.footerStyle = FooterStyle::New;
        hb.body = table::yellowRed(content, hb.title);
        return HeadBottom::getPage(hb);
    }

}
