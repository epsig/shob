
#pragma once
#include <string>
#include <vector>

namespace shob::html
{
    class table
    {
    public:
        static std::vector<std::string> buildTable(const std::vector<std::vector<std::string>>& content);
    private:
        static std::string buildRow(const std::vector<std::string>& content);
        static std::string buildHeader(const std::vector<std::string>& content);
    };
}
