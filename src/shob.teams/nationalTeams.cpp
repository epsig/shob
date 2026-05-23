
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

    std::string nationalTeams::expand(const std::string& landcode) const
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

    bool nationalTeams::contains(const std::string& landcode) const
    {
        return countries.contains(landcode);
    }

    std::string nationalTeams::shortName(const std::string& land)
    {
        auto shortName = land;
        if (land == "G1") shortName = "ENG";
        else if (land == "G2") shortName = "SCT";
        else if (land == "G3") shortName = "WLS";
        else if (land == "G4") shortName = "ULS";
        return shortName;
    }

}
