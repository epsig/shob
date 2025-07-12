
#include "testTable.h"
#include "../shob.html/table.h"

#include <gtest/gtest.h>

namespace shob::html::test
{
    void testTable::test1()
    {
        tableContent content;
        content.header.data = { "aap", "noot", "mies" };
        general::multipleStrings body;
        body.data = { "boom", "roos", "vis" };
        content.body.push_back(body);
        auto table = table::buildTable(content);
        ASSERT_EQ(4, table.data.size());
    }

}
