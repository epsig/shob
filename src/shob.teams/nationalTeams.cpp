
#include "nationalTeams.h"
#include "../shob.readers/csvReader.h"

namespace shob::teams
{
    void nationalTeams::InitFromFile(const std::string& filename)
    {
        using namespace shob::readers;

        auto data = csvReader::readCsvFile(filename);
        Init(data);
    }

    std::string nationalTeams::expand(const std::string& landcode)
    {
        return countries.at(landcode);
    }

    void nationalTeams::Init(const std::vector<std::vector<std::string>>& data)
    {
        for (size_t i = 1; i < data.size(); i++)
        {
            countries.insert({ data[i][0], data[i][2] });
        }
    }
}
