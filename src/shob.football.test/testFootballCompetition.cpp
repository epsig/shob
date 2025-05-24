
#include "testFootballCompetition.h"

#include <gtest/gtest.h>

#include "../shob.football/footballCompetition.h"
#include "../shob.football/results2standings.h"

#include "../shob.test.utils/testUtils.h"

namespace shob::football::test
{
    void testFootballCompetition::test1()
    {
        const std::string eredivisie2425 = "../../data/sport/eredivisie/eredivisie_2024_2025.csv";
        const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, eredivisie2425);
        auto competition = footballCompetition();

        competition.readFromCsv(filename);
        EXPECT_EQ(306, competition.matches.size());
    }

    void testFootballCompetition::testStrafPoints()
    {
        const std::vector<std::string> header = { "club1", "club2", "dd", "result", "spectators", "remark" };
        const std::vector<std::string> straf = { "vit", "straf" , "pnt", "18", "", "dd 19 april" };
        std::vector<std::vector<std::string>> csvData;
        csvData.push_back(header);
        csvData.push_back(straf);
        auto competition = footballCompetition();
        competition.readFromCsvData(csvData);
        ASSERT_EQ(1, competition.matches.size());

        auto table = results2standings::u2s(competition);

        ASSERT_EQ(table.list.size(), 1);
        EXPECT_EQ(table.list[0].points, -18);
    }

}

