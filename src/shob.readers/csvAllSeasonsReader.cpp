
#include "csvAllSeasonsReader.h"
#include "csvReader.h"

namespace shob::readers
{
    void csvAllSeasonsReader::init(const std::string& filename)
    {
        allData = csvReader::readCsvFile(filename);
        for (size_t i = 1; i < allData[0].size(); i++)
        {
            header.push_back(allData[0][i]);
        }
    }

    std::vector<std::vector<std::string>> csvAllSeasonsReader::getSeason(const std::string& season) const
    {
        std::vector<std::vector<std::string>> oneSeasonData;
        oneSeasonData.push_back(header);
        for (size_t i = 1; i < allData.size(); i++)
        {
            if (allData[i][0] == season)
            {
                std::vector<std::string> row;
                for (size_t j = 1; j < allData[i].size(); j++)
                {
                    row.push_back(allData[i][j]);
                }
                oneSeasonData.push_back(row);
            }
        }
        return oneSeasonData;
    }

}

