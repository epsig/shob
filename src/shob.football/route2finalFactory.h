#pragma once

#include "route2final.h"

namespace shob::football
{
    class route2finaleFactory
    {
    public:
        static route2final create(const std::string& filename);
        static route2final createEC(const readers::csvContent& data, const std::string& ECpart);
    };

}
