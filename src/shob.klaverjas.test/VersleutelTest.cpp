#include "VersleutelTest.h"

#include "../shob.klaverjas/Versleutel.h"
#include "../shob.test.utils/testUtils.h"

#include <gtest/gtest.h>

namespace shob::klaverjas::test
{
    using namespace readers::test;

    void VersleutelTest::TestVersleutel()
    {
        const std::string relative_path = "../../code/Klaverjas/sleutels.txt";
        const std::string filename = testUtils::refFileWithPath(__FILE__, relative_path);

        auto result = Versleutel(0, filename);

        auto input = general::MultipleStrings();
        input.addContent("harten = 10");
        input.addContent("roem200");
        input.addContent("  klaveren vrouw  ");
        auto output = result.versleutelCode(input);

        ASSERT_EQ(output.data.size(), 3);
        EXPECT_EQ(output.data[0], "harten=10") << "check stripping spaces around =";
        EXPECT_EQ(output.data[1], "mJ") << "check roem200 encryption";
        EXPECT_EQ(output.data[2], "klaveren vrouw") << "check trimming spaces around klaveren vrouw";
    }
}