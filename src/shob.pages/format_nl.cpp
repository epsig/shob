
#include "format_nl.h"
#include <iostream>
#include <filesystem>

#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.pages/head_bottum.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    namespace fs = std::filesystem;
    using namespace shob::general;

    void format_nl::get_season_to_file(const general::season& season, const std::string& filename) const
    {
        auto output = get_season(season);
        html::updateIfDifferent::update(filename, output);
    }

    void format_nl::get_season_stdout(const general::season& season) const
    {
        auto output = get_season(season);
        for (const auto& row : output.data)
        {
            std::cout << row << std::endl;
        }
    }

    multipleStrings format_nl::getTopScorers(const std::string& file, const season& season,
        const teams::footballers& players, const teams::clubTeams& teams)
    {
        auto settings = html::settings();

        auto allTp = readers::csvAllSeasonsReader();
        allTp.init(file);

        auto tp = football::topscorers(allTp);
        tp.initFromFile(season);
        auto table = tp.prepareTable(teams, players, settings);
        auto Table = html::table(settings);
        auto out = Table.buildTable(table);
        return out;
    }

    multipleStrings format_nl::get_season(const season& season) const
    {
        auto settings = html::settings();

        auto file1 = sportDataFolder + "/eredivisie/eredivisie_" + season.to_part_filename() + ".csv";
        auto competition = football::footballCompetition();
        competition.readFromCsv(file1);

        auto out = multipleStrings();

        auto menuOut = menu.getMenu(season);
        menuOut.data[0] = "<hr> andere seizoenen: | " + menuOut.data[0];
        out.addContent(menuOut);

        auto teams = teams::clubTeams();
        auto file2 = sportDataFolder + "/clubs.csv";
        teams.InitFromFile(file2);

        auto Table = html::table(settings);

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

        auto file3 = sportDataFolder + "/eerste_divisie/eerste_divisie_" + season.to_part_filename() + ".csv";
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
        const std::string bekerFilename = sportDataFolder + "/beker/beker_" + season.to_part_filename() +".csv";
        if (fs::exists(bekerFilename))
        {
            const auto r2f = football::route2finaleFactory::create(bekerFilename);
            const auto prepTable = r2f.prepareTable(teams, settings.lang);
            content = Table.buildTable(prepTable);
            out.addContent(content);
        }

        auto hb = headBottumInput();
        hb.title = "Overzicht betaald voetbal in Nederland, seizoen " + season.to_string();
        std::swap(hb.body, out);

        return headBottum::getPage(hb);
    }

}
