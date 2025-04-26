
#include "clubTeams.h"
#include "../shob.readers/csvReader.h"

namespace shob::teams
{
    void clubTeams::InitFromFile(const std::string& filename)
    {
        using namespace shob::readers;

        auto data = csvReader::readCsvFile(filename);
        Init(data);
    }

    std::string clubTeams::expand(const std::string& club)
    {
        return clubs.at(club);
    }

    void clubTeams::Init(const std::vector<std::vector<std::string>>& data)
    {
        for (size_t i=1; i < data.size(); i++)
        {
            clubs.insert({ data[i][0], data[i][1] });
        }
    }
}
