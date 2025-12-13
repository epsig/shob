

#include "testTopscorers.h"

#include <gtest/gtest.h>

#include "../shob.test.utils/testUtils.h"

#include "../shob.football/topscorers.h"

#include "../shob.teams/clubTeams.h"

#include "../shob.readers/csvAllSeasonsReader.h"

namespace shob::football::test
{
    using namespace readers::test;

    const std::string eredivisie = "../../data/sport/eredivisie/topscorers_eredivisie.csv";
    const std::string filename = testUtils::refFileWithPath(__FILE__, eredivisie);
    const std::string clubs = "../../data/sport/clubs.csv";
    const std::string voetballers = "../../data/sport/voetballers.csv";

    void testTopscorers::test1()
    {
        auto allTp = readers::csvAllSeasonsReader();
        allTp.init(filename);

        auto tp = topscorers(allTp);
        tp.initFromFile(general::season(2019));

        auto players = teams::footballers();
        const std::string filename3 = testUtils::refFileWithPath(__FILE__, voetballers);
        players.initFromFile(filename3);

        auto settings = html::settings();
        auto reader = teams::clubTeams();
        const std::string filename2 = testUtils::refFileWithPath(__FILE__, clubs);

        reader.InitFromFile(filename2, teams::clubsOrCountries::clubs);
        auto table2 = tp.prepareTable(reader, players, settings);

        EXPECT_EQ(table2.body.size(), 2);
    }
}
