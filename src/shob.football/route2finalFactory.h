#pragma once

#include "route2final.h"

namespace shob::football
{
    class route2finaleFactory
    {
    public:
        static route2final create(const std::string& filename);
    };

}
