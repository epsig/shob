
#pragma once
#include "table.h"
#include <string>

namespace shob::html
{
    class updateIfDifferent
    {
    public:
        static void update(const std::string& path, const rowContent& content);
    private:
        static bool areEqual(const std::vector<std::string>& prev, const rowContent& current);

    };
}
