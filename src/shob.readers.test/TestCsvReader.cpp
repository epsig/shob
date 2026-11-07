#include "TestCsvReader.h"

#include <gtest/gtest.h>

#include "../shob.readers/CsvReader.h"

#include "../shob.test.utils/TestUtils.h"

namespace shob::readers::test
{
    void TestCsvReader::test1()
    {
        const std::string filename = TestUtils::refFileWithPath(__FILE__,  "../../data/sport/eredivisie/eredivisie_2024_2025.csv");
        auto result = CsvReader::readCsvFile(filename);
        EXPECT_EQ(306, result.body.size());
    }

    void TestCsvReader::test2()
    {
        const std::string s = "string1,string2";
        const auto splitted = CsvReader::split(s, ",");
        EXPECT_EQ(splitted.column.size(), 2);

        auto s2 = "string1, \"string2a,string2b\"";
        const auto splitted2 = CsvReader::split(s2, ",");
        EXPECT_EQ(splitted.column.size(), 2);
    }
}
