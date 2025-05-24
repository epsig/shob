
#include "testCsvAllSeasonsReader.h"

#include <gtest/gtest.h>

#include "../shob.readers/csvAllSeasonsReader.h"

#include "../shob.test.utils/testUtils.h"

namespace shob::readers::test
{
    void testCsvAllSeasonsReader::test1()
    {
        const std::string u2sFile = "../../data/sport/eredivisie/eredivisie_u2s.csv";
        const std::string filename = testUtils::refFileWithPath(__FILE__, u2sFile);
        auto result = csvAllSeasonsReader();
        result.init(filename);
        auto filtered = result.getSeason("2023-2024");
        EXPECT_EQ(9, filtered.size());
    }

}

