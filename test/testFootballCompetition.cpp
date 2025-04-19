
#include "testFootballCompetition.h"

#include <gtest/gtest.h>

#include "../src/footballCompetition.h"

#include "testUtils.h"

namespace shob::football::test
{
    void testFootballCompetition::test1()
    {
        const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, "../data/sport/eredivisie/eredivisie_2024_2025.csv");
        auto competition = football::footballCompetition();

        competition.readFromCsv(filename);
        EXPECT_EQ(243, competition.matches.size());
    }

}

