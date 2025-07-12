
#pragma once

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
        static general::multipleStrings readFile(const std::string& path);
        static void writeToFile(const std::string& path, const general::multipleStrings& data);
    };
}
