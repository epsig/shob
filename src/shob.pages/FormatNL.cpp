
#include "FormatNL.h"
#include <iostream>
#include <array>
#include <filesystem>
#include <format>

#include "PageBlock.h"
#include "../shob.football/results2standings.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.pages/HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.html/funcs.h"
#include "../shob.football/filterResults.h"

namespace shob::pages
{
    namespace fs = std::filesystem;
    using namespace shob::general;

    bool FormatNL::isValidSeason(const Season& season) const
    {
        std::string file_eredivisie = sportDataFolder + "/eredivisie/eredivisie_" + season.toPartFilename() + ".csv";
        std::string file_1e_divisie = sportDataFolder + "/eerste_divisie/eerste_divisie_" + season.toPartFilename() + ".csv";
        std::string file_beker      = sportDataFolder + "/beker/beker_" + season.toPartFilename() + ".csv";
        return fs::exists(file_eredivisie) || fs::exists(file_1e_divisie) || fs::exists(file_beker);
    }

    std::string FormatNL::getOutputFilename(const std::string& folder, const Season& season)
    {
        return std::format("{}/sport_voetbal_nl_{}.html", folder, season.toPartFilename());
    }

    MultipleStrings FormatNL::getSeason(const Season& season) const
    {
        auto file1 = sportDataFolder + "/eredivisie/eredivisie_" + season.toPartFilename() + ".csv";
        auto competition = football::footballCompetition();
        competition.readFromCsv(file1);

        auto out = MultipleStrings();

        auto Table = html::table(settings);

        // beker/supercup:
        const std::string bekerFilename = sportDataFolder + "/beker/beker_" + season.toPartFilename() + ".csv";
        readers::csvContent dataBekerAndSupercup;
        if (fs::exists(bekerFilename))
        {
            dataBekerAndSupercup = readers::csvReader::readCsvFile(bekerFilename);
        }

        const auto currentRemarks = remarks.getSeason(season);
        int scoring = 3;
        for (const auto& row : currentRemarks)
        {
            if (row[0] == "scoring")
            {
                scoring = std::stoi(row[1]);
            }
        }

        int dd = 19920101;
        dd = std::max(dd, competition.lastDate().toInt());

        auto pageBlocks = std::array<PageBlock, 6>();
        pageBlocks[0] = getSupercup(dataBekerAndSupercup, season);
        pageBlocks[1] = getKlassiekers(competition);
        pageBlocks[2] = getStandEredivisie(competition, scoring, season, currentRemarks);
        pageBlocks[3] = getEersteDivisie(season);
        pageBlocks[4] = getBothTopScorers(season);
        pageBlocks[5] = getBeker(dataBekerAndSupercup, dd);

        auto menuOut = menu.getMenu(season);
        menuOut.data[0] = "<hr> andere seizoenen: | " + menuOut.data[0];
        menuOut.data.push_back("<hr>| ");
        for (const auto& block : pageBlocks)
        {
            if (!block.data.data.empty())
            {
                menuOut.addContent(" <a href=\"#" + block.linkName + "\">" + block.description + "</a> |");
            }
        }
        std::string links = "<hr><a href=\"sport_voetbal_nl_stats.html\">Statistieken Eredivisie vanaf 1993</a> | ";
        links += "<a href=\"sport_voetbal_nl_jaarstanden.html\"> Winterkampioen en jaarstanden vanaf 1993 </a> | ";
        links += "<a href=\"sport_voetbal_nl_uit_thuis.html\">uit - en thuis standen vanaf 1993 </a> <hr>";
        menuOut.data.push_back(links);
        out.addContent(menuOut);

        for (auto& block : pageBlocks)
        {
            if (!block.data.data.empty())
            {
                out.addContent(block.data);
            }
        }

        auto hb = HeadBottomInput(dd);
        hb.title = "Overzicht betaald voetbal in Nederland, seizoen " + season.toString();
        std::swap(hb.body, out);

        return HeadBottom::getPage(hb);
    }

    PageBlock FormatNL::getSupercup(const readers::csvContent& dataBekerAndSupercup, const Season& season) const
    {
        PageBlock retval;
        if (dataBekerAndSupercup.body.empty()) return retval;

        auto Table = html::table(settings);
        auto filter = football::filterInputList();
        const std::string part = "supercup";
        filter.filters.push_back({ 0, part });
        const auto matches = football::filterResults::readFromCsvData(dataBekerAndSupercup, filter);
        if (!matches.matches.empty())
        {
            auto prepTable = matches.prepareTable(teams, settings);
            prepTable.title = std::format("<a name=\"JC\"/>Johan Cruijff schaal {}", season.getFirstYear());
            retval.data = Table.buildTable(prepTable);
            retval.linkName = "JC";
            retval.description = "supercup";
        }
        return retval;
    }

    PageBlock FormatNL::getKlassiekers(const football::footballCompetition& competition) const
    {
        PageBlock retval;
        const std::set<std::string> toppers = { "ajx", "fyn", "psv" };
        const auto filtered = competition.filter(toppers);
        if ( ! filtered.matches.empty())
        {
            auto Table = html::table(settings);
            auto prepTable = filtered.prepareTable(teams, settings);
            prepTable.title = "<a name=\"klassiekers\"/>De traditionele toppers";
            retval.data.addContent("<p/>");
            auto content = Table.buildTable(prepTable);
            retval.data.addContent(content);
            retval.linkName = "klassiekers";
            retval.description = retval.linkName;
        }
        return retval;
    }

