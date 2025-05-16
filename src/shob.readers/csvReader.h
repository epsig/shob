
#pragma once

#include <string>
#include <vector>

namespace shob::readers
{
    class csvReader
    {
    public:
        static std::vector<std::vector<std::string>> readCsvFile(const std::string& filename);
        static size_t findColumn(const std::string& columnName, const std::vector<std::string>& header);
        static std::vector<std::string> split(const std::string& s, const std::string& delimiter);
    private:
        static std::string rtrim(const std::string& s, const char* t);
        static std::string ltrim(const std::string& s, const char* t);
        static std::string trim(const std::string& s, const char* t);
    };

}

