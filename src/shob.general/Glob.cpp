
#include "glob.h"

#include <filesystem>
#include <boost/regex.hpp>
#include "shobException.h"

namespace shob::general
{
    std::vector<std::string> glob::list(const std::string& path, const std::string& expr)
    {
        if (!std::filesystem::is_directory(path))
        {
            throw shobException(path + " is not a folder");
        }
        std::vector<std::string> file_list;

        boost::regex expression(expr);

        for (const auto& entry : std::filesystem::directory_iterator(path))
        {
            const auto full_name = entry.path().string();

            if (entry.is_regular_file())
            {
                const auto base_name = entry.path().filename().string();
                boost::cmatch what;
                if (regex_match(base_name.c_str(), what, expression))
                    file_list.push_back(base_name);
            }
        }
        return file_list;
    }
}
