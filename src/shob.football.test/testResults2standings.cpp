
#include "testResults2standings.h"

#include <gtest/gtest.h>

#include "../shob.test.utils/testUtils.h"

#include "../shob.football/results2standings.h"

#include "../shob.teams/clubTeams.h"

namespace shob::football::test
{
    using namespace readers::test;

    const std::string eredivisie = "../../data/sport/eredivisie/eredivisie_2023_2024.csv";
    const std::string u2s = "../../data/sport/eredivisie/eredivisie_u2s.csv";
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
        EXPECT_EQ(table2.body[16].data[0], "FC Volendam");
        EXPECT_EQ(table2.body[17].data[0], "Vitesse (-18)");
    }

    void testResults2standings::test3()
    {
        const std::string filename2 = testUtils::refFileWithPath(__FILE__, clubs);
        auto competition = footballCompetition();
    
        competition.readFromCsv(filename);
    
        auto table = results2standings::u2s(competition);
        auto extras = readers::csvAllSeasonsReader();
        const std::string filename3 = testUtils::refFileWithPath(__FILE__, u2s);
        extras.init(filename3);
        table.addExtras(extras, "2023-2024");

        auto settings = html::settings();
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2);
        auto table2 = table.prepareTable(reader, settings);

        EXPECT_EQ(table2.body.size(), 18);
        EXPECT_EQ(table2.body[16].data[0], "FC Volendam (degr.)");
        EXPECT_EQ(table2.body[17].data[0], "Vitesse (-18; degr.)");
    }
}
