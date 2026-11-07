#include "TestUniqueStrings.h"
#include <gtest/gtest.h>

#include "../shob.general/UniqueStrings.h"

namespace shob::general::test
{
    void TestUniqueStrings::test1()
    {
        auto set = UniqueStrings();
        set.insert("CL");
        set.insert("EL");
        set.insert("CF");
        set.insert("CL");
        const auto list = set.list();

        ASSERT_EQ(list.size(), 3);
        ASSERT_EQ(list[0], "CL");
        ASSERT_EQ(list[1], "EL");
        ASSERT_EQ(list[2], "CF");
    }

}
