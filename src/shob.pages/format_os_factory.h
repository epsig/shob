#pragma once

#include "format_os.h"

namespace shob::pages
{
    class format_os_factory
    {
    public:
        static format_os build(const std::string& folder, const html::settings& settings);
    };
}

