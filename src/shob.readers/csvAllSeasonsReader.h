
#pragma once

#include <string>
#include <vector>
#include <map>
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
        std::map<std::string, std::string> getAll(const std::string& id) const;
    private:
        csvContent allData;
    };

}

