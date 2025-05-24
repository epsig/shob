
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

    void nationalTeams::Init(const readers::csvContent& data)
    {
        for (const auto& row : data.body)
        {
            countries.insert({ row.column[0], row.column[2] });
        }
    }
}
