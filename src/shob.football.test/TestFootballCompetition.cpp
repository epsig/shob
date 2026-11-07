
#include "TestFootballCompetition.h"

#include <gtest/gtest.h>

#include "../shob.football/FootballCompetition.h"
#include "../shob.football/Results2Standings.h"

#include "../shob.test.utils/testUtils.h"

namespace shob::football::test
{
    const std::string eredivisie2425 = "../../data/sport/eredivisie/eredivisie_2024_2025.csv";
    const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, eredivisie2425);

    void TestFootballCompetition::test1()
    {
        auto competition = FootballCompetition();
        competition.readFromCsv(filename);
        EXPECT_EQ(306, competition.matches.size());
    }

    void TestFootballCompetition::testStrafPoints()
    {
        readers::CsvColContent header;
        header.column = { "club1", "club2", "dd", "result", "spectators", "remark" };
        readers::CsvColContent straf;
        straf.column = { "vit", "straf" , "pnt", "18", "", "dd 19 april" };
        readers::CsvContent csvData;
        csvData.header = header;
        csvData.body.push_back(straf);
        auto competition = FootballCompetition();
        competition.readFromCsvData(csvData);
        ASSERT_EQ(1, competition.matches.size());

        auto table = ResultsToStandings::u2s(competition);

        ASSERT_EQ(table.list.size(), 1);
        EXPECT_EQ(table.list[0].points, -18);
    }

    void TestFootballCompetition::testFiltered()
    {
        auto competition = FootballCompetition();
        competition.readFromCsv(filename);

        const std::set<std::string> toppers = { "ajx", "fyn", "psv" };
        const auto filtered = competition.filter(toppers);
        EXPECT_EQ(6, filtered.matches.size());
    }

    void TestFootballCompetition::testPrepareTable()
    {
        auto competition = FootballCompetition();
        competition.readFromCsv(filename);

        const std::set<std::string> toppers = { "ajx", "fyn", "psv" };
        const auto filtered = competition.filter(toppers);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = readers::test::testUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2, teams::clubsOrCountries::clubs);

        const auto table = filtered.prepareTable(reader, html::Settings());
        EXPECT_EQ(6, table.body.size());
    }

}

