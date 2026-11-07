#include "TestGlob.h"
#include "../shob.general/Glob.h"
#include "../shob.test.utils/TestUtils.h"
#include <gtest/gtest.h>

namespace shob::general::test
{
    void TestGlob::test1()
    {
        const std::string dataMap = "../testdata/yearstandings1";
        const std::string dataFolder = readers::test::testUtils::refFileWithPath(__FILE__, dataMap);

        const auto list = Glob::list(dataFolder, "eredivisie_[12][90].*");

        ASSERT_EQ(list.size(), 4);
    }
}
