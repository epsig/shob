#pragma once
#include <string>
#include "format_ekwk_qf.h"

namespace shob::pages
{
    class format_ekwk_qf_factory
    {
    public:
        static format_ekwk_qf build(const std::string& dataFolder, const html::settings& settings);
    };
}
