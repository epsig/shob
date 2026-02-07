
#pragma once

#include <string>
#include <vector>

namespace shob::pages
{
    class FormatOnePage
    {
    public:
        virtual ~FormatOnePage() = default;
        virtual std::string getOutputFilename(const std::string& folder) const = 0;
    protected:
        static void sortArchive(std::vector<std::string>& archive);
    };
}
