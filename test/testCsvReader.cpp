
#include "testCsvReader.h"

#include <gtest/gtest.h>

#include "../src/csvReader.h"

namespace shob::readers::test
{

    std::string refFileWithPath(const std::string& sourceFile, const std::string& relativePath)
    {
        auto found = sourceFile.find_last_of("/\\");
        auto base = sourceFile.substr(0, found + 1);
        return base + relativePath;
    }

    void testCsvReader::test1()
    {
        const std::string filename = refFileWithPath(__FILE__,  "../data/sport/eredivisie/eredivisie_2024_2025.csv");
        auto result = csvReader::readCsvFile(filename);
        EXPECT_EQ(244, result.size());
    }

}

