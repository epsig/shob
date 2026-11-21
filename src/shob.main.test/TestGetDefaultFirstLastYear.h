#pragma once

namespace shob::main::test
{
	class TestGetDefaultFirstLastYear
	{
	public:
		static void testDefaultIsCurrentYearWhenNoRemarksFile();
		static void testDefaultUsesNextEkwkYearWhenDefinedInRemarks();
	};
}
