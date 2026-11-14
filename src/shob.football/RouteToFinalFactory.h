#pragma once

#include "RouteToFinal.h"

namespace shob::football
{
    class RouteToFinalFactory
    {
    public:
        static RouteToFinal create(const std::string& filename);
        static RouteToFinal create(const readers::CsvContent& data);
        static RouteToFinal createEC(const readers::CsvContent& data, const std::string& ECpart);
    };

}
