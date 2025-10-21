
#pragma once

#include <string>
#include <vector>
#include "../shob.readers/csvReader.h"
#include "../shob.general/season.h"

namespace shob::readers
{
    class csvAllSeasonsReader
    {
    public:
        void init(const std::string& filename);
        std::vector<std::vector<std::string>> getSeason(const general::season& season) const;
        std::vector<std::vector<std::string>> getSeason(const std::string& id) const;
    private:
        csvContent allData;
    };

}

