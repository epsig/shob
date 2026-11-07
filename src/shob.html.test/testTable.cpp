
#include "TestTable.h"
#include "../shob.html/Table.h"

#include <gtest/gtest.h>

namespace shob::html::test
{
    void testTable::test1()
    {
        TableContent content;
        content.header.data = { "aap", "noot", "mies" };
        general::MultipleStrings body;
        body.data = { "boom", "roos", "vis" };
        content.body.push_back(body);
        auto tableObj = Table(Settings());
        auto table = tableObj.buildTable(content);
        ASSERT_EQ(4, table.data.size());
    }

}
