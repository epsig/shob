
#include "testResults2standings.h"

#include <gtest/gtest.h>

#include "../shob.general.test/testUtils.h"

#include "../shob.football/results2standings.h"

#include "../shob.teams/clubTeams.h"

namespace shob::football::test
{
    using namespace readers::test;

    const std::string eredivisie = "../../data/sport/eredivisie/eredivisie_2024_2025.csv";
    const std::string filename = testUtils::refFileWithPath(__FILE__, eredivisie);
    const std::string clubs = "../../data/sport/clubs.csv";

    void testResults2standings::test1()
    {
        auto competition = footballCompetition();

        competition.readFromCsv(filename);

        auto table = results2standings::u2s(competition);

        EXPECT_EQ(table.list.size(), 18);
    }

    void testResults2standings::test2()
    {
        const std::string filename2 = testUtils::refFileWithPath(__FILE__, clubs);
        auto competition = footballCompetition();

        competition.readFromCsv(filename);

        auto table = results2standings::u2s(competition);

        auto settings = html::settings();
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2);
        auto table2 = table.prepareTable(reader, settings);

        EXPECT_EQ(table2.body.size(), 18);
        EXPECT_EQ(table2.body[16].data[0], "RKC Waalwijk");
    }
}
