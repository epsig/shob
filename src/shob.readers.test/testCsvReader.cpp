
#include "testCsvReader.h"

#include <gtest/gtest.h>

#include "../shob.readers/csvReader.h"

#include "../shob.test.utils/testUtils.h"

namespace shob::readers::test
{
    void testCsvReader::test1()
    {
        const std::string filename = testUtils::refFileWithPath(__FILE__,  "../../data/sport/eredivisie/eredivisie_2024_2025.csv");
        auto result = csvReader::readCsvFile(filename);
        EXPECT_EQ(244, result.size());
    }

}

