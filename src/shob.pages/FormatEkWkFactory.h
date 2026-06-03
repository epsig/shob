
#pragma once

#include "FormatEkWk.h"

namespace shob::pages
{
    class FormatEkWkFactory
    {
    public:
        static FormatEkWk build(const std::string& dataFolder, const html::settings& settings);
        static bool cmpFunc(const std::string& a, const std::string& b);
        static TopMenu prepareTopMenu(const std::string& dataFolderEkWkQf);
    };
}
