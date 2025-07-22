
#pragma once
#include <string>
#include "format_ec.h"
#include <unordered_map>

namespace shob::pages
{
    class format_ec_factory
    {
    public:
        static format_ec build(const std::string& dataFolder, const html::settings& settings);
    private:
        static std::unordered_map<std::string, std::string> getLeagueNames(const std::string& dataFolder);
    };
}
