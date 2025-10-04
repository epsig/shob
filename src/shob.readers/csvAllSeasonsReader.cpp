
#include "csvAllSeasonsReader.h"
#include "csvReader.h"

namespace shob::readers
{
    void csvAllSeasonsReader::init(const std::string& filename)
    {
        allData = csvReader::readCsvFile(filename);
    }

    std::vector<std::vector<std::string>> csvAllSeasonsReader::getSeason(const general::season& season) const
    {
        std::vector<std::vector<std::string>> oneSeasonData;
        oneSeasonData.push_back(allData.header.column);
        for (const auto& rw : allData.body)
        {
            if (rw.column[0] == season.to_string())
            {
                std::vector<std::string> row;
                for (size_t j = 1; j < rw.column.size(); j++)
                {
                    row.push_back(rw.column[j]);
                }
                oneSeasonData.push_back(row);
            }
        }
        return oneSeasonData;
    }

}

