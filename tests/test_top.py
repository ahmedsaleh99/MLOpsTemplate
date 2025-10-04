"""
Test the top fixture with a fixture
"""


def test_shared_fixture(shared_fixture: str):
    """
    Test the shared fixture.
    This test uses the shared fixture defined in conftest.py.

    Args:
        shared_fixture (str): a string returned by the shared fixture
    """
    assert shared_fixture == "shared_fixture"
