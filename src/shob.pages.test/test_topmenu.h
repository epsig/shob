
#pragma once
#include <string>
#include <vector>

namespace shob::pages::test
{
    class testTopMenu
    {
    public:
        static void test_left();
        static void test_center();
        static void test_right();
    private:
        static std::vector<std::string> getArchive();
    };

}

