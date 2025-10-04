
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
        EXPECT_EQ(306, result.body.size());
    }

    void testCsvReader::test2()
    {
        const std::string s = "string1,string2";
        const auto splitted = csvReader::split(s, ",");
        EXPECT_EQ(splitted.column.size(), 2);

        auto s2 = "string1, \"string2a,string2b\"";
        const auto splitted2 = csvReader::split(s2, ",");
        EXPECT_EQ(splitted.column.size(), 2);
    }

}

