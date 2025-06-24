
#include "testFilterResults.h"

#include <gtest/gtest.h>

#include "../shob.football/filterResults.h"
#include "../shob.test.utils/testUtils.h"
#include "../shob.football/route2finalFactory.h"

namespace shob::football::test
{
    using namespace shob::readers;
    using namespace shob::readers::test;

    void testFilterResults::testFilterWithRoute2Finale()
    {
        const std::string beker2425 = "../../data/sport/beker/beker_2024_2025.csv";
        const std::string filename = testUtils::refFileWithPath(__FILE__, beker2425);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = testUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2);

        const auto r2f = route2finaleFactory::create(filename);
        const auto prepTable = r2f.prepareTable(reader, html::language::Dutch);

        EXPECT_EQ(16, prepTable.body.size());
        EXPECT_EQ(prepTable.body[8].data[3], "21 apr AZ - <b>Go Ahead Eagles</b> 1-1 ns") << "check bold for winner";
    }

    void testFilterResults::testGetReturns()
    {
        const std::string beker0910 = "../../data/sport/beker/beker_2009_2010.csv";
        const std::string filename = testUtils::refFileWithPath(__FILE__, beker0910);
        const auto data = csvReader::readCsvFile(filename);

        auto filter = filterInputList();
        filter.filters.push_back({ 0, "f" });
        const auto finale = filterResults::readFromCsvData(data, filter);
        const auto coupledMatches = finale.getReturns();
        EXPECT_EQ(1, coupledMatches.couples.size());
    }

    void testFilterResults::testFilterEuropacup()
    {
        const std::string ec2425 = "../../data/sport/europacup/europacup_2024_2025.csv";
        const std::string filename = testUtils::refFileWithPath(__FILE__, ec2425);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = testUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2);

        const auto data = csvReader::readCsvFile(filename);
        const auto r2f = route2finaleFactory::createEC(data, "CL");
        const auto prepTable = r2f.prepareTable(reader, html::language::Dutch);

        EXPECT_EQ(16, prepTable.body.size());
        EXPECT_EQ(prepTable.body[0].data[0], "4 mrt Club Brugge - Aston Villa 1-3<br>12 mrt Aston Villa * - Club Brugge 3-0")
            << "check star for winner and having two matches";
    }

}
