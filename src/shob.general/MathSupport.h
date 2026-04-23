
#pragma once

namespace shob::general
{
    class MathSupport
    {
    public:
        template <class T>
        static double divide(T a, T b)
        {
            return static_cast<double>(a) / static_cast<double>(b);
        }

    };
}
