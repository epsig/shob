
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

    std::string clubTeams::expand(const std::string& club) const
    {
        if (club.size() == 3)
        {
            auto nlClub = "NL" + club;
            return clubs.at(nlClub);
        }
        else if (clubs.contains(club))
        {
            return clubs.at(club);
        }
        return club;
    }

    void clubTeams::Init(const readers::csvContent& data)
    {
        for (const auto& row : data.body)
        {
            clubs.insert({ row.column[0], row.column[1] });
        }
    }
}
