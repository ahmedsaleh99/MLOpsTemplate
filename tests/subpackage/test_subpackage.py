"""
Contains Tests subpackage Fixture with a shared fixture
"""


class TestSubpackage:
    """
    Test class for subpackage fixtures.
    """

    def test_subpackage_fixture(self, subpackage_fixture: str):
        """
        Tests the subpackage fixture.

        Args:
            subpackage_fixture (str): A string returned by the subpackage fixture.
        """
        assert subpackage_fixture == "shared_fixture Plus subpackage_fixture"

    def test_shared_fixture(self, shared_fixture: str):
        """
        Tests the subpackage fixture.

        Args:
            shared_fixture (str): A string returned by the subpackage fixture.
        """
        assert shared_fixture == "shared_fixture"
