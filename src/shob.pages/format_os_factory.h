#pragma once

#include "format_os.h"
#include "topmenu.h"

namespace shob::pages
{
    class format_os_factory
    {
    public:
        static format_os build(const std::string& folder, const html::settings& settings);
    private:
        static topMenu prepareTopMenu(const std::string& dataFolderEkWkQf);
        static bool cmpFunc(const std::string& a, const std::string& b);
    };
}

