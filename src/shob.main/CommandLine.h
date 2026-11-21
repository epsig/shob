#pragma once
#include <string>

namespace shob::main
{
    class CommandLine
    {
    public:
        static void readCommandLine(int argc, char* argv[], int& yr1, int&yr2, bool& skip_kj);
    };
}
