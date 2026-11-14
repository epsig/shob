#pragma once

#include "route2final.h"

namespace shob::football
{
    class RouteToFinalFactory
    {
    public:
        static RouteToFfinal create(const std::string& filename);
        static RouteToFfinal create(const readers::CsvContent& data);
        static RouteToFfinal createEC(const readers::CsvContent& data, const std::string& ECpart);
    };

}
