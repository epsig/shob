#pragma once

#include "../shob.general/MultipleStrings.h"
#include <string>

namespace shob::general
{
    class FileIO
    {
    public:
        static MultipleStrings readFile(const std::string& path);
        static void writeToFile(const std::string& path, const MultipleStrings& data);
    };
}
