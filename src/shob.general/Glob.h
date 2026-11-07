
#pragma once
#include <string>
#include <vector>

namespace shob::general
{
    class glob
    {
    public:
        static std::vector<std::string> list(const std::string& path, const std::string& expr);
    };
}
