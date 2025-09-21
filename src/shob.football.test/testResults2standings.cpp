
#include "testResults2standings.h"

#include <gtest/gtest.h>

#include "../shob.test.utils/testUtils.h"
#include "../shob.football/results2standings.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.football/filterInput.h"
#include "../shob.football/filterResults.h"

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
        table.addExtras(extras, general::season(2023));

        auto settings = html::settings();
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2);
        auto table2 = table.prepareTable(reader, settings);

        EXPECT_EQ(table2.body.size(), 18);
        EXPECT_EQ(table2.body[16].data[0], "FC Volendam (degr.)");
        EXPECT_EQ(table2.body[17].data[0], "Vitesse (-18; degr.)");
    }

    void testResults2standings::testMutualResults()
    {
        // set up test:
        const auto file1 = testUtils::refFileWithPath(__FILE__, "../../data/sport/europacup/europacup_1996_1997.csv");
        const auto csvData = readers::csvReader::readCsvFile(file1);
        auto filter = filterInputList();
        filter.filters.push_back({ 0, "CL" });
        filter.filters.push_back({ 1, "gA" });
        const auto CL_gA = filterResults::readFromCsvData(csvData, filter);

        // standing with mutual results:
        const auto stand = results2standings::u2s(CL_gA, 3, 3);
        EXPECT_EQ(stand.list[0].team, "FRaux");
        EXPECT_EQ(stand.list[1].team, "NLajx");

        // standing without mutual results:
        const auto stand2 = results2standings::u2s(CL_gA, 3, 0);
        EXPECT_EQ(stand2.list[1].team, "FRaux");
        EXPECT_EQ(stand2.list[0].team, "NLajx");
    }
}