    PageBlock FormatNL::getStandEredivisie(const football::footballCompetition& competition, int scoring, const Season& season,
        const std::vector<std::vector<std::string>>& remarks_this_season) const
    {
        PageBlock retval;
        auto Table = html::table(settings);

        std::string title = "Eredivisie";
        for (const auto& row : remarks_this_season)
        {
            if (row[0] == "title")
            {
                title = html::funcs::acronym("Eredivisie", row[1]);
            }
        }

        auto table = football::results2standings::u2s(competition, scoring);

        table.addExtras(extras, season);

        auto prepTable = table.prepareTable(teams, settings);
        if (table.isFinished())
        {
            prepTable.title = std::format("<a name=\"eredivisie\"/>Stand {} {}", title, season.toString());
        }
        else
        {
            const auto date = competition.lastDate().toString(false);
            prepTable.title = std::format("<a name=\"eredivisie\"/>Stand {} (per {})", title, date);
        }

        auto content = Table.buildTable(prepTable);
        retval.data.addContent("<p/>");
        retval.data.addContent(content);
        retval.linkName = "eredivisie";
        retval.description = retval.linkName;
        return retval;
    }

    PageBlock FormatNL::getEersteDivisie(const Season& season) const
    {
        PageBlock retval;
        const auto filename = sportDataFolder + "/eerste_divisie/eerste_divisie_" + season.toPartFilename() + ".csv";
        if (fs::exists(filename))
        {
            auto remarks_1e_div = readers::csvAllSeasonsReader();
            remarks_1e_div.init(sportDataFolder + "/eerste_divisie/eerste_divisie_remarks.csv");
            const auto currentRemarks = remarks_1e_div.getSeason(season);

            std::string title = "Eerste Divisie";
            for (const auto& row : currentRemarks)
            {
                if (row[0] == "title")
                {
                    title = html::funcs::acronym("Eerste Divisie", row[1]);
                }
            }

            auto standing_1e_div = football::standings();
            standing_1e_div.initFromFile(filename);

            auto prepTable = standing_1e_div.prepareTable(teams, settings);
            prepTable.title = std::format("<a name=\"1ste_div\"/>Stand {}", title);

            auto Table = html::table(settings);
            auto content = Table.buildTable(prepTable);

            retval.data.addContent("<p/>");
            retval.data.addContent(content);
            retval.linkName = "1ste_div";
            retval.description = "eerste divisie";
        }
        return retval;
    }

    PageBlock FormatNL::getBothTopScorers(const Season& season) const
    {
        PageBlock retval;
        const auto file_tp_eredivisie = sportDataFolder + "/eredivisie/topscorers_eredivisie.csv";
        const auto file_tp_eerste_divisie = sportDataFolder + "/eerste_divisie/topscorers_eerste_divisie.csv";
        if (fs::exists(file_tp_eredivisie) || fs::exists(file_tp_eerste_divisie))
        {
            auto players = teams::footballers();
            const std::string filename = sportDataFolder + "/voetballers.csv";
            players.initFromFile(filename);

            retval.data.addContent("<p/> <a name=\"topscorers\"/>");
            auto content = getTopScorers(file_tp_eredivisie, "Eredivisie", season, players);
            retval.data.addContent(content);

            content = getTopScorers(file_tp_eerste_divisie, "Eerste Divisie", season, players);
            retval.data.addContent(content);
            retval.description = "topscorers";
            retval.linkName = retval.description;
        }
        return retval;
    }

    MultipleStrings FormatNL::getTopScorers(const std::string& file, const std::string& name_competition, const Season& season,
        const teams::footballers& players) const
    {
        auto allTp = readers::csvAllSeasonsReader();
        allTp.init(file);

        auto tp = football::topscorers(allTp);
        tp.initFromFile(season);
        if (tp.getSizeList() > 0)
        {
            auto table = tp.prepareTable(teams, players, settings);
            table.title = "Topscorers " + name_competition;
            auto Table = html::table(settings);
            auto out = Table.buildTable(table);
            return out;
        }
        else
        {
            return {};
        }
    }

    PageBlock FormatNL::getBeker(const readers::csvContent& dataBekerAndSupercup, int& dd) const
    {
        PageBlock retval;
        auto Table = html::table(settings);
        Table.withBorder = false;
        if (!dataBekerAndSupercup.body.empty())
        {
            const auto r2f = football::route2finaleFactory::create(dataBekerAndSupercup);
            if (!r2f.empty())
            {
                auto prepTable = r2f.prepareTable(teams, settings);
                prepTable[0].header.addContent("KNVB Beker: de laatste 16");
                auto content = Table.buildTable(prepTable);
                retval.data.addContent("<p/> <a name=\"beker\"/>");
                retval.data.addContent(content);
                retval.linkName = "beker";
                retval.description = "beker-tournooi";
                dd = std::max(dd, r2f.lastDate().toInt());
            }
        }
        return retval;
    }

}
