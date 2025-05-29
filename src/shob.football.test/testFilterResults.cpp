
#include "testFilterResults.h"

#include <gtest/gtest.h>

#include "../shob.football/filterResults.h"
#include "../shob.test.utils/testUtils.h"
#include "../shob.football/route2finalFactory.h"

namespace shob::football::test
{
    void testFilterResults::testFilterWithRoute2Finale()
    {
        const std::string beker2425 = "../../data/sport/beker/beker_2024_2025.csv";
        const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, beker2425);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = readers::test::testUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2);

        const auto r2f = route2finaleFactory::create(filename);
        const auto prepTable = r2f.prepareTable(reader);

        EXPECT_EQ(16, prepTable.body.size());
    }

    void testFilterResults::testGetReturns()
    {
        const std::string beker0910 = "../../data/sport/beker/beker_2009_2010.csv";
        const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, beker0910);
        const auto data = readers::csvReader::readCsvFile(filename);
        const auto finale = filterResults::readFromCsvData(data, "f");
        const auto coupledMatches = finale.getReturns();
        EXPECT_EQ(1, coupledMatches.couples.size());
    }
}
