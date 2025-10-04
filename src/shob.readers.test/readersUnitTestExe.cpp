
#include <gtest/gtest.h>

#include "testCsvReader.h"
#include "testXmlReader.h"
#include "testCsvAllSeasonsReader.h"

using namespace shob::readers::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testCsvReader";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testCsvReader)
{
    testCsvReader::test1();
}

TEST(unitTest, testSplit)
{
    testCsvReader::test2();
}

TEST(unitTest, testXmlReader)
{
    testXmlReader::test1();
}

TEST(unitTest, testXmlReader2)
{
    testXmlReader::test2();
}

TEST(unitTest, testCsvAllSeasonsReader)
{
    testCsvAllSeasonsReader::test1();
}

