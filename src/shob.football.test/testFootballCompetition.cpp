
#include "testFootballCompetition.h"

#include <gtest/gtest.h>

#include "../shob.football/footballCompetition.h"
#include "../shob.football/results2standings.h"

#include "../shob.test.utils/testUtils.h"

namespace shob::football::test
{
    const std::string eredivisie2425 = "../../data/sport/eredivisie/eredivisie_2024_2025.csv";
    const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, eredivisie2425);

    void testFootballCompetition::test1()
    {
        auto competition = footballCompetition();
        competition.readFromCsv(filename);
        EXPECT_EQ(306, competition.matches.size());
    }

    void testFootballCompetition::testStrafPoints()
    {
        readers::csvColContent header;
        header.column = { "club1", "club2", "dd", "result", "spectators", "remark" };
        readers::csvColContent straf;
        straf.column = { "vit", "straf" , "pnt", "18", "", "dd 19 april" };
        readers::csvContent csvData;
        csvData.header = header;
        csvData.body.push_back(straf);
        auto competition = footballCompetition();
        competition.readFromCsvData(csvData);
        ASSERT_EQ(1, competition.matches.size());

        auto table = results2standings::u2s(competition);

        ASSERT_EQ(table.list.size(), 1);
        EXPECT_EQ(table.list[0].points, -18);
    }

    void testFootballCompetition::testFiltered()
    {
        auto competition = footballCompetition();
        competition.readFromCsv(filename);

        const std::set<std::string> toppers = { "ajx", "fyn", "psv" };
        const auto filtered = competition.filter(toppers);
        EXPECT_EQ(6, filtered.matches.size());
    }

    void testFootballCompetition::testPrepareTable()
    {
        auto competition = footballCompetition();
        competition.readFromCsv(filename);

        const std::set<std::string> toppers = { "ajx", "fyn", "psv" };
        const auto filtered = competition.filter(toppers);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = readers::test::testUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2, teams::clubsOrCountries::clubs);

        const auto table = filtered.prepareTable(reader, html::settings());
        EXPECT_EQ(6, table.body.size());
    }

}

