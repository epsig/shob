
#pragma once

#include <string>
#include <vector>
#include "../shob.general/UniqueStrings.h"

namespace shob::readers
{
    class CsvColContent
    {
    public:
        std::vector<std::string> column;
    };

    class CsvContent
    {
    public:
        CsvColContent header;
        std::vector<CsvColContent> body;
        size_t findColumn(const std::string& columnName) const;
        std::vector<std::string> findColumnNamesTeams() const;
        general::UniqueStrings getParts() const;
    };

    class CsvReader
    {
    public:
        static CsvContent readCsvFile(const std::string& filename);
        static CsvColContent split(const std::string& s, const std::string& delimiter);
    };
}
