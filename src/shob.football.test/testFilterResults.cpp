
#include "testFilterResults.h"

#include <gtest/gtest.h>

#include "../shob.football/filterResults.h"
#include "../shob.readers/csvReader.h"
#include "../shob.general.test/testUtils.h"

namespace shob::football::test
{
    void testFilterResults::test1()
    {
        const std::string beker2425 = "../../data/sport/beker/beker_2024_2025.csv";
        const std::string filename = readers::test::testUtils::refFileWithPath(__FILE__, beker2425);

        const auto data = readers::csvReader::readCsvFile(filename);

        const auto finale = filterResults::readFromCsvData(data, "f");

        EXPECT_EQ(1, finale.matches.size());
    }
}
