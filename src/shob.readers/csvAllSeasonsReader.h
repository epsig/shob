
#pragma once

#include <string>
#include <vector>
#include "../shob.readers/csvReader.h"

namespace shob::readers
{
    class csvAllSeasonsReader
    {
    public:
        void init(const std::string& filename);
        std::vector<std::vector<std::string>> getSeason(const std::string& season) const;
    private:
        csvContent allData;
    };

}

