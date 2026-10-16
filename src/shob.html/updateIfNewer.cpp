
#include "updateIfNewer.h"
#include "../shob.general/FileIO.h"

namespace shob::html
{
    using namespace shob::general;

    /// copies path1 to path2, but only if their content is different
    /// @param path1 source file
    /// @param path2 destination file
    void updateIfDifferent::update(const std::string& path1, const std::string& path2)
    {
        auto previousVersion = FileIO::readFile(path1);
        auto newVersion = FileIO::readFile(path2);
        if (!previousVersion.areEqual(newVersion))
        {
            FileIO::writeToFile(path2, previousVersion);
        }
    }

    void updateIfDifferent::update(const std::string& path, const MultipleStrings& content)
    {
        auto previousVersion = FileIO::readFile(path);

        if ( !previousVersion.areEqual(content))
        {
            FileIO::writeToFile(path, content);
        }
    }
}
