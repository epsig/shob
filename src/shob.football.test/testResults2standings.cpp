
#include "testResults2standings.h"

#include <gtest/gtest.h>

#include "../shob.general.test/testUtils.h"

#include "../shob.football/results2standings.h"

namespace shob::football::test
{
    void testResults2standings::test1()
    {
        const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, "../../data/sport/eredivisie/eredivisie_2024_2025.csv");
        auto competition = football::footballCompetition();

        competition.readFromCsv(filename);

        auto table = results2standings::u2s(competition);

        EXPECT_EQ(table.list.size(), 18);

    }
}
