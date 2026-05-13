
#include "FormatNL.h"
#include <iostream>
#include <array>
#include <filesystem>

#include "PageBlock.h"
#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.pages/HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.football/filterResults.h"

namespace shob::pages
{
    namespace fs = std::filesystem;
    using namespace shob::general;

    void FormatNL::get_season_to_file(const Season& season, const std::string& filename) const
    {
        auto output = get_season(season);
        html::updateIfDifferent::update(filename, output);
    }

    void FormatNL::get_season_stdout(const Season& season) const
    {
        auto output = get_season(season);
        for (const auto& row : output.data)
        {
            std::cout << row << "\n";
        }
        std::cout.flush();
    }

    MultipleStrings FormatNL::getTopScorers(const std::string& file, const Season& season,
        const teams::footballers& players, const teams::clubTeams& teams)
    {
        constexpr auto settings = html::settings();

        auto allTp = readers::csvAllSeasonsReader();
        allTp.init(file);

        auto tp = football::topscorers(allTp);
        tp.initFromFile(season);
        if (tp.getSizeList() > 0)
        {
            auto table = tp.prepareTable(teams, players, settings);
            auto Table = html::table(settings);
            auto out = Table.buildTable(table);
            return out;
        }
        else
        {
            return {};
        }
    }

    MultipleStrings FormatNL::get_season(const Season& season) const
    {
        constexpr auto settings = html::settings();

        auto file1 = sportDataFolder + "/eredivisie/eredivisie_" + season.toPartFilename() + ".csv";
        auto competition = football::footballCompetition();
        competition.readFromCsv(file1);

        auto out = MultipleStrings();


        auto teams = teams::clubTeams();
        auto file2 = sportDataFolder + "/clubs.csv";
        teams.InitFromFile(file2, teams::clubsOrCountries::clubs);

        auto Table = html::table(settings);

        auto pageBlocks = std::array<pageBlock, 1>();

        // beker/supercup:
        const std::string bekerFilename = sportDataFolder + "/beker/beker_" + season.toPartFilename() + ".csv";
        readers::csvContent dataBekerAndSupercup;
        if (fs::exists(bekerFilename))
        {
            dataBekerAndSupercup = readers::csvReader::readCsvFile(bekerFilename);
            auto filter = football::filterInputList();
            const std::string part = "supercup";
            filter.filters.push_back({ 0, part });
            const auto matches = football::filterResults::readFromCsvData(dataBekerAndSupercup, filter);
            if (!matches.matches.empty())
            {
                auto prepTable = matches.prepareTable(teams, settings);
                prepTable.title = std::format("<a name=\"JC\"/>Johan Cruijff schaal {}", season.getFirstYear());
                auto table = Table.buildTable(prepTable);
                pageBlocks[0].data = table;
                pageBlocks[0].linkName = "JC";
                pageBlocks[0].description = "supercup";
            }
        }

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
        menuOut.data.push_back(" klassiekers | eredivisie | beker-tournooi | eerste divisie | topscorers |");
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

        const std::set<std::string> toppers = { "ajx", "fyn", "psv" };
        const auto filtered = competition.filter(toppers);
        auto content = Table.buildTable(filtered.prepareTable(teams, settings));
        out.addContent(content);

        const auto currentRemarks = remarks.getSeason(season);
        int scoring = 3;
        for (const auto& row: currentRemarks)
        {
            if (row[0] == "scoring")
            {
                scoring = std::stoi(row[1]);
            }
        }

        auto table = football::results2standings::u2s(competition, scoring);

        auto file3 = sportDataFolder + "/eerste_divisie/eerste_divisie_" + season.toPartFilename() + ".csv";
        auto standing_1e_div = football::standings();
        standing_1e_div.initFromFile(file3);

        table.addExtras(extras, season);

        auto htmlTable = table.prepareTable(teams, settings);
        auto htmlTable2 = standing_1e_div.prepareTable(teams, settings);

        content = Table.buildTable(htmlTable);
        out.addContent(content);
        content = Table.buildTable(htmlTable2);
        out.addContent(content);

        // topscorers:
        auto players = teams::footballers();
        const std::string filename3 = sportDataFolder + "/voetballers.csv";
        players.initFromFile(filename3);

        auto file_tp_eredivisie = sportDataFolder + "/eredivisie/topscorers_eredivisie.csv";
        content = getTopScorers(file_tp_eredivisie, season, players, teams);
        out.addContent(content);

        auto file_tp_eerste_divisie = sportDataFolder + "/eerste_divisie/topscorers_eerste_divisie.csv";
        content = getTopScorers(file_tp_eerste_divisie, season, players, teams);
        out.addContent(content);

        // beker:
        int dd = 19920101;
        if (fs::exists(bekerFilename))
        {
            const auto r2f = football::route2finaleFactory::create(dataBekerAndSupercup);
            const auto prepTable = r2f.prepareTable(teams, settings);
            content = Table.buildTable(prepTable);
            out.addContent(content);
            dd = r2f.lastDate().toInt();
        }

        auto hb = HeadBottomInput(dd);
        hb.title = "Overzicht betaald voetbal in Nederland, seizoen " + season.toString();
        std::swap(hb.body, out);

        return HeadBottom::getPage(hb);
    }

}
