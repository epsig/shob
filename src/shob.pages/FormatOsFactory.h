#pragma once

#include "FormatOs.h"
#include "TopMenu.h"

namespace shob::pages
{
    class FormatOsFactory
    {
    public:
        static FormatOs build(const std::string& folder, const html::settings& settings);
    private:
        static TopMenu prepareTopMenu(const std::string& dataFolderEkWkQf);
        static bool cmpFunc(const std::string& a, const std::string& b);
    };
}

