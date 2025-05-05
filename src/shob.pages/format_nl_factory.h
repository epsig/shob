
#pragma once
#include <string>
#include "format_nl.h"

namespace shob::pages
{
    class format_nl_factory
    {
    public:
        static format_nl build(const std::string& dataFolder);
    };
}
