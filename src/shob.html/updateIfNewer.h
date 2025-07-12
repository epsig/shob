
#pragma once
#include "table.h"
#include "../shob.general/multipleStrings.h"
#include <string>

namespace shob::html
{
    class updateIfDifferent
    {
    public:
        static void update(const std::string& path, const general::multipleStrings& content);
        static void update(const std::string& path1, const std::string& path2);
    private:
        static bool areEqual(const std::vector<std::string>& prev, const std::vector<std::string>& current);
        static std::vector<std::string> readFile(const std::string& path);
        static void writeToFile(const std::string& path, const std::vector<std::string>& data);
    };
}
