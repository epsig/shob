#pragma once

#include <map>
#include <string>

#include "../shob.general/MultipleStrings.h"

namespace shob::klaverjas
{
    class Versleutel
    {
    public:
        Versleutel(const size_t skip_header_lines, const std::string& sleutels_path)
            : skip_header_lines(skip_header_lines), sleutels_path(sleutels_path) {};
        general::MultipleStrings versleutelCode(const general::MultipleStrings& input);
    private:
        void versleutel(std::string& text, const std::map<std::string, std::string>& lijst);
        static std::string escape_regex(const std::string& text);
        size_t skip_header_lines = 9; // Number of header lines to skip
        std::string sleutels_path;
    };
}
