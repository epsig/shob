
#include "testFilterResults.h"

#include <gtest/gtest.h>

#include "../shob.football/filterResults.h"
#include "../shob.readers/csvReader.h"
#include "../shob.general.test/testUtils.h"
#include "../shob.football/route2final.h"

namespace shob::football::test
{
    void testFilterResults::test1()
    {
        const std::string beker2425 = "../../data/sport/beker/beker_2024_2025.csv";
        const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, beker2425);

        const auto data = readers::csvReader::readCsvFile(filename);

        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename2 = readers::test::testUtils::refFileWithPath(__FILE__, clubs);
        auto reader = teams::clubTeams();
        reader.InitFromFile(filename2);

        const auto finale = filterResults::readFromCsvData(data, "f");
        const auto semiFinal = filterResults::readFromCsvData(data, "2f");
        const auto quarterFinal = filterResults::readFromCsvData(data, "4f");
        const auto last16 = filterResults::readFromCsvData(data, "8f");

        const auto r2f = route2finale(finale, semiFinal, quarterFinal, last16);
        const auto prepTable = r2f.prepareTable(reader);

        EXPECT_EQ(1, finale.matches.size());
    }
}
