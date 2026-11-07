
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

TEST(unitTest, TestCsvReader)
{
    TestCsvReader::test1();
}

TEST(unitTest, testSplit)
{
    TestCsvReader::test2();
}

TEST(unitTest, testXmlReader2)
{
    TestXmlReader::test2();
}

TEST(unitTest, TestCsvAllSeasonsReader)
{
    TestCsvAllSeasonsReader::test1();
}

