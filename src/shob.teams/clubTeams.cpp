
#include "clubTeams.h"
#include "../shob.readers/csvReader.h"

namespace shob::teams
{
    using namespace shob::readers;

    void clubTeams::InitFromFile(const std::string& filename)
    {
        auto data = csvReader::readCsvFile(filename);
        Init(data);
    }

    void clubTeams::AddLandCodes(const std::string& filename)
    {
        auto data = csvReader::readCsvFile(filename);
        for (const auto& row : data.body)
        {
            landCodes.insert({ row.column[0], row.column[2] }); // TODO depending language
        }
    }

    std::string clubTeams::expand(const std::string& club, const bool addCountry) const
    {
        auto expanded = expand(club);
        auto land = club.substr(0, 2);
        if (addCountry && land != "NL")
        {
            auto shortName = land;
            if (land == "G1") shortName = "ENG"; // TODO naar class landcodes
            else if (land == "G2") shortName = "SCT";
            else if (land == "G3") shortName = "WLS";
            else if (land == "G4") shortName = "ULS";
            if (landCodes.contains(land))
            {
                auto fullNameLand = landCodes.at(land);
                expanded +=  " (<acronym title=\"" + fullNameLand + "\">" + shortName + "</acronym>)";
            }
            else
            {
                expanded += " (" + shortName + ")";
            }
        }
        return expanded;
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
