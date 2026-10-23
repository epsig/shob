#pragma once
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    enum class TechDocType
    {
        Klaverjas,
        Shob,
        Adressen,
    };

    class FormatRest
    {
    public:
        FormatRest(const std::string& data_folder) : data_folder(data_folder) {}
        void rebuildTechDoc(const TechDocType type, const int dd) const;
        general::MultipleStrings getTechDoc(const std::string& type_str, const TechDocType type, const int dd) const;
    private:
        std::string data_folder;
    };
}
