#pragma once

#include "FormatOs.h"
#include "topmenu.h"

namespace shob::pages
{
    class FormatOsFactory
    {
    public:
        static FormatOs build(const std::string& folder, const html::settings& settings);
    private:
        static topMenu prepareTopMenu(const std::string& dataFolderEkWkQf);
        static bool cmpFunc(const std::string& a, const std::string& b);
    };
}

