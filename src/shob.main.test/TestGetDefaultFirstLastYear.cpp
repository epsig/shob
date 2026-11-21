#include "TestGetDefaultFirstLastYear.h"

#include <filesystem>
#include <fstream>
#include <gtest/gtest.h>

#include "../shob.general/CurrentDateTime.h"
#include "../shob.main/GetDefaultFirstLastYear.h"

namespace shob::main::test
{
    namespace fs = std::filesystem;

    void TestGetDefaultFirstLastYear::testDefaultIsCurrentYearWhenNoRemarksFile()
    {
        const auto originalPath = fs::current_path();
        const auto tempPath = fs::temp_directory_path() / "shob_main_test_getdefault_none";
        fs::remove_all(tempPath);
        fs::create_directories(tempPath);
        fs::current_path(tempPath);

        int firstYear = 0;
        int lastYear = 0;
        GetDefaultFirstLastYear::get(firstYear, lastYear);

        fs::current_path(originalPath);
        fs::remove_all(tempPath);

        EXPECT_EQ(firstYear, 1993);
        EXPECT_EQ(lastYear, shob::general::CurrentDateTime::getCurrentYear());
    }

    void TestGetDefaultFirstLastYear::testDefaultUsesNextEkwkYearWhenDefinedInRemarks()
    {
        const auto originalPath = fs::current_path();
        const auto tempPath = fs::temp_directory_path() / "shob_main_test_getdefault_next";
        fs::remove_all(tempPath);

        const auto remarksFolder = tempPath / "data" / "sport" / "ekwk_qf";
        fs::create_directories(remarksFolder);

        const auto currentYear = shob::general::CurrentDateTime::getCurrentYear();
        const auto nextYear = currentYear + (currentYear % 2 == 0 ? 2 : 1);
        const auto seasonPrefix = nextYear % 4 == 0 ? "ek" : "wk";

        std::ofstream remarksFile(remarksFolder / "ekwk_qf_remarks.csv");
        remarksFile << "id,key,value\n";
        remarksFile << seasonPrefix << nextYear << ",organising_country,test\n";
        remarksFile.close();

        fs::current_path(tempPath);

        int firstYear = 0;
        int lastYear = 0;
        GetDefaultFirstLastYear::get(firstYear, lastYear);

        fs::current_path(originalPath);
        fs::remove_all(tempPath);

        EXPECT_EQ(firstYear, 1993);
        EXPECT_EQ(lastYear, nextYear);
    }
}
