#include "TestCurrentEvents.h"
#include "../shob.test.utils/testUtils.h"
#include "../shob.bookmarks/CurrentEvents.h"
#include <gtest/gtest.h>

namespace shob::bookmarks::test
{
	using namespace readers::test;

	const std::string data_map = "../../data/bookmarks/";
	const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);

	void TestCurrentEvent::test1()
	{
		auto result = CurrentEvents::getCurrentBookmarks(data_folder, 20251225);
	}
}