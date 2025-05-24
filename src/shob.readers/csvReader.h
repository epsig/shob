
#pragma once

#include <string>
#include <vector>

namespace shob::readers
{
    class csvColContent
    {
    public:
        std::vector<std::string> column;
    };

    class csvContent
    {
    public:
        csvColContent header;
        std::vector<csvColContent> body;
    };

    class csvReader
    {
    public:
        static csvContent readCsvFile(const std::string& filename);
        static size_t findColumn(const std::string& columnName, const csvColContent& header);
        static csvColContent split(const std::string& s, const std::string& delimiter);
    private:
        static std::string rtrim(const std::string& s, const char* t);
        static std::string ltrim(const std::string& s, const char* t);
        static std::string trim(const std::string& s, const char* t);
    };

}

