
#include "testTable.h"
#include "../shob.html/table.h"

#include <gtest/gtest.h>

namespace shob::html::test
{
    void testTable::test1()
    {
        std::vector<std::string> header = { "aap", "noot", "mies" };
        std::vector<std::string> body = { "boom", "roos", "vis" };
        auto table = table::buildTable({ header, body });
        ASSERT_EQ(4, table.size());
    }

}
