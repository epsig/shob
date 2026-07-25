
#include "testGlob.h"
#include "../shob.general/glob.h"
#include "../shob.test.utils/testUtils.h"
#include <gtest/gtest.h>

namespace shob::general::test
{
    void testGlob::test1()
    {
        const std::string dataMap = "../testdata/yearstandings1";
        const std::string dataFolder = readers::test::testUtils::refFileWithPath(__FILE__, dataMap);

        const auto list = glob::list(dataFolder, "eredivisie_[12][90].*");

        ASSERT_EQ(list.size(), 4);
    }
}
