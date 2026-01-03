
#pragma once

#include "../shob.general/MultipleStrings.h"
#include <string>

namespace shob::html
{
    class updateIfDifferent
    {
    public:
        static void update(const std::string& path, const general::MultipleStrings& content);
        static void update(const std::string& path1, const std::string& path2);
    private:
        static general::MultipleStrings readFile(const std::string& path);
        static void writeToFile(const std::string& path, const general::MultipleStrings& data);
    };
}
