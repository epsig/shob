
#pragma once
#include <string>
#include "format_ec.h"

namespace shob::pages
{
    class format_ec_factory
    {
    public:
        static format_ec build(const std::string& dataFolder, const html::settings& settings);
    };
}
