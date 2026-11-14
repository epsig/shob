#include "TestFilterResults.h"

#include <gtest/gtest.h>

#include "../shob.football/FilterResults.h"
#include "../shob.test.utils/TestUtils.h"
#include "../shob.football/RouteToFinalFactory.h"

namespace shob::football::test
{
    using namespace shob::readers;
    using namespace shob::readers::test;

    void TestFilterResults::testFilterWithRoute2Finale()
    {
        const std::string beker2425 = "../../data/sport/beker/beker_2024_2025.csv";
        const std::string filename = TestUtils::refFileWithPath(__FILE__, beker2425);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = TestUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::ClubTeams();
        reader.InitFromFile(filename2, teams::ClubsOrCountries::clubs);

        const auto r2f = RouteToFinalFactory::create(filename);
        const auto prepTable = r2f.prepareTable(reader, html::Settings());

        EXPECT_EQ(16, prepTable[0].body.size());
        EXPECT_EQ(prepTable[0].body[8].data[3], "21 apr 2025 AZ - <b>Go Ahead Eagles</b> 1-1 ns") << "check bold for winner";
    }

    void TestFilterResults::testGetReturns()
    {
        const std::string beker0910 = "../../data/sport/beker/beker_2009_2010.csv";
        const std::string filename = TestUtils::refFileWithPath(__FILE__, beker0910);
        const auto data = CsvReader::readCsvFile(filename);

        auto filter = FilterInputList();
        filter.filters.push_back({ 0, "f" });
        const auto finale = FilterResults::readFromCsvData(data, filter);
        const auto coupledMatches = finale.getReturns();
        EXPECT_EQ(1, coupledMatches.couples.size());
    }

    void TestFilterResults::testFilterEuropacup()
    {
        const std::string ec2425 = "../../data/sport/europacup/europacup_2024_2025.csv";
        const std::string filename = TestUtils::refFileWithPath(__FILE__, ec2425);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = TestUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::ClubTeams();
        reader.InitFromFile(filename2, teams::ClubsOrCountries::clubs);

        const auto data = CsvReader::readCsvFile(filename);
        const auto r2f = RouteToFinalFactory::createEC(data, "CL");
        const auto prepTable = r2f.prepareTable(reader, html::Settings());

        EXPECT_EQ(8, prepTable[0].body.size());
        EXPECT_EQ(prepTable[0].body[0].data[0], "8 apr 2025 Arsenal - Real Madrid 3-0<br>16 apr 2025 Real Madrid - Arsenal * 1-2")
            << "check star for winner and having two matches";
    }

}
