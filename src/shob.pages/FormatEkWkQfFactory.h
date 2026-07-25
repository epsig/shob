#pragma once
#include <string>
#include "FormatEkWkQf.h"

namespace shob::pages
{
    class FormatEkWkQfFactory
    {
    public:
        static FormatEkWkQf build(const std::string& dataFolder, const html::settings& settings);
    private:
        static TopMenu prepareTopMenu(const std::string& dataFolderEkWkQf);
        static bool cmpFunc(const std::string& a, const std::string& b);
    };
}
